import 'package:flutter/material.dart';

class AuditoryModeScreen extends StatelessWidget {
  const AuditoryModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      // AppBar transparente superpuesta para no romper el bloque amarillo
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Volver al menú',
        ),
      ),
      body: Column(
        children: [
          // MITAD SUPERIOR: Transcripción en Vivo (Amarillo)
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFFFEE400),
              padding: const EdgeInsets.only(
                top: 100,
                left: 24,
                right: 24,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Píldora de estado
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.graphic_eq, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'ESCUCHANDO EN VIVO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Texto de transcripción gigante
                  const Text(
                    '“Hola, buenas tardes. ¿Tiene cita previa o viene a consultar por primera vez?”',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                  const Spacer(),
                  // Indicador de micrófono
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.mic, color: Colors.black, size: 20),
                      SizedBox(width: 4),
                      Text(
                        'MIC ACTIVO',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // MITAD INFERIOR: Respuestas Rápidas (Oscuro)
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFF131313),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RESPUESTAS RÁPIDAS SUGERIDAS',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '1-Toque',
                        style: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Botón Inteligente 1
                  _buildSmartReplyButton(
                    Icons.event_available,
                    '“Sí, tengo turno a las 16:30”',
                  ),
                  const SizedBox(height: 12),
                  // Botón Inteligente 2
                  _buildSmartReplyButton(
                    Icons.person_add,
                    '“Es mi primera consulta”',
                  ),
                  const SizedBox(height: 12),
                  // Botón Inteligente 3
                  _buildSmartReplyButton(
                    Icons.edit_note,
                    'Prefiero escribir respuesta',
                    isDropdown: true,
                  ),

                  const Spacer(),

                  // Caja de texto manual
                  const Text(
                    'ESCRIBIR PARA MOSTRAR / HABLAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF201F1F),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Escribe tu respuesta...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.black,
                          size: 28,
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
    );
  }

  // Componente interno para reutilizar el diseño de los botones de respuesta
  Widget _buildSmartReplyButton(
    IconData icon,
    String text, {
    bool isDropdown = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyan),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(
            isDropdown ? Icons.keyboard_arrow_down : Icons.volume_up,
            color: isDropdown ? Colors.grey : Colors.cyan,
          ),
        ],
      ),
    );
  }
}
