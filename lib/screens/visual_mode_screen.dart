import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    _initSystem();
  }

  Future<void> _initSystem() async {
    // Configura voz y da la instrucción inicial
    await _flutterTts.setLanguage("es-MX");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(
      "Has entrado al Asistente Visual. Apunta tu teléfono al frente y toca la pantalla para escanear.",
    );

    // Inicializa la cámara de forma silenciosa
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      setState(() => _lastDescription = 'Error al acceder a la cámara.');
    }
  }

  Future<void> _captureAndAnalyze() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    setState(() {
      _isProcessing = true;
      _lastDescription = 'Capturando y procesando imagen...';
    });
    await _flutterTts.speak("Analizando entorno, espera un momento.");

    try {
      // Captura instantánea sin abrir UI nativa
      final XFile photo = await _cameraController!.takePicture();

      String result = await ApiService.analyzeImage(File(photo.path));

      setState(() => _lastDescription = result);
      await _flutterTts.speak(result);
    } catch (e) {
      setState(
        () => _lastDescription = 'Ocurrió un error al procesar la imagen.',
      );
      await _flutterTts.speak("Error al conectar con el servidor.");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _cameraController?.dispose();
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
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

            Semantics(
              button: true,
              label: 'Capturar entorno',
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

            const SizedBox(
              height: 24,
            ), // Reemplaza el Spacer() inferior para acotar la caja
            // Tarjeta inferior flexible y scrolleable
            Expanded(
              child: Container(
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          _lastDescription,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
