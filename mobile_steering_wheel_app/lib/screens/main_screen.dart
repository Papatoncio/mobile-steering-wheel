import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatelessWidget {
  final int angle;
  final VoidCallback onThrottle;
  final VoidCallback onBrake;
  final VoidCallback onGearUp;
  final VoidCallback onGearDown;
  final VoidCallback onCruiseControl;
  final VoidCallback onTurnOnOfEngine;
  final VoidCallback onInteract;
  final VoidCallback onPickDropTrailer;
  final VoidCallback onLeftSignal;
  final VoidCallback onBlinker;
  final VoidCallback onRightSignal;
  final VoidCallback onWindshieldWiper;
  final VoidCallback onOpenSettings;

  const MainScreen({
    super.key,
    required this.angle,
    required this.onThrottle,
    required this.onBrake,
    required this.onGearUp,
    required this.onGearDown,
    required this.onCruiseControl,
    required this.onTurnOnOfEngine,
    required this.onInteract,
    required this.onPickDropTrailer,
    required this.onLeftSignal,
    required this.onBlinker,
    required this.onRightSignal,
    required this.onWindshieldWiper,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botones de marcha
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: onCruiseControl,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                ),
                                child: const Icon(FontAwesomeIcons.gaugeHigh,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(height: 20),
                              OutlinedButton(
                                onPressed: onGearUp,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                ),
                                child: const Icon(FontAwesomeIcons.arrowUp,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(height: 20),
                              OutlinedButton(
                                onPressed: onGearDown,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                ),
                                child: const Icon(FontAwesomeIcons.arrowDown,
                                    color: Colors.white, size: 20),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Ángulo de inclinación
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "Ángulo: ${angle.toStringAsFixed(1)}°",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),

                      // Acelerador y freno
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTapDown: (_) => onThrottle(),
                                onTapUp: (_) => onThrottle(),
                                onTapCancel: () => onThrottle(),
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(20),
                                  ),
                                  child: const Icon(FontAwesomeIcons.truckFast,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTapDown: (_) => onBrake(),
                                onTapUp: (_) => onBrake(),
                                onTapCancel: () => onBrake(),
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(20),
                                  ),
                                  child: const Icon(FontAwesomeIcons.solidTruck,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Interactuar
                      OutlinedButton(
                        onPressed: onInteract,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(FontAwesomeIcons.arrowPointer,
                            color: Colors.white, size: 20),
                      ),

                      // Acoplar / Desacoplar Remolque
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: onPickDropTrailer,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(FontAwesomeIcons.trailer,
                            color: Colors.white, size: 20),
                      ),

                      // Limpia Parabrisas
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: onWindshieldWiper,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(FontAwesomeIcons.cloudRain,
                            color: Colors.white, size: 20),
                      ),

                      // Direccional Izquierda
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: onLeftSignal,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(FontAwesomeIcons.arrowLeft,
                            color: Colors.white, size: 20),
                      ),

                      // Intermitentes
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: onBlinker,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(FontAwesomeIcons.triangleExclamation,
                            color: Colors.white, size: 20),
                      ),

                      // Direccional Derecha
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: onRightSignal,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(FontAwesomeIcons.arrowRight,
                            color: Colors.white, size: 20),
                      ),

                      // Encender / Apagar
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: onTurnOnOfEngine,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(FontAwesomeIcons.powerOff,
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(FontAwesomeIcons.gear,
                    color: Colors.white, size: 32),
                onPressed: onOpenSettings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
