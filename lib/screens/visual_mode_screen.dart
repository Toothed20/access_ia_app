import 'package:flutter/material.dart';

class VisualModeScreen extends StatelessWidget {
  const VisualModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Volver al menú principal',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Tarjeta superior de instrucciones
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
                      'Toca o mantén presionado el centro',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Apuntando cámara para describir entorno',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Botón Gigante Central (Walkie-Talkie)
            Semantics(
              button: true,
              label: 'Botón de captura y dictado. Toca dos veces para un vistazo general, o toca dos veces y mantén presionado para preguntar.',
              child: GestureDetector(
                onTap: () {
                  // Lógica futura para "Vistazo General"
                  print("Vistazo rápido activado");
                },
                onLongPress: () {
                  // Lógica futura para iniciar grabación de audio
                  print("Grabando instrucción de voz...");
                },
                onLongPressUp: () {
                  // Lógica futura para detener grabación y enviar a Gemini
                  print("Capturando foto y enviando solicitud a Gemini...");
                },
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE400),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFEE400).withOpacity(0.2),
                        blurRadius: 40,
                        spreadRadius: 15,
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mic, size: 80, color: Colors.black),
                      SizedBox(height: 8),
                      Text(
                        'DESCRIPCIÓN',
                        style: TextStyle(
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

            const SizedBox(height: 32),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: Color(0xFFFEE400), size: 16),
                SizedBox(width: 8),
                Text(
                  'Presiona para escuchar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Tarjeta inferior de lectura (Mockup de respuesta de Gemini)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  SizedBox(height: 12),
                  Text(
                    '"Frente a ti hay una mesa a 1.5 metros con una botella con agua y paso libre a la derecha hacia una puerta abierta."',
                    style: TextStyle(
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
