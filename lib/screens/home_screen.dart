import 'visual_mode_screen.dart';

import 'package:flutter/material.dart';

import '../widgets/giant_mode_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.accessibility_new,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'MODO ACCESIBLE AAA',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Text(
                    '1 / 2',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Botón Visual
              Expanded(
                child: GiantModeButton(
                  title: 'Tengo discapacidad visual',
                  subtitle: 'Lectura de voz, texturas y zoom táctil',
                  icon: Icons.visibility_off,
                  iconColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer, // Amarillo
                  backgroundColor: const Color(
                    0xFF1C1B1B,
                  ), // surface-container-low
                  semanticsLabel: 'Tengo discapacidad visual. Pulsa para configurar modo de asistencia por voz y alto contraste extremo.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VisualModeScreen(),
                      ),
                    );
                  },
                ),
              ),

              // Divisor
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'O BIEN',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
              ),

              // Botón Auditivo
              Expanded(
                child: GiantModeButton(
                  title: 'Tengo discapacidad auditiva',
                  subtitle: 'Subtítulos vivos, destellos y vibración',
                  icon: Icons.hearing_disabled,
                  iconColor: const Color(0xFF9CFFFF), // secondary-fixed (Cyan)
                  backgroundColor: const Color(0xFF1C1B1B),
                  semanticsLabel: 'Tengo discapacidad auditiva. Pulsa para configurar avisos visuales, transcripciones y subtítulos.',
                  onTap: () {
                    // Navegación futura al modo auditivo
                    print("Navegando a Modo Auditivo...");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
