import 'package:flutter/material.dart';

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
        title: const Text("Configuración"),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Conexión",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ipController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "IP del PC",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await widget.onConnect(ipController.text);
                  },
                  child: const Text("Conectar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await widget.onClose();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Desconectar"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Sensibilidad del giro",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            Slider(
              value: sensitivity,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              label: "${sensitivity.toStringAsFixed(2)}x",
              onChanged: (val) => setState(() => sensitivity = val),
              activeColor: Colors.blueAccent,
            ),
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text("Volver"),
                onPressed: () => Navigator.pop(context, sensitivity),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
