import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

const _distance = Distance();

/// Distancia en metros entre dos puntos.
double metersBetween(LatLng a, LatLng b) => _distance.as(LengthUnit.Meter, a, b);

/// Rumbo en grados (0 = norte, sentido horario) de [from] a [to].
double bearingBetween(LatLng from, LatLng to) {
  final b = _distance.bearing(from, to);
  return (b + 360) % 360;
}

/// Mide una polilínea una sola vez para poder ubicar puntos sobre ella rápido.
class PolylineCursor {
  PolylineCursor(this.points) : assert(points.isNotEmpty) {
    _cumulative = [0];
    for (var i = 1; i < points.length; i++) {
      _cumulative.add(_cumulative.last + metersBetween(points[i - 1], points[i]));
    }
  }

  final List<LatLng> points;
  late final List<double> _cumulative;

  double get length => _cumulative.last;

  /// Punto y rumbo a la fracción [t] (0–1) del recorrido.
  ({LatLng point, double heading}) at(double t) {
    if (points.length == 1 || length == 0) return (point: points.first, heading: 0);
    final target = t.clamp(0.0, 1.0) * length;
    var i = 1;
    while (i < _cumulative.length - 1 && _cumulative[i] < target) {
      i++;
    }
    final a = points[i - 1];
    final b = points[i];
    final segment = _cumulative[i] - _cumulative[i - 1];
    final f = segment == 0 ? 0.0 : (target - _cumulative[i - 1]) / segment;
    final point = LatLng(
      a.latitude + (b.latitude - a.latitude) * f,
      a.longitude + (b.longitude - a.longitude) * f,
    );
    return (point: point, heading: bearingBetween(a, b));
  }

  /// Lo que falta del recorrido desde la fracción [t], para dibujar la ruta restante.
  List<LatLng> remainingFrom(double t) {
    if (t <= 0) return points;
    final here = at(t).point;
    final target = t.clamp(0.0, 1.0) * length;
    final rest = <LatLng>[here];
    for (var i = 0; i < points.length; i++) {
      if (_cumulative[i] > target) rest.add(points[i]);
    }
    return rest;
  }
}

/// Un punto al azar a [minMeters]–[maxMeters] de [origin].
LatLng randomPointNear(LatLng origin, math.Random random, {double minMeters = 300, double maxMeters = 1200}) {
  final d = minMeters + random.nextDouble() * (maxMeters - minMeters);
  final angle = random.nextDouble() * 360;
  return _distance.offset(origin, d, angle);
}
