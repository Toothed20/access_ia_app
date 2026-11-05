import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

import '../services/api_service.dart';

class AuditoryModeScreen extends StatefulWidget {
  const AuditoryModeScreen({super.key});

  @override
  State<AuditoryModeScreen> createState() => _AuditoryModeScreenState();
}

class _AuditoryModeScreenState extends State<AuditoryModeScreen> {
  late stt.SpeechToText _speech;
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _textController = TextEditingController();

  bool _isListening = false;
  bool _isProcessing = false;
  String _spokenText = 'Toca el botón central y comienza a hablar...';
  String _geminiResponse = '';
  List<String> _smartReplies = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("es-MX");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  // Reproduce texto en voz alta
  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
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
          _geminiResponse = '';
          _smartReplies = [];
          _spokenText = 'Escuchando...';
        });
        _speech.listen(
          onResult: (val) => setState(() {
            _spokenText = val.recognizedWords;
          }),
          localeId: 'es_MX',
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _sendToBackend(String textToProcess) async {
    setState(() {
      _isProcessing = true;
      _geminiResponse = 'Procesando respuesta con IA...';
    });

    var result = await ApiService.processAuditoryText(textToProcess);

    setState(() {
      _isProcessing = false;
      if (result != null) {
        _geminiResponse = result['clean_text'] ?? '';

        var replies = result['smart_replies'];
        if (replies is List) {
          _smartReplies = replies.map((e) => e.toString()).toList();
        } else {
          _smartReplies = [];
        }

        if (_geminiResponse.trim().isEmpty) {
          _geminiResponse = result.toString();
        }
      } else {
        _geminiResponse = 'Ocurrió un error al procesar el texto.';
        _smartReplies = [];
      }
    });
  }

  @override
  void dispose() {
    _speech.stop();
    _flutterTts.stop();
    _textController.dispose();
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
            _flutterTts.stop();
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

            const SizedBox(height: 16),

            // Botón Central (Micrófono)
            Semantics(
              button: true,
              label: 'Activar micrófono',
              child: GestureDetector(
                onTap: _isProcessing ? null : _listen,
                child: Container(
                  width: 140,
                  height: 140,
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
                          size: 50,
                          color: Colors.black,
                        ),
                      const SizedBox(height: 8),
                      Text(
                        _isListening
                            ? 'ESCUCHANDO...'
                            : (_isProcessing ? 'ANALIZANDO...' : 'ESCUCHAR'),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Pantalla de Subtítulos y Botones de Respuesta
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

                    // Texto principal transcrito limpio
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.closed_caption,
                                  color: Colors.cyanAccent,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'MENSAJE',
                                  style: TextStyle(
                                    color: Colors.cyanAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _geminiResponse,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            // Botones de respuesta inteligente
                            if (_smartReplies.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              const Text(
                                'Respuestas rápidas:',
                                style: TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: _smartReplies
                                    .map(
                                      (reply) => ActionChip(
                                        label: Text(reply),
                                        backgroundColor: const Color(
                                          0xFF131313,
                                        ),
                                        side: const BorderSide(
                                          color: Colors.cyanAccent,
                                        ),
                                        labelStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        onPressed: () => _speak(reply),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Campo de texto libre para respuesta personalizada
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Escribe tu respuesta...',
                              hintStyle: const TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: const Color(0xFF131313),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.cyanAccent,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.volume_up,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              if (_textController.text.isNotEmpty) {
                                _speak(_textController.text);
                                _textController.clear();
                                FocusScope.of(context)
                                    .unfocus(); // Oculta el teclado
                              }
                            },
                          ),
                        ),
                      ],
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
