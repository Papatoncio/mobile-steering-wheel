import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/udp_service.dart';

/// ChangeNotifier que centraliza el estado del volante y los controles.
/// Separa completamente la lógica de la UI.
class WheelController extends ChangeNotifier {
  // ── Servicio UDP ────────────────────────────────────────────────────────────
  final UdpService _udp = UdpService();
  bool get isConnected => _udp.isConnected;

  // ── Configuración ───────────────────────────────────────────────────────────
  double sensitivity = 0.7;
  int port = 5005;

  // ── Eje de dirección ────────────────────────────────────────────────────────
  double angle = 0.0; // −45° … +45° (ajustado por sensitivity)

  // ── Ejes analógicos (0.0 – 1.0) ────────────────────────────────────────────
  double throttleValue = 0.0;
  double brakeValue = 0.0;

  // ── Botones de palanca / momentáneos ───────────────────────────────────────
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
  bool routeAdvisorNavigation = false;
  bool routeAdvisorCurrentDelivery = false;
  bool routeAdvisorAssistance = false;
  bool routeAdvisorInformation = false;
  bool routeAdvisorChat = false;

  // ── Subscripción al acelerómetro ────────────────────────────────────────────
  StreamSubscription<AccelerometerEvent>? _accelSub;

  WheelController() {
    _loadPrefs();
    _startSensor();
  }

  // ── Persistencia ────────────────────────────────────────────────────────────

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    sensitivity = prefs.getDouble('sensitivity') ?? 0.7;
    port = prefs.getInt('port') ?? 5005;
    final savedIp = prefs.getString('ip') ?? '';
    if (savedIp.isNotEmpty) {
      await connect(savedIp, port);
    }
    notifyListeners();
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sensitivity', sensitivity);
    await prefs.setInt('port', port);
    if (_udp.currentIp.isNotEmpty) {
      await prefs.setString('ip', _udp.currentIp);
    }
  }

  // ── Acelerómetro ────────────────────────────────────────────────────────────

  void _startSensor() {
    // sensors_plus ^4.x usa accelerometerEventStream() en lugar del stream deprecado.
    _accelSub = accelerometerEventStream().listen((event) {
      final raw = ((-event.y.clamp(-9.8, 9.8) / 9.8) * 45 * sensitivity) * -1;
      angle = raw;
      notifyListeners();
      sendData();
    });
  }

  // ── Conexión UDP ────────────────────────────────────────────────────────────

  Future<String?> connect(String ip, int port) async {
    if (ip.trim().isEmpty) return 'IP inválida';
    try {
      await _udp.connect(ip.trim(), port);
      this.port = port;
      await _savePrefs();
      notifyListeners();
      return null; // sin error
    } catch (e) {
      return 'Error al conectar: $e';
    }
  }

  Future<void> disconnect() async {
    await _udp.disconnect();
    notifyListeners();
  }

  String get currentIp => _udp.currentIp;

  // ── Envío de datos ──────────────────────────────────────────────────────────

  void sendData() {
    _udp.send({
      'angle': angle,
      // Analógicos: float 0.0–1.0
      'throttle': throttleValue,
      'brake': brakeValue,
      // Botones
      'gearUp': gearUp,
      'gearDown': gearDown,
      'cruiseControl': cruiseControl,
      'turnOnOfEngine': turnOnOfEngine,
      'interact': interact,
      'pickDropTrailer': pickDropTrailer,
      'leftSignal': leftSignal,
      'blinker': blinker,
      'rightSignal': rightSignal,
      'windshieldWiper': windshieldWiper,
      'handBrake': handBrake,
      'headlights': headlights,
      'highBeams': highBeams,
      'horn': horn,
      'cameraOne': cameraOne,
      'cameraTwo': cameraTwo,
      'cameraThree': cameraThree,
      'routeAdvisorNavigation': routeAdvisorNavigation,
      'routeAdvisorCurrentDelivery': routeAdvisorCurrentDelivery,
      'routeAdvisorAssistance': routeAdvisorAssistance,
      'routeAdvisorInformation': routeAdvisorInformation,
      'routeAdvisorChat': routeAdvisorChat,
    });
  }

  /// Envía un paquete pulsado (activa → envía → desactiva) para botones momentáneos.
  void _pulse(void Function() activate) {
    activate();
    sendData();
    // Limpia los pulsos en el siguiente frame para no bloquear el hilo.
    Future.microtask(() {
      _clearPulseButtons();
      notifyListeners();
    });
  }

  void _clearPulseButtons() {
    gearUp = gearDown = cruiseControl = turnOnOfEngine = false;
    pickDropTrailer = leftSignal = blinker = rightSignal = false;
    windshieldWiper = handBrake = headlights = highBeams = false;
    cameraOne = cameraTwo = cameraThree = false;
    routeAdvisorNavigation = routeAdvisorCurrentDelivery = false;
    routeAdvisorAssistance = routeAdvisorInformation = routeAdvisorChat = false;
  }

  // ── API pública de acciones ─────────────────────────────────────────────────

  void setThrottle(double v) {
    throttleValue = v.clamp(0.0, 1.0);
    notifyListeners();
    sendData();
  }

  void setBrake(double v) {
    brakeValue = v.clamp(0.0, 1.0);
    notifyListeners();
    sendData();
  }

  void toggleInteract() {
    interact = !interact;
    notifyListeners();
    sendData();
  }

  void toggleHorn(bool active) {
    horn = active;
    notifyListeners();
    sendData();
  }

  void pressGearUp()          => _pulse(() => gearUp = true);
  void pressGearDown()        => _pulse(() => gearDown = true);
  void pressCruiseControl()   => _pulse(() => cruiseControl = true);
  void pressTurnOnEngine()    => _pulse(() => turnOnOfEngine = true);
  void pressPickDrop()        => _pulse(() => pickDropTrailer = true);
  void pressLeftSignal()      => _pulse(() => leftSignal = true);
  void pressBlinker()         => _pulse(() => blinker = true);
  void pressRightSignal()     => _pulse(() => rightSignal = true);
  void pressWiper()           => _pulse(() => windshieldWiper = true);
  void pressHandBrake()       => _pulse(() => handBrake = true);
  void pressHeadlights()      => _pulse(() => headlights = true);
  void pressHighBeams()       => _pulse(() => highBeams = true);
  void pressCameraOne()       => _pulse(() => cameraOne = true);
  void pressCameraTwo()       => _pulse(() => cameraTwo = true);
  void pressCameraThree()     => _pulse(() => cameraThree = true);
  void pressRouteNav()        => _pulse(() => routeAdvisorNavigation = true);
  void pressRouteDelivery()   => _pulse(() => routeAdvisorCurrentDelivery = true);
  void pressRouteAssistance() => _pulse(() => routeAdvisorAssistance = true);
  void pressRouteInfo()       => _pulse(() => routeAdvisorInformation = true);
  void pressRouteChat()       => _pulse(() => routeAdvisorChat = true);

  void updateSensitivity(double v) {
    sensitivity = v;
    notifyListeners();
    _savePrefs();
  }

  @override
  Future<void> dispose() async {
    await _accelSub?.cancel();
    await _udp.disconnect();
    super.dispose();
  }
}
