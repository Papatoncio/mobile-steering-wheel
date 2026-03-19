import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'controllers/wheel_controller.dart';
import 'screens/main_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Forzar landscape desde el inicio.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  // Evitar que la pantalla se apague mientras la app esté abierta.
  WakelockPlus.enable();

  runApp(const WheelApp());
}

class WheelApp extends StatelessWidget {
  const WheelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Steering Wheel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const _WheelRoot(),
    );
  }
}

class _WheelRoot extends StatefulWidget {
  const _WheelRoot();

  @override
  State<_WheelRoot> createState() => _WheelRootState();
}

class _WheelRootState extends State<_WheelRoot> with WidgetsBindingObserver {
  final WheelController _ctrl = WheelController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Reactiva el wakelock si el usuario vuelve a la app desde background.
    switch (state) {
      case AppLifecycleState.resumed:
        WakelockPlus.enable();
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        WakelockPlus.disable();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(controller: _ctrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _ctrl,
      builder: (context, _) {
        return MainScreen(
          ctrl: _ctrl,
          onOpenSettings: _openSettings,
        );
      },
    );
  }
}
