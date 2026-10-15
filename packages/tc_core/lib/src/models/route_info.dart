import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

/// Ruta por calle entre dos puntos.
@immutable
class RouteInfo {
  const RouteInfo({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
    this.isApproximate = false,
  });

  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;

  /// `true` cuando no hubo servicio de rutas y se usó una línea aproximada.
  final bool isApproximate;

  double get distanceKm => distanceMeters / 1000;
  double get durationMinutes => durationSeconds / 60;
}
