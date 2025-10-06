import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final int angle;
  final double throttle;
  final void Function(double) onThrottleChange;
  final VoidCallback onGearUp;
  final VoidCallback onGearDown;
  final VoidCallback onOpenSettings;

  const MainScreen({
    super.key,
    required this.angle,
    required this.throttle,
    required this.onThrottleChange,
    required this.onGearUp,
    required this.onGearDown,
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
                        horizontal: 20, vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: onGearUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(25),
                          ),
                          child: const Icon(Icons.arrow_upward,
                              color: Colors.white, size: 28),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: onGearDown,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(25),
                          ),
                          child: const Icon(Icons.arrow_downward,
                              color: Colors.white, size: 28),
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
                      style: const TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  ),
                ),

                // Acelerador
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Slider(
                        value: 1 - throttle,
                        onChanged: (v) => onThrottleChange(1 - v),
                        min: 0,
                        max: 1,
                        activeColor:
                        throttle < 0.5 ? Colors.green : Colors.redAccent,
                        inactiveColor: Colors.grey.shade700,
                      ),
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
