import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import 'profiles.dart';
import 'trip.dart';

/// Lo que ve el taxista: si está conectado, dónde está, la oferta que le llegó,
/// su viaje en curso y lo que lleva ganado hoy.
@immutable
class DriverSession {
  const DriverSession({
    required this.profile,
    required this.position,
    required this.online,
    required this.earningsToday,
    required this.tripsToday,
    this.offer,
    this.trip,
    this.lastCompleted,
  });

  final DriverProfile profile;
  final LatLng position;
  final bool online;
  final int earningsToday;
  final int tripsToday;

  /// Viaje que se le está ofreciendo ahora (status `offered`).
  final Trip? offer;

  /// Viaje aceptado y en curso.
  final Trip? trip;

  /// Último viaje terminado, para el resumen y la calificación al pasajero.
  final Trip? lastCompleted;
}

/// Taxi visible en el mapa del pasajero.
@immutable
class NearbyTaxi {
  const NearbyTaxi({required this.id, required this.position, required this.heading});

  final String id;
  final LatLng position;

  /// Rumbo en grados (0 = norte) para girar el ícono.
  final double heading;
}
