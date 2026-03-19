import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/wheel_controller.dart';
import '../screens/qr_scan_screen.dart';

class SettingsScreen extends StatefulWidget {
  final WheelController controller;

  const SettingsScreen({super.key, required this.controller});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _ipCtrl;
  late TextEditingController _portCtrl;
  late double _sensitivity;
  bool _isConnecting = false;

  static const _textStyle   = TextStyle(color: Colors.white);
  static const _labelStyle  = TextStyle(color: Colors.white70);
  static const _inputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white38),
  );

  @override
  void initState() {
    super.initState();
    final ctrl = widget.controller;
    _ipCtrl      = TextEditingController(text: ctrl.currentIp);
    _portCtrl    = TextEditingController(text: ctrl.port.toString());
    _sensitivity = ctrl.sensitivity;
  }

  @override
  void dispose() {
    _ipCtrl.dispose();
    _portCtrl.dispose();
    super.dispose();
  }

  // ── Escanear QR ────────────────────────────────────────────────────────────

  Future<void> _scanQr() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const QrScanScreen()),
    );
    if (result == null || !mounted) return;

    setState(() {
      _ipCtrl.text   = result['ip'] as String;
      _portCtrl.text = (result['port'] as int).toString();
    });

    // Conectar automáticamente tras escanear
    await _connect();
  }

  // ── Conectar / Desconectar ─────────────────────────────────────────────────

  Future<void> _connect() async {
    final ip   = _ipCtrl.text.trim();
    final port = int.tryParse(_portCtrl.text.trim()) ?? 5005;

    if (ip.isEmpty) {
      _showSnack('Escribe o escanea una IP primero');
      return;
    }

    setState(() => _isConnecting = true);
    final error = await widget.controller.connect(ip, port);
    if (!mounted) return;
    setState(() => _isConnecting = false);

    _showSnack(error == null ? '✓ Conectado a $ip:$port' : '✗ $error');
  }

  Future<void> _disconnect() async {
    await widget.controller.disconnect();
    _showSnack('Desconectado');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración', style: _textStyle),
        backgroundColor: Colors.black12,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Sección conexión ──────────────────────────────────────────
            const Text('Conexión', style: TextStyle(fontSize: 22, color: Colors.white)),
            const SizedBox(height: 12),

            // Botón QR (destacado)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(FontAwesomeIcons.qrcode, color: Colors.white),
                label: const Text('Escanear QR del servidor',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                onPressed: _scanQr,
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text('— o ingresa manualmente —',
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
            ),
            const SizedBox(height: 8),

            // IP
            TextField(
              controller: _ipCtrl,
              keyboardType: TextInputType.phone,
              style: _textStyle,
              decoration: const InputDecoration(
                labelText: 'IP del PC',
                labelStyle: _labelStyle,
                border: _inputBorder,
                enabledBorder: _inputBorder,
              ),
            ),
            const SizedBox(height: 10),

            // Puerto
            TextField(
              controller: _portCtrl,
              keyboardType: TextInputType.number,
              style: _textStyle,
              decoration: const InputDecoration(
                labelText: 'Puerto UDP',
                labelStyle: _labelStyle,
                border: _inputBorder,
                enabledBorder: _inputBorder,
              ),
            ),
            const SizedBox(height: 16),

            // Botones conectar / desconectar
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: _isConnecting ? null : _connect,
                    child: _isConnecting
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Conectar', style: _textStyle),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: _disconnect,
                    child: const Text('Desconectar', style: _textStyle),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 36),

            // ── Sección sensibilidad ──────────────────────────────────────
            const Text('Sensibilidad del giro',
                style: TextStyle(fontSize: 22, color: Colors.white)),
            const SizedBox(height: 4),
            Text('${_sensitivity.toStringAsFixed(2)}x',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 18)),

            Slider(
              value: _sensitivity,
              min: 0.3,
              max: 2.0,
              divisions: 17,
              label: '${_sensitivity.toStringAsFixed(2)}x',
              activeColor: Colors.blueAccent,
              onChanged: (v) {
                setState(() => _sensitivity = v);
                widget.controller.updateSensitivity(v);
              },
            ),

            const SizedBox(height: 50),

            // ── Volver ────────────────────────────────────────────────────
            Center(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14)),
                icon: const Icon(FontAwesomeIcons.arrowLeft,
                    color: Colors.white, size: 18),
                label: const Text('Volver',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
