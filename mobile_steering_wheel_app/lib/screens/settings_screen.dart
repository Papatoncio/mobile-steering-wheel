import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_steering_wheel_app/screens/main_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String ip;
  final double sensitivity;
  final Future<void> Function(String) onConnect;
  final Future<void> Function() onClose;

  const SettingsScreen({
    super.key,
    required this.ip,
    required this.sensitivity,
    required this.onConnect,
    required this.onClose,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController ipController;
  late double sensitivity;

  @override
  void initState() {
    super.initState();
    ipController = TextEditingController(text: widget.ip);
    sensitivity = widget.sensitivity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: MainScreen.iconIdleBackgroundColor),
        title: const Text(
          "Configuración",
          style: TextStyle(color: MainScreen.textColor),
        ),
        backgroundColor: MainScreen.appBarBackgroundColor,
      ),
      backgroundColor: MainScreen.screenBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Conexión",
              style: TextStyle(fontSize: 22, color: MainScreen.textColor),
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.phone,
              controller: ipController,
              style: const TextStyle(color: MainScreen.textColor),
              decoration: const InputDecoration(
                labelText: "IP del PC",
                labelStyle: TextStyle(color: MainScreen.textColor),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    await widget.onConnect(ipController.text);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: MainScreen.btnIdleBackgroundColor,
                    padding: const EdgeInsets.all(MainScreen.btnSize),
                  ),
                  child: const Text(
                    "Conectar",
                    style: TextStyle(color: MainScreen.textColor),
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    await widget.onClose();
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: MainScreen.btnIdleBackgroundColor,
                    padding: const EdgeInsets.all(MainScreen.btnSize),
                  ),
                  child: const Text(
                    "Desconectar",
                    style: TextStyle(color: MainScreen.textColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Sensibilidad del giro",
              style: TextStyle(fontSize: 22, color: MainScreen.textColor),
            ),
            Slider(
              value: sensitivity,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              label: "${sensitivity.toStringAsFixed(2)}x",
              onChanged: (val) => setState(() => sensitivity = val),
              activeColor: MainScreen.sliderActiveColor,
            ),
            const SizedBox(height: 50),
            Center(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(MainScreen.btnSize),
                ),
                icon: const Icon(FontAwesomeIcons.arrowLeft,
                    color: MainScreen.iconIdleBackgroundColor,
                    size: MainScreen.iconSize),
                label: const Text(
                  "Volver",
                  style: TextStyle(fontSize: 22, color: MainScreen.textColor),
                ),
                onPressed: () => Navigator.pop(context, sensitivity),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
