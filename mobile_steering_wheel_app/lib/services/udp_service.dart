import 'dart:convert';
import 'dart:io';

import 'package:udp/udp.dart';

/// Encapsula toda la lógica de red UDP.
/// Uso:
///   final svc = UdpService();
///   await svc.connect('192.168.1.10', 5005);
///   svc.send({...});
///   await svc.disconnect();
class UdpService {
  UDP? _sender;
  String _ip = '';
  int _port = 5005;

  bool get isConnected => _sender != null && _ip.isNotEmpty;
  String get currentIp => _ip;
  int get currentPort => _port;

  /// Conecta (o reconecta) al servidor UDP en [ip]:[port].
  Future<void> connect(String ip, int port) async {
    await disconnect();
    _ip = ip.trim();
    _port = port;
    _sender = await UDP.bind(Endpoint.any());
  }

  /// Cierra el socket.
  Future<void> disconnect() async {
    _sender?.close();
    _sender = null;
    _ip = '';
  }

  /// Envía un mapa de datos como JSON al servidor.
  /// Falla silenciosamente si no hay conexión.
  void send(Map<String, dynamic> data) {
    if (!isConnected) return;
    try {
      final payload = jsonEncode(data);
      _sender!.send(
        payload.codeUnits,
        Endpoint.unicast(InternetAddress(_ip), port: Port(_port)),
      );
    } catch (_) {
      // El envío UDP es best-effort; los errores aislados se ignoran.
    }
  }
}
