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
  bool throttle = false;
  bool brake = false;
  double sensitivity = 0.7;
  bool gearUp = false;
  bool gearDown = false;
  bool cruiseControl = false;
  bool turnOnOfEngine = false;
  bool interact = false;
  bool pickDropTrailer = false;
  bool leftSignal = false;
  bool blinker = false;
  bool rightSignal = false;
  bool windshieldWiper = false;
  bool handBrake = false;
  bool headlights = false;
  bool highBeams = false;
  bool horn = false;
  bool cameraOne = false;
  bool cameraTwo = false;
  bool cameraThree = false;
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
      "brake": brake,
      "gearUp": gearUp,
      "gearDown": gearDown,
      "cruiseControl": cruiseControl,
      "turnOnOfEngine": turnOnOfEngine,
      "interact": interact,
      "pickDropTrailer": pickDropTrailer,
      "leftSignal": leftSignal,
      "blinker": blinker,
      "rightSignal": rightSignal,
      "windshieldWiper": windshieldWiper,
      "handBrake": handBrake,
      "headlights": headlights,
      "highBeams": highBeams,
      "horn": horn,
      "cameraOne": cameraOne,
      "cameraTwo": cameraTwo,
      "cameraThree": cameraThree,
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
      cruiseControl = false;
      turnOnOfEngine = false;
      interact = false;
      pickDropTrailer = false;
      leftSignal = false;
      blinker = false;
      rightSignal = false;
      windshieldWiper = false;
      handBrake = false;
      headlights = false;
      highBeams = false;
      horn = false;
      cameraOne = false;
      cameraTwo = false;
      cameraThree = false;
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
        onThrottle: () {
          setState(() => throttle = !throttle);
          _sendData();
        },
        onBrake: () {
          setState(() => brake = !brake);
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
        onCruiseControl: () {
          setState(() => cruiseControl = true);
          _sendData();
        },
        onTurnOnOfEngine: () {
          setState(() => turnOnOfEngine = true);
          _sendData();
        },
        onInteract: () {
          setState(() => interact = true);
          _sendData();
        },
        onPickDropTrailer: () {
          setState(() => pickDropTrailer = true);
          _sendData();
        },
        onLeftSignal: () {
          setState(() => leftSignal = true);
          _sendData();
        },
        onBlinker: () {
          setState(() => blinker = true);
          _sendData();
        },
        onRightSignal: () {
          setState(() => rightSignal = true);
          _sendData();
        },
        onWindshieldWiper: () {
          setState(() => windshieldWiper = true);
          _sendData();
        },
        onHandBrake: () {
          setState(() => handBrake = true);
          _sendData();
        },
        onHeadlights: () {
          setState(() => headlights = true);
          _sendData();
        },
        onHighBeams: () {
          setState(() => highBeams = true);
          _sendData();
        },
        onHorn: () {
          setState(() => horn = true);
          _sendData();
        },
        onCameraChange: (Camera camera) {
          switch (camera) {
            case Camera.one:
              setState(() => cameraOne = true);
              break;
            case Camera.two:
              setState(() => cameraTwo = true);
              break;
            case Camera.three:
              setState(() => cameraThree = true);
              break;
          }
          _sendData();
        },
        onOpenSettings: _openSettings,
      ),
    );
  }
}
