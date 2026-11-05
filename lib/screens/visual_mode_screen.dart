import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../services/api_service.dart';

class VisualModeScreen extends StatefulWidget {
  const VisualModeScreen({super.key});

  @override
  State<VisualModeScreen> createState() => _VisualModeScreenState();
}

class _VisualModeScreenState extends State<VisualModeScreen> {
  bool _isProcessing = false;
  String _lastDescription = 'Toca el botón central para analizar tu entorno.';
  final FlutterTts _flutterTts = FlutterTts();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  // Configura el sintetizador de voz en español
  void _initTts() async {
    await _flutterTts.setLanguage("es-MX"); // Español de México
    await _flutterTts.setSpeechRate(0.5); // Velocidad moderada y clara
    await _flutterTts.setPitch(1.0);
  }

  // Lógica principal: Toma la foto, la envía a la API y habla el resultado
  Future<void> _captureAndAnalyze() async {
    setState(() {
      _isProcessing = true;
      _lastDescription = 'Procesando imagen con IA...';
    });

    try {
      // 1. Abre la cámara nativa del teléfono
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

      if (photo != null) {
        // 2. Envía la foto al backend (usando el ApiService que creaste)
        String result = await ApiService.analyzeImage(File(photo.path));

        setState(() {
          _lastDescription = result;
        });

        // 3. Lee la respuesta en voz alta
        await _flutterTts.speak(result);
      } else {
        // El usuario canceló la foto
        setState(() {
          _lastDescription = 'Captura cancelada.';
        });
      }
    } catch (e) {
      setState(() {
        _lastDescription = 'Ocurrió un error al procesar la imagen.';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            _flutterTts.stop();
            Navigator.pop(context);
          },
          tooltip: 'Volver al menú principal',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Tarjeta superior
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF201F1F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.visibility, color: Color(0xFFFEE400)),
                      SizedBox(width: 8),
                      Text(
                        'Modo Asistente Visual',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Toca el botón central para escanear',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Botón Gigante Central Dinámico
            Semantics(
              button: true,
              label: 'Botón de captura. Toca para tomar una foto y escuchar la descripción del entorno.',
              child: GestureDetector(
                onTap: _isProcessing ? null : _captureAndAnalyze,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: _isProcessing
                        ? Colors.grey
                        : const Color(0xFFFEE400),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (_isProcessing
                                    ? Colors.grey
                                    : const Color(0xFFFEE400))
                                .withOpacity(0.2),
                        blurRadius: 40,
                        spreadRadius: 15,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isProcessing)
                        const CircularProgressIndicator(color: Colors.black)
                      else
                        const Icon(
                          Icons.camera_alt,
                          size: 80,
                          color: Colors.black,
                        ),

                      const SizedBox(height: 16),
                      Text(
                        _isProcessing ? 'ANALIZANDO...' : 'ESCANEAR',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Tarjeta inferior de lectura dinámica
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.volume_up, color: Colors.cyan),
                      SizedBox(width: 8),
                      Text(
                        'ÚLTIMA LECTURA POR VOZ',
                        style: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _lastDescription,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
