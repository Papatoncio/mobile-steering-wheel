import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Camera { one, two, three }

enum RouteAdvisor { navigation, currentDelivery, assistance, information, chat }

class MainScreen extends StatelessWidget {
  // Variables
  final int angle;
  final bool throttle;
  final bool brake;
  final bool interact;
  final bool horn;

  // Methods
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
  final void Function(RouteAdvisor) onRouteAdvisorChange;
  final VoidCallback onOpenSettings;

  static const double btnSize = 20;
  static const double iconSize = 20;
  static const EdgeInsets sectionPadding =
      EdgeInsets.symmetric(horizontal: 80, vertical: 8);
  static const EdgeInsets columnPadding = EdgeInsets.symmetric(horizontal: 4);
  static const EdgeInsets menuPadding =
      EdgeInsets.symmetric(horizontal: 4, vertical: 4);
  static const AnimationStyle menuAnimation = AnimationStyle(
    curve: Easing.emphasizedDecelerate,
    duration: Duration(seconds: 1),
  );

  static const Color screenBackgroundColor = Colors.white70;
  static const Color btnIdleBackgroundColor = Colors.black;
  static const Color btnPressedBackgroundColor = Colors.white;
  static const Color iconIdleBackgroundColor = Colors.white;
  static const Color iconPressedBackgroundColor = Colors.black;
  static const Color textColor = Colors.black;

  const MainScreen({
    super.key,
    // Variables
    required this.angle,
    required this.throttle,
    required this.brake,
    required this.interact,
    required this.horn,

    // Methods
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
    required this.onRouteAdvisorChange,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botones de marcha
                Expanded(
                  flex: 3,
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
                              ElevatedButton(
                                onPressed: onCruiseControl,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnIdleBackgroundColor,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.gaugeHigh,
                                    color: iconIdleBackgroundColor,
                                    size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Gear Up
                              ElevatedButton(
                                onPressed: onGearUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnIdleBackgroundColor,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.arrowUp,
                                    color: iconIdleBackgroundColor,
                                    size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Gear Down
                              ElevatedButton(
                                onPressed: onGearDown,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnIdleBackgroundColor,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.arrowDown,
                                    color: iconIdleBackgroundColor,
                                    size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Headlights
                              ElevatedButton(
                                onPressed: onHeadlights,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnIdleBackgroundColor,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.lightbulb,
                                    color: iconIdleBackgroundColor,
                                    size: iconSize),
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
                              GestureDetector(
                                onDoubleTap: () => onInteract(),
                                onTapDown: (_) => onInteract(),
                                onTapUp: (_) => onInteract(),
                                onTapCancel: () => onInteract(),
                                child: ElevatedButton(
                                  onPressed: () => {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: interact
                                        ? btnPressedBackgroundColor
                                        : btnIdleBackgroundColor,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(btnSize),
                                  ),
                                  child: Icon(FontAwesomeIcons.handPointer,
                                      color: interact
                                          ? iconPressedBackgroundColor
                                          : iconIdleBackgroundColor,
                                      size: iconSize),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Horn
                              GestureDetector(
                                onDoubleTap: () => onHorn(),
                                onTapDown: (_) => onHorn(),
                                onTapUp: (_) => onHorn(),
                                onTapCancel: () => onHorn(),
                                child: ElevatedButton(
                                  onPressed: () => {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: horn
                                        ? btnPressedBackgroundColor
                                        : btnIdleBackgroundColor,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(btnSize),
                                  ),
                                  child: Icon(FontAwesomeIcons.bullhorn,
                                      color: horn
                                          ? iconPressedBackgroundColor
                                          : iconIdleBackgroundColor,
                                      size: iconSize),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Windshield Wiper
                              ElevatedButton(
                                onPressed: onWindshieldWiper,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnIdleBackgroundColor,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.cloudRain,
                                    color: iconIdleBackgroundColor,
                                    size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // High Beams
                              ElevatedButton(
                                onPressed: onHighBeams,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnIdleBackgroundColor,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.sun,
                                    color: iconIdleBackgroundColor,
                                    size: iconSize),
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
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Ángulo:",
                          style: TextStyle(color: textColor, fontSize: 24),
                        ),
                        Text(
                          "${angle.toStringAsFixed(1)}°",
                          style:
                              const TextStyle(color: textColor, fontSize: 24),
                        ),
                      ]),
                ),

                Expanded(
                  flex: 3,
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
                              ElevatedButton(
                                onPressed: onTurnOnOfEngine,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnIdleBackgroundColor,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.powerOff,
                                    color: iconIdleBackgroundColor,
                                    size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Pick / Drop Trailer
                              ElevatedButton(
                                onPressed: onPickDropTrailer,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnIdleBackgroundColor,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.trailer,
                                    color: iconIdleBackgroundColor,
                                    size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Blinker
                              ElevatedButton(
                                onPressed: onBlinker,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnIdleBackgroundColor,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(
                                    FontAwesomeIcons.triangleExclamation,
                                    color: iconIdleBackgroundColor,
                                    size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Left Signal
                              ElevatedButton(
                                onPressed: onLeftSignal,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnIdleBackgroundColor,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.arrowLeft,
                                    color: iconIdleBackgroundColor,
                                    size: iconSize),
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
                                onDoubleTap: () => onThrottle(),
                                onTapDown: (_) => onThrottle(),
                                onTapUp: (_) => onThrottle(),
                                onTapCancel: () => onThrottle(),
                                child: ElevatedButton(
                                  onPressed: () => {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: throttle
                                        ? btnPressedBackgroundColor
                                        : btnIdleBackgroundColor,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(btnSize),
                                  ),
                                  child: Icon(FontAwesomeIcons.truckFast,
                                      color: throttle
                                          ? iconPressedBackgroundColor
                                          : iconIdleBackgroundColor,
                                      size: iconSize),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Brake
                              GestureDetector(
                                onDoubleTap: () => onBrake(),
                                onTapDown: (_) => onBrake(),
                                onTapUp: (_) => onBrake(),
                                onTapCancel: () => onBrake(),
                                child: ElevatedButton(
                                  onPressed: () => {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: brake
                                        ? btnPressedBackgroundColor
                                        : btnIdleBackgroundColor,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(btnSize),
                                  ),
                                  child: Icon(FontAwesomeIcons.solidTruck,
                                      color: brake
                                          ? iconPressedBackgroundColor
                                          : iconIdleBackgroundColor,
                                      size: iconSize),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Hand Brake
                              ElevatedButton(
                                onPressed: onHandBrake,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnIdleBackgroundColor,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.ban,
                                    color: iconIdleBackgroundColor,
                                    size: iconSize),
                              ),
                              const SizedBox(height: 20),

                              // Right Signal
                              ElevatedButton(
                                onPressed: onRightSignal,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnIdleBackgroundColor,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(btnSize),
                                ),
                                child: const Icon(FontAwesomeIcons.arrowRight,
                                    color: iconIdleBackgroundColor,
                                    size: iconSize),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnIdleBackgroundColor,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(btnSize),
                ),
                icon: const Icon(FontAwesomeIcons.camera,
                    color: iconIdleBackgroundColor, size: iconSize),
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

            // Route Advisor
            Positioned(
              top: 80,
              left: 10,
              child: PopupMenuButton<RouteAdvisor>(
                color: Colors.white,
                menuPadding: menuPadding,
                constraints: const BoxConstraints(maxWidth: 60),
                offset: const Offset(0, 40),
                popUpAnimationStyle: menuAnimation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnIdleBackgroundColor,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(btnSize),
                ),
                icon: const Icon(FontAwesomeIcons.route,
                    color: iconIdleBackgroundColor, size: iconSize),
                onSelected: (RouteAdvisor item) => {onRouteAdvisorChange(item)},
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<RouteAdvisor>>[
                  // Navigation
                  const PopupMenuItem<RouteAdvisor>(
                    value: RouteAdvisor.navigation,
                    child: Icon(FontAwesomeIcons.mapLocationDot,
                        color: Colors.black, size: iconSize),
                  ),

                  // Current Delivery
                  const PopupMenuItem<RouteAdvisor>(
                    value: RouteAdvisor.currentDelivery,
                    child: Icon(FontAwesomeIcons.truckRampBox,
                        color: Colors.black, size: iconSize),
                  ),

                  // Assistance
                  const PopupMenuItem<RouteAdvisor>(
                    value: RouteAdvisor.assistance,
                    child: Icon(FontAwesomeIcons.truckMedical,
                        color: Colors.black, size: iconSize),
                  ),

                  // Information
                  const PopupMenuItem<RouteAdvisor>(
                    value: RouteAdvisor.information,
                    child: Icon(FontAwesomeIcons.circleInfo,
                        color: Colors.black, size: iconSize),
                  ),

                  // Chat
                  const PopupMenuItem<RouteAdvisor>(
                    value: RouteAdvisor.chat,
                    child: Icon(FontAwesomeIcons.comments,
                        color: Colors.black, size: iconSize),
                  ),
                ],
              ),
            ),

            // Settings
            Positioned(
              top: 10,
              right: 10,
              child: ElevatedButton(
                onPressed: onOpenSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnIdleBackgroundColor,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(btnSize),
                ),
                child: const Icon(FontAwesomeIcons.gear,
                    color: iconIdleBackgroundColor, size: iconSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
