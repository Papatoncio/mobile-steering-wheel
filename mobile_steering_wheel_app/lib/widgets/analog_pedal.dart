import 'package:flutter/material.dart';

/// Zona de toque vertical que produce valores analógicos 0.0–1.0.
///
/// Comportamiento:
///   - Tap sostenido  → 100% mientras se mantiene, 0% al soltar.
///   - Arrastre       → valor proporcional a la posición vertical.
///   - Doble tap      → bloquea al 100% (queda fijo aunque se suelte el dedo).
///   - Doble tap otra vez → desbloquea y vuelve a 0%.
///
/// Cuando está bloqueado se muestra un icono de candado y el borde
/// parpadea con el color del pedal.
class AnalogPedal extends StatefulWidget {
  final Color    color;
  final IconData icon;
  final String   label;
  final ValueChanged<double> onValueChanged;

  const AnalogPedal({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    required this.onValueChanged,
  });

  @override
  State<AnalogPedal> createState() => _AnalogPedalState();
}

class _AnalogPedalState extends State<AnalogPedal>
    with SingleTickerProviderStateMixin {
  double _value  = 0.0;
  bool   _locked = false;

  // Animación de pulso para el borde cuando está bloqueado.
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..addStatusListener((s) {
      if (s == AnimationStatus.completed) _pulseCtrl.reverse();
      if (s == AnimationStatus.dismissed) _pulseCtrl.forward();
    });

  late final Animation<double> _pulseAnim = Tween<double>(begin: 0.3, end: 1.0)
      .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  void _setValue(double v) {
    if (_locked) return; // bloqueado: ignorar cambios externos
    final clamped = v.clamp(0.0, 1.0);
    if ((clamped - _value).abs() < 0.005) return;
    setState(() => _value = clamped);
    widget.onValueChanged(_value);
  }

  void _release() {
    if (_locked) return;
    if (_value == 0.0) return;
    setState(() => _value = 0.0);
    widget.onValueChanged(0.0);
  }

  void _toggleLock() {
    setState(() {
      _locked = !_locked;
      if (_locked) {
        _value = 1.0;
        _pulseCtrl.forward();
      } else {
        _value = 0.0;
        _pulseCtrl.stop();
        _pulseCtrl.reset();
      }
    });
    widget.onValueChanged(_value);
  }

  void _updateFromDrag(double dy, double height) {
    if (_locked) return;
    final newVal = (1.0 - (dy / height)).clamp(0.0, 1.0);
    if ((newVal - _value).abs() < 0.005) return;
    setState(() => _value = newVal);
    widget.onValueChanged(_value);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          // Doble tap → bloquear / desbloquear
          onDoubleTap: _toggleLock,
          // Tap simple sostenido (solo si no está bloqueado)
          onTapDown: (_) => _setValue(1.0),
          onTapUp:   (_) => _release(),
          onTapCancel:    _release,
          // Arrastre vertical
          onVerticalDragStart:  (d) => _updateFromDrag(d.localPosition.dy, height),
          onVerticalDragUpdate: (d) => _updateFromDrag(d.localPosition.dy, height),
          onVerticalDragEnd:    (_) => _release(),
          onVerticalDragCancel:      _release,
          child: AnimatedBuilder(
            animation: _pulseAnim,
            builder: (context, child) {
              final borderColor = _locked
                  ? widget.color.withOpacity(_pulseAnim.value)
                  : Colors.white24;
              final borderWidth = _locked ? 2.0 : 1.0;

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: borderWidth),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // ── Barra de valor ───────────────────────────────────
                    FractionallySizedBox(
                      heightFactor: _value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          color: _locked
                              ? widget.color.withOpacity(0.85)
                              : widget.color.withOpacity(0.6),
                        ),
                      ),
                    ),

                    // ── Contenido central ────────────────────────────────
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icono principal o candado si está bloqueado
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Icon(widget.icon, color: Colors.white, size: 22),
                            if (_locked)
                              const Icon(Icons.lock,
                                  color: Colors.white, size: 11),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _locked
                              ? '🔒 100%'
                              : '${(_value * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: _locked ? widget.color : Colors.white70,
                            fontSize: 11,
                            fontWeight: _locked
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.label,
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 9),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
