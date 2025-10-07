import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:udp/udp.dart';

import 'screens/main_screen.dart';
import 'screens/settings_screen.dart';

void main() => runApp(const WheelApp());

class WheelApp extends StatelessWidget {
  const WheelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainWheelScreen(),
    );
  }
}

class MainWheelScreen extends StatefulWidget {
  const MainWheelScreen({super.key});

  @override
  State<MainWheelScreen> createState() => _MainWheelScreenState();
}

class _MainWheelScreenState extends State<MainWheelScreen> {
  int angle = 0;
  double throttle = 0.0;
  double sensitivity = 1.0;
  bool gearUp = false;
  bool gearDown = false;
  UDP? sender;
  final TextEditingController ipController = TextEditingController();
  final int port = 5005;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    accelerometerEvents.listen((event) {
      setState(() {
        angle = ((((-event.y.clamp(-9.8, 9.8) / 9.8) * 45) * sensitivity) * -1)
            .toInt();
      });
      _sendData();
    });
  }

  Future<void> _connect(String ip) async {
    sender = await UDP.bind(Endpoint.any());
    ipController.text = ip;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Conectado a $ip:$port")),
    );
  }

  Future<void> _close() async {
    sender?.close();
  }

  void _sendData() {
    if (sender == null) return;
    final data = jsonEncode({
      "angle": angle,
      "throttle": throttle,
      "gearUp": gearUp,
      "gearDown": gearDown,
    });

    sender!.send(
      data.codeUnits,
      Endpoint.unicast(
        InternetAddress(ipController.text),
        port: Port(port),
      ),
    );

    setState(() {
      gearUp = false;
      gearDown = false;
    });
  }

  @override
  void dispose() {
    sender?.close();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _openSettings() async {
    print("Abriendo configuración");
    final newSensitivity = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          ip: ipController.text,
          sensitivity: sensitivity,
          onConnect: _connect,
          onClose: _close,
        ),
      ),
    );

    print("Regresando de configuración: $newSensitivity");
    if (newSensitivity != null && newSensitivity is double) {
      setState(() => sensitivity = newSensitivity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Steering Wheel',
      debugShowCheckedModeBanner: false,
      home: MainScreen(
        angle: angle,
        throttle: throttle,
        onThrottleChange: (value) {
          setState(() => throttle = value);
          _sendData();
        },
        onGearUp: () {
          setState(() => gearUp = true);
          _sendData();
        },
        onGearDown: () {
          setState(() => gearDown = true);
          _sendData();
        },
        onOpenSettings: _openSettings,
      ),
    );
  }
}
