import 'package:flutter/foundation.dart';

import '../models/driver_session.dart';
import '../models/fare_quote.dart';
import '../models/place.dart';
import '../models/profiles.dart';
import '../models/route_info.dart';
import '../models/trip.dart';

/// Lo que manda el pasajero al pedir un taxi.
@immutable
class TripRequest {
  const TripRequest({
    required this.rider,
    required this.pickup,
    required this.destination,
    required this.type,
    required this.route,
    required this.quote,
  });

  final RiderProfile rider;
  final Place pickup;
  final Place destination;
  final VehicleType type;
  final RouteInfo route;
  final FareQuote quote;
}

/// Contrato entre la UI y el "backend" de viajes.
///
/// Hoy lo implementa [SimulatedTripRepository] (todo en memoria). Para pasar a
/// producción se escribe otra implementación (Supabase, Firebase, API propia)
/// y se cambia en `tripRepositoryProvider`; las pantallas no se tocan.
abstract interface class TripRepository {
  // ── Pasajero ──────────────────────────────────────────────────────────────

  /// Viaje actual del pasajero (o `null`). Emite en cada cambio.
  Stream<Trip?> watchRiderTrip(String riderId);

  /// Taxis libres para pintar en el mapa del pasajero.
  Stream<List<NearbyTaxi>> watchNearbyTaxis();

  Future<Trip> requestTrip(TripRequest request);

  Future<void> cancelTrip(String tripId, {required CancelledBy by});

  Future<void> rateDriver(String tripId, {required int stars, int tip = 0});

  /// El pasajero cerró el resumen o el aviso de cancelación.
  Future<void> dismissRiderTrip(String riderId);

  // ── Taxista ───────────────────────────────────────────────────────────────

  Stream<DriverSession> watchDriver(String driverId);

  Future<void> setOnline(String driverId, {required bool online});

  Future<void> acceptOffer(String driverId, String tripId);

  Future<void> rejectOffer(String driverId, String tripId);

  Future<void> markArrived(String tripId);

  Future<void> startTrip(String tripId);

  Future<void> completeTrip(String tripId);

  Future<void> rateRider(String tripId, {required int stars});

  /// Solo demo: hace que le llegue una solicitud al taxista.
  Future<void> simulateIncomingRequest(String driverId);

  void dispose();
}
