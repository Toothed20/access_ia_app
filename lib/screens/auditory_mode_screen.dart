import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../services/api_service.dart';

class AuditoryModeScreen extends StatefulWidget {
  const AuditoryModeScreen({super.key});

  @override
  State<AuditoryModeScreen> createState() => _AuditoryModeScreenState();
}

class _AuditoryModeScreenState extends State<AuditoryModeScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isProcessing = false;
  String _spokenText = 'Toca el botón central y comienza a hablar...';
  String _geminiResponse = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // Activa el micrófono y escucha al usuario
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          // Cuando detecta que el usuario dejó de hablar (pausa larga)
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
            if (_spokenText.isNotEmpty &&
                _spokenText != 'Toca el botón central y comienza a hablar...' &&
                _spokenText != 'Escuchando...') {
              _sendToBackend(_spokenText);
            }
          }
        },
        onError: (errorNotification) {
          setState(() {
            _isListening = false;
            _spokenText = 'No se pudo escuchar claramente. Intenta de nuevo.';
          });
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
          _geminiResponse = ''; // Limpiamos respuestas anteriores
          _spokenText = 'Escuchando...';
        });
        _speech.listen(
          onResult: (val) => setState(() {
            _spokenText = val.recognizedWords;
          }),
          localeId: 'es_MX', // Fuerza el reconocimiento en Español de México
        );
      }
    } else {
      // Detiene la escucha manualmente si el usuario vuelve a presionar el botón
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  // Envía el texto transcrito al servidor de Render
  // Envía el texto transcrito al servidor de Render
  Future<void> _sendToBackend(String textToProcess) async {
    setState(() {
      _isProcessing = true;
      _geminiResponse = 'Procesando respuesta con IA...';
    });

    var result = await ApiService.processAuditoryText(textToProcess);

    setState(() {
      _isProcessing = false;
      if (result != null) {
        // Extraemos las llaves exactas que tu compañero configuró en el backend de Python
        String cleanText = result['clean_text'] ?? '';
        List<dynamic> smartReplies = result['smart_replies'] ?? [];

        // Construimos un texto final formateado y limpio
        String formattedOutput = cleanText;

        if (smartReplies.isNotEmpty) {
          // Unimos la lista de respuestas inteligentes con saltos de línea y viñetas
          formattedOutput +=
              '\n\nSugerencias de respuesta:\n• ' + smartReplies.join('\n• ');
        }

        // Respaldo por si el backend llega a enviar un formato distinto en el futuro
        if (formattedOutput.trim().isEmpty) {
          formattedOutput = result.toString();
        }

        _geminiResponse = formattedOutput;
      } else {
        _geminiResponse =
            'Ocurrió un error al procesar el texto con el servidor.';
      }
    });
  }

  @override
  void dispose() {
    _speech.stop();
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
            _speech.stop();
            Navigator.pop(context);
          },
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
                      Icon(Icons.hearing_disabled, color: Colors.cyanAccent),
                      SizedBox(width: 8),
                      Text(
                        'Modo Asistente Auditivo',
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
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Para personas con discapacidad auditiva',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ), // Reemplazamos el Spacer() por un margen fijo
            // Botón Central (Micrófono) - Tamaño optimizado a 180px
            Semantics(
              button: true,
              label: 'Activar micrófono',
              child: GestureDetector(
                onTap: _isProcessing ? null : _listen,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: _isListening
                        ? Colors.redAccent
                        : (_isProcessing ? Colors.grey : Colors.cyanAccent),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (_isListening
                                    ? Colors.redAccent
                                    : (_isProcessing
                                          ? Colors.grey
                                          : Colors.cyanAccent))
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
                        Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          size: 60,
                          color: Colors.black,
                        ),
                      const SizedBox(height: 16),
                      Text(
                        _isListening
                            ? 'ESCUCHANDO...'
                            : (_isProcessing ? 'ANALIZANDO...' : 'ESCUCHAR'),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Pantalla de Subtítulos (Ahora tiene libertad total de expandirse)
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
                    const Text(
                      'Se escuchó:',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _spokenText,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Divider(
                      color: Colors.white24,
                      height: 24,
                      thickness: 1,
                    ),

                    const Row(
                      children: [
                        Icon(Icons.closed_caption, color: Colors.cyanAccent),
                        SizedBox(width: 8),
                        Text(
                          'RESPUESTA',
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Texto principal
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          _geminiResponse,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
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
