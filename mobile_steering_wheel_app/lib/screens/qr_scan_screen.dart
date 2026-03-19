import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Pantalla que abre la cámara para escanear el QR del servidor Python.
/// El QR contiene el string "IP:PUERTO" (ej. "192.168.1.5:5005").
/// Hace pop con un mapa {ip: String, port: int} al detectar un código válido.
class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController _ctrl = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;

    // Formato esperado: "192.168.1.10:5005"
    final parts = raw.split(':');
    if (parts.length != 2) return;
    final ip   = parts[0].trim();
    final port = int.tryParse(parts[1].trim());
    if (ip.isEmpty || port == null) return;

    _scanned = true;
    _ctrl.stop();
    Navigator.of(context).pop({'ip': ip, 'port': port});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Escanear servidor', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _ctrl.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_android),
            onPressed: () => _ctrl.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: _ctrl,
              onDetect: _onDetect,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Apunta al código QR que muestra\nel servidor en tu PC',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
