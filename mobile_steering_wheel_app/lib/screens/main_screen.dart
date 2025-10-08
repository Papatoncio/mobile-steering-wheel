import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Camera { one, two, three }

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
  final VoidCallback onHandBrake;
  final VoidCallback onHeadlights;
  final VoidCallback onHighBeams;
  final VoidCallback onHorn;
  final void Function(Camera) onCameraChange;
  final VoidCallback onOpenSettings;

  static const double btnSize = 20;
  static const double iconSize = 20;
  static const EdgeInsets sectionPadding =
      EdgeInsets.symmetric(horizontal: 40, vertical: 8);
  static const EdgeInsets columnPadding = EdgeInsets.symmetric(horizontal: 4);
  static const EdgeInsets menuPadding =
      EdgeInsets.symmetric(horizontal: 4, vertical: 4);
  static const AnimationStyle menuAnimation = AnimationStyle(
    curve: Easing.emphasizedDecelerate,
    duration: Duration(seconds: 3),
  );

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
    required this.onHandBrake,
    required this.onHeadlights,
    required this.onHighBeams,
    required this.onHorn,
    required this.onCameraChange,
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
                  flex: 2,
                  child: Padding(
                    padding: sectionPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: columnPadding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Cruise Control
                              OutlinedButton(
                                onPressed: onCruiseControl,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.gaugeHigh,
                                    color: Colors.white, size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Gear Up
                              OutlinedButton(
                                onPressed: onGearUp,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.arrowUp,
                                    color: Colors.white, size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Gear Down
                              OutlinedButton(
                                onPressed: onGearDown,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.arrowDown,
                                    color: Colors.white, size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Headlights
                              OutlinedButton(
                                onPressed: onHeadlights,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.lightbulb,
                                    color: Colors.white, size: iconSize),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: columnPadding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Interact
                              OutlinedButton(
                                onPressed: onInteract,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.handPointer,
                                    color: Colors.white, size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Horn
                              OutlinedButton(
                                onPressed: onHorn,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.bullhorn,
                                    color: Colors.white, size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Windshield Wiper
                              OutlinedButton(
                                onPressed: onWindshieldWiper,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.cloudRain,
                                    color: Colors.white, size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // High Beams
                              OutlinedButton(
                                onPressed: onHighBeams,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.sun,
                                    color: Colors.white, size: iconSize),
                              ),
                            ],
                          ),
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
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),

                // Acelerador y freno
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: sectionPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: columnPadding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Turn On / Off Engine
                              OutlinedButton(
                                onPressed: onTurnOnOfEngine,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.powerOff,
                                    color: Colors.white, size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Pick / Drop Trailer
                              OutlinedButton(
                                onPressed: onPickDropTrailer,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.trailer,
                                    color: Colors.white, size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Blinker
                              OutlinedButton(
                                onPressed: onBlinker,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(
                                    FontAwesomeIcons.triangleExclamation,
                                    color: Colors.white,
                                    size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Left Signal
                              OutlinedButton(
                                onPressed: onLeftSignal,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.arrowLeft,
                                    color: Colors.white, size: iconSize),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: columnPadding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Throttle
                              GestureDetector(
                                onTapDown: (_) => onThrottle(),
                                onTapUp: (_) => onThrottle(),
                                onTapCancel: () => onThrottle(),
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(btnSize),
                                  ),
                                  child: const Icon(FontAwesomeIcons.truckFast,
                                      color: Colors.white, size: iconSize),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Brake
                              GestureDetector(
                                onTapDown: (_) => onBrake(),
                                onTapUp: (_) => onBrake(),
                                onTapCancel: () => onBrake(),
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(btnSize),
                                  ),
                                  child: const Icon(FontAwesomeIcons.solidTruck,
                                      color: Colors.white, size: iconSize),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Hand Brake
                              OutlinedButton(
                                onPressed: onHandBrake,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.ban,
                                    color: Colors.white, size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Right Signal
                              OutlinedButton(
                                onPressed: onRightSignal,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.arrowRight,
                                    color: Colors.white, size: iconSize),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Cameras
            Positioned(
              top: 10,
              left: 10,
              child: PopupMenuButton<Camera>(
                color: Colors.white,
                menuPadding: menuPadding,
                constraints: const BoxConstraints(maxWidth: 50),
                offset: const Offset(0, 40),
                popUpAnimationStyle: menuAnimation,
                icon: const Icon(FontAwesomeIcons.camera,
                    color: Colors.white, size: iconSize),
                onSelected: (Camera item) => {onCameraChange(item)},
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Camera>>[
                  // Camera 1
                  const PopupMenuItem<Camera>(
                    value: Camera.one,
                    child: Icon(FontAwesomeIcons.one,
                        color: Colors.black, size: iconSize),
                  ),

                  // Camera 2
                  const PopupMenuItem<Camera>(
                    value: Camera.two,
                    child: Icon(FontAwesomeIcons.two,
                        color: Colors.black, size: iconSize),
                  ),

                  // Camera 3
                  const PopupMenuItem<Camera>(
                    value: Camera.three,
                    child: Icon(FontAwesomeIcons.three,
                        color: Colors.black, size: iconSize),
                  ),
                ],
              ),
            ),

            // Settings
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(btnSize),
                ),
                icon: const Icon(FontAwesomeIcons.gear,
                    color: Colors.white, size: iconSize),
                onPressed: onOpenSettings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
