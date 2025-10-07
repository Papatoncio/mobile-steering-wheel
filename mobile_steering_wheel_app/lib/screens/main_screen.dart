import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final int angle;
  final VoidCallback onThrottle;
  final VoidCallback onBrake;
  final VoidCallback onGearUp;
  final VoidCallback onGearDown;
  final VoidCallback onCruiseControl;
  final VoidCallback onOpenSettings;

  const MainScreen({
    super.key,
    required this.angle,
    required this.onThrottle,
    required this.onBrake,
    required this.onGearUp,
    required this.onGearDown,
    required this.onCruiseControl,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botones de marcha
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: onCruiseControl,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          child: const Icon(Icons.lock,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: onGearUp,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          child: const Icon(Icons.arrow_upward,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: onGearDown,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          child: const Icon(Icons.arrow_downward,
                              color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),

                // Ángulo de Inclinación
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      "Ángulo: ${angle.toStringAsFixed(1)}°",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),

                // Acelerador
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTapDown: (_) => {onThrottle()},
                          onTapUp: (_) => {onThrottle()},
                          onTapCancel: () => {onThrottle()},
                          child: OutlinedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                            ),
                            child: const Icon(Icons.arrow_upward,
                                color: Colors.white, size: 20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTapDown: (_) => {onBrake()},
                          onTapUp: (_) => {onBrake()},
                          onTapCancel: () => {onBrake()},
                          child: OutlinedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                            ),
                            child: const Icon(Icons.arrow_downward,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 32),
                onPressed: onOpenSettings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
