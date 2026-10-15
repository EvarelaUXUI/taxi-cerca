import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:tc_design_system/tc_design_system.dart';

/// Taxi visto desde arriba: círculo amarillo con borde negro y una flecha que
/// indica hacia dónde va. [highlight] lo agranda (el taxi asignado o el propio).
Marker tcTaxiMarker(LatLng point, {double heading = 0, bool highlight = false, String? label}) {
  final size = highlight ? 52.0 : 38.0;
  return Marker(
    point: point,
    width: size + 16,
    height: size + 16,
    child: _TaxiPin(heading: heading, size: size, highlight: highlight, label: label),
  );
}

class _TaxiPin extends StatelessWidget {
  const _TaxiPin({required this.heading, required this.size, required this.highlight, this.label});

  final double heading;
  final double size;
  final bool highlight;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: label ?? 'Taxi',
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: heading * math.pi / 180,
            child: SizedBox.square(
              dimension: size + 16,
              child: Align(
                alignment: Alignment.topCenter,
                child: CustomPaint(size: const Size(14, 9), painter: _Arrow(c.onBrand)),
              ),
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: c.brand,
              shape: BoxShape.circle,
              border: Border.all(color: c.onBrand, width: highlight ? 3 : 2),
              boxShadow: TcElevation.low(c.shadow),
            ),
            child: Icon(Icons.local_taxi_rounded, color: c.onBrand, size: size * 0.55),
          ),
        ],
      ),
    );
  }
}

class _Arrow extends CustomPainter {
  _Arrow(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_Arrow old) => old.color != color;
}

/// Punto de recogida: círculo verde con centro blanco.
Marker tcPickupMarker(LatLng point, {String label = 'Recogida'}) => Marker(
      point: point,
      width: 36,
      height: 36,
      child: Builder(
        builder: (context) {
          final c = context.colors;
          return Semantics(
            label: label,
            child: Container(
              decoration: BoxDecoration(
                color: c.mapPickup,
                shape: BoxShape.circle,
                border: Border.all(color: c.surface, width: 3),
                boxShadow: TcElevation.low(c.shadow),
              ),
              child: Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(color: c.surface, shape: BoxShape.circle))),
            ),
          );
        },
      ),
    );

/// Destino: cuadro negro tipo bandera con base en punta.
Marker tcDestinationMarker(LatLng point, {String label = 'Destino'}) => Marker(
      point: point,
      width: 40,
      height: 48,
      alignment: Alignment.topCenter,
      child: Builder(
        builder: (context) {
          final c = context.colors;
          return Semantics(
            label: label,
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: c.mapDestination,
                    borderRadius: BorderRadius.circular(TcRadius.sm),
                    border: Border.all(color: c.surface, width: 2.5),
                    boxShadow: TcElevation.low(c.shadow),
                  ),
                  child: Icon(Icons.flag_rounded, size: 18, color: c.brand),
                ),
                Container(width: 3, height: 12, color: c.mapDestination),
              ],
            ),
          );
        },
      ),
    );

/// Ubicación de la persona: punto con halo que late suavemente.
Marker tcUserMarker(LatLng point, {String label = 'Tu ubicación'}) => Marker(
      point: point,
      width: 64,
      height: 64,
      child: _UserDot(label: label),
    );

class _UserDot extends StatefulWidget {
  const _UserDot({required this.label});
  final String label;

  @override
  State<_UserDot> createState() => _UserDotState();
}

class _UserDotState extends State<_UserDot> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (TcMotion.reduced(context)) {
      _c.value = 0.5;
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: widget.label,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 24 + 40 * _c.value,
              height: 24 + 40 * _c.value,
              decoration: BoxDecoration(shape: BoxShape.circle, color: c.info.withValues(alpha: 0.28 * (1 - _c.value))),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: c.info,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: TcElevation.low(c.shadow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
