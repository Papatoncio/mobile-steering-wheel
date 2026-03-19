import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/wheel_controller.dart';
import '../widgets/analog_pedal.dart';

// ── Enums ──────────────────────────────────────────────────────────────────────

enum Camera { one, two, three }
enum RouteAdvisor { navigation, currentDelivery, assistance, information, chat }

// ── MainScreen ─────────────────────────────────────────────────────────────────

class MainScreen extends StatelessWidget {
  final WheelController ctrl;
  final VoidCallback onOpenSettings;

  // ── Constantes de estilo ──────────────────────────────────────────────────
  static const double btnSize  = 20;
  static const double iconSize = 20;
  static const Color  bgColor  = Colors.black;
  static const Color  btnBg    = Colors.transparent;
  static const Color  btnPress = Colors.white;
  static const Color  iconIdle = Colors.white;
  static const Color  iconPress= Colors.black;
  static const Color  txtColor = Colors.white;
  static const AnimationStyle menuAnim = AnimationStyle(
    curve: Easing.emphasizedDecelerate,
    duration: Duration(seconds: 1),
  );

  const MainScreen({
    super.key,
    required this.ctrl,
    required this.onOpenSettings,
  });

  // ── Botón circular estándar ───────────────────────────────────────────────

  Widget _btn({
    required IconData icon,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? btnPress : btnBg,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(btnSize),
        elevation: active ? 6 : 2,
      ),
      child: Icon(icon,
          color: active ? iconPress : iconIdle, size: iconSize),
    );
  }

  // ── Botón hold (GestureDetector) ─────────────────────────────────────────

  Widget _holdBtn({
    required IconData icon,
    required bool active,
    required VoidCallback onDown,
    required VoidCallback onUp,
  }) {
    return GestureDetector(
      onTapDown: (_) => onDown(),
      onTapUp: (_) => onUp(),
      onTapCancel: onUp,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: active ? btnPress : btnBg,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(btnSize),
        ),
        child: Icon(icon,
            color: active ? iconPress : iconIdle, size: iconSize),
      ),
    );
  }

  // ── Indicador LED de conexión ─────────────────────────────────────────────

  Widget _connectionLed(bool connected) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: connected ? Colors.greenAccent : Colors.redAccent,
            shape: BoxShape.circle,
            boxShadow: [
              if (connected)
                BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.6),
                    blurRadius: 6),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          connected ? 'Conectado' : 'Sin conexión',
          style: TextStyle(
            color: connected ? Colors.greenAccent : Colors.redAccent,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ── Columna izquierda ─────────────────────────────────────────────────────

  Widget _leftColumn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _btn(icon: FontAwesomeIcons.gaugeHigh, onTap: ctrl.pressCruiseControl),
            const SizedBox(height: 16),
            _btn(icon: FontAwesomeIcons.arrowUp, onTap: ctrl.pressGearUp),
            const SizedBox(height: 16),
            _btn(icon: FontAwesomeIcons.arrowDown, onTap: ctrl.pressGearDown),
            const SizedBox(height: 16),
            _btn(icon: FontAwesomeIcons.lightbulb, onTap: ctrl.pressHeadlights),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _holdBtn(
              icon: FontAwesomeIcons.handPointer,
              active: ctrl.interact,
              onDown: ctrl.toggleInteract,
              onUp: ctrl.toggleInteract,
            ),
            const SizedBox(height: 16),
            _holdBtn(
              icon: FontAwesomeIcons.bullhorn,
              active: ctrl.horn,
              onDown: () => ctrl.toggleHorn(true),
              onUp: () => ctrl.toggleHorn(false),
            ),
            const SizedBox(height: 16),
            _btn(icon: FontAwesomeIcons.cloudRain, onTap: ctrl.pressWiper),
            const SizedBox(height: 16),
            _btn(icon: FontAwesomeIcons.sun, onTap: ctrl.pressHighBeams),
          ],
        ),
      ],
    );
  }

  // ── Columna derecha ────────────────────────────────────────────────────────

  Widget _rightColumn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _btn(icon: FontAwesomeIcons.powerOff,       onTap: ctrl.pressTurnOnEngine),
            const SizedBox(height: 16),
            _btn(icon: FontAwesomeIcons.trailer,        onTap: ctrl.pressPickDrop),
            const SizedBox(height: 16),
            _btn(icon: FontAwesomeIcons.triangleExclamation, onTap: ctrl.pressBlinker),
            const SizedBox(height: 16),
            _btn(icon: FontAwesomeIcons.arrowLeft,      onTap: ctrl.pressLeftSignal),
          ],
        ),
        const SizedBox(width: 10),

        // Pedales analógicos (throttle + brake)
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AnalogPedal(
                color: Colors.green,
                icon: FontAwesomeIcons.truckFast,
                label: 'ACELERADOR',
                onValueChanged: ctrl.setThrottle,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: AnalogPedal(
                color: Colors.red,
                icon: FontAwesomeIcons.solidTruck,
                label: 'FRENO',
                onValueChanged: ctrl.setBrake,
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _btn(icon: FontAwesomeIcons.ban,       onTap: ctrl.pressHandBrake),
            const SizedBox(height: 16),
            _btn(icon: FontAwesomeIcons.arrowRight, onTap: ctrl.pressRightSignal),
          ],
        ),
      ],
    );
  }

  // ── Menú de cámaras ────────────────────────────────────────────────────────

  Widget _cameraMenu() {
    return PopupMenuButton<Camera>(
      color: Colors.white,
      offset: const Offset(0, 40),
      popUpAnimationStyle: menuAnim,
      style: ElevatedButton.styleFrom(
          backgroundColor: btnBg,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(btnSize)),
      icon: const Icon(FontAwesomeIcons.camera, color: iconIdle, size: iconSize),
      onSelected: (cam) {
        switch (cam) {
          case Camera.one:   ctrl.pressCameraOne();   break;
          case Camera.two:   ctrl.pressCameraTwo();   break;
          case Camera.three: ctrl.pressCameraThree(); break;
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: Camera.one,   child: Icon(FontAwesomeIcons.one,   color: Colors.black, size: iconSize)),
        PopupMenuItem(value: Camera.two,   child: Icon(FontAwesomeIcons.two,   color: Colors.black, size: iconSize)),
        PopupMenuItem(value: Camera.three, child: Icon(FontAwesomeIcons.three, color: Colors.black, size: iconSize)),
      ],
    );
  }

  // ── Menú asesor de rutas ────────────────────────────────────────────────────

  Widget _routeMenu() {
    return PopupMenuButton<RouteAdvisor>(
      color: Colors.white,
      offset: const Offset(0, 40),
      popUpAnimationStyle: menuAnim,
      style: ElevatedButton.styleFrom(
          backgroundColor: btnBg,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(btnSize)),
      icon: const Icon(FontAwesomeIcons.route, color: iconIdle, size: iconSize),
      onSelected: (ra) {
        switch (ra) {
          case RouteAdvisor.navigation:       ctrl.pressRouteNav();        break;
          case RouteAdvisor.currentDelivery:  ctrl.pressRouteDelivery();   break;
          case RouteAdvisor.assistance:       ctrl.pressRouteAssistance(); break;
          case RouteAdvisor.information:      ctrl.pressRouteInfo();       break;
          case RouteAdvisor.chat:             ctrl.pressRouteChat();       break;
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: RouteAdvisor.navigation,      child: Icon(FontAwesomeIcons.mapLocationDot, color: Colors.black, size: iconSize)),
        PopupMenuItem(value: RouteAdvisor.currentDelivery, child: Icon(FontAwesomeIcons.truckRampBox,   color: Colors.black, size: iconSize)),
        PopupMenuItem(value: RouteAdvisor.assistance,      child: Icon(FontAwesomeIcons.truckMedical,   color: Colors.black, size: iconSize)),
        PopupMenuItem(value: RouteAdvisor.information,     child: Icon(FontAwesomeIcons.circleInfo,     color: Colors.black, size: iconSize)),
        PopupMenuItem(value: RouteAdvisor.chat,            child: Icon(FontAwesomeIcons.comments,       color: Colors.black, size: iconSize)),
      ],
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Layout principal ────────────────────────────────────────────
            Row(
              children: [
                // Pedal zone izquierda (freno visual exterior)
                SizedBox(
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 6),
                    child: AnalogPedal(
                      color: Colors.orangeAccent,
                      icon: FontAwesomeIcons.ban,
                      label: 'MANO',
                      onValueChanged: (v) {
                        if (v > 0.5) ctrl.pressHandBrake();
                      },
                    ),
                  ),
                ),

                // Botones izquierda
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: _leftColumn(),
                  ),
                ),

                // Centro — ángulo
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Ángulo',
                          style: TextStyle(color: txtColor, fontSize: 13)),
                      Text(
                        '${ctrl.angle.toStringAsFixed(1)}°',
                        style: const TextStyle(color: txtColor, fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // Mini barra de volante
                      SizedBox(
                        width: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (ctrl.angle + 45) / 90,
                            backgroundColor: Colors.white12,
                            color: Colors.blueAccent,
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Botones derecha
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: _rightColumn(),
                  ),
                ),
              ],
            ),

            // ── Overlay superior izquierdo: cámaras + ruta ──────────────────
            Positioned(
              top: 6,
              left: 60,
              child: Row(
                children: [
                  _cameraMenu(),
                  const SizedBox(width: 6),
                  _routeMenu(),
                ],
              ),
            ),

            // ── LED de conexión (superior centro) ───────────────────────────
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(child: _connectionLed(ctrl.isConnected)),
            ),

            // ── Botón settings (superior derecho) ───────────────────────────
            Positioned(
              top: 6,
              right: 6,
              child: ElevatedButton(
                onPressed: onOpenSettings,
                style: ElevatedButton.styleFrom(
                    backgroundColor: btnBg,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(btnSize)),
                child: const Icon(FontAwesomeIcons.gear,
                    color: iconIdle, size: iconSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
