import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import 'fare_quote.dart';
import 'place.dart';
import 'profiles.dart';
import 'route_info.dart';

/// Estados del viaje. El orden importa: ver `docs/SPEC.md § Máquina de estados`.
enum TripStatus {
  /// Se busca taxista.
  searching,

  /// Se le ofreció a un taxista y espera su respuesta.
  offered,

  /// El taxista aceptó y va a la recogida.
  driverEnRoute,

  /// El taxista llegó a la recogida.
  driverArrived,

  /// El pasajero va a bordo.
  inProgress,

  /// Terminó y se cobró.
  completed,

  /// Se canceló antes de terminar.
  cancelled;

  bool get isActive => this != completed && this != cancelled;
  bool get hasDriver => index >= driverEnRoute.index && this != cancelled;
}

enum CancelledBy { rider, driver, system }

/// Un viaje. Es inmutable: el repositorio emite una copia nueva en cada cambio.
@immutable
class Trip {
  const Trip({
    required this.id,
    required this.rider,
    required this.pickup,
    required this.destination,
    required this.type,
    required this.quote,
    required this.route,
    required this.status,
    required this.createdAt,
    this.payment = PaymentMethod.cash,
    this.driver,
    this.driverPosition,
    this.approachRoute,
    this.progress = 0,
    this.etaSeconds,
    this.offerExpiresAt,
    this.finalFare,
    this.tip = 0,
    this.riderRatingByDriver,
    this.driverRatingByRider,
    this.cancelledBy,
  });

  final String id;
  final RiderProfile rider;
  final Place pickup;
  final Place destination;
  final VehicleType type;
  final FareQuote quote;
  final PaymentMethod payment;

  /// Ruta de la recogida al destino.
  final RouteInfo route;
  final TripStatus status;
  final DateTime createdAt;

  final DriverProfile? driver;
  final LatLng? driverPosition;

  /// Ruta del taxista a la recogida.
  final RouteInfo? approachRoute;

  /// Avance del tramo actual (0–1): a la recogida o al destino.
  final double progress;

  /// Segundos estimados para terminar el tramo actual (en tiempo real, no simulado).
  final double? etaSeconds;
  final DateTime? offerExpiresAt;
  final int? finalFare;
  final int tip;
  final int? riderRatingByDriver;
  final int? driverRatingByRider;
  final CancelledBy? cancelledBy;

  /// El taxi ya llegó al destino pero el taxista no ha terminado el viaje.
  bool get atDestination => status == TripStatus.inProgress && progress >= 1;

  Trip copyWith({
    TripStatus? status,
    DriverProfile? driver,
    LatLng? driverPosition,
    RouteInfo? approachRoute,
    double? progress,
    double? etaSeconds,
    DateTime? offerExpiresAt,
    bool clearOffer = false,
    bool clearDriver = false,
    int? finalFare,
    int? tip,
    int? riderRatingByDriver,
    int? driverRatingByRider,
    CancelledBy? cancelledBy,
  }) {
    return Trip(
      id: id,
      rider: rider,
      pickup: pickup,
      destination: destination,
      type: type,
      quote: quote,
      payment: payment,
      route: route,
      createdAt: createdAt,
      status: status ?? this.status,
      driver: clearDriver ? null : driver ?? this.driver,
      driverPosition: clearDriver ? null : driverPosition ?? this.driverPosition,
      approachRoute: clearDriver ? null : approachRoute ?? this.approachRoute,
      progress: progress ?? this.progress,
      etaSeconds: etaSeconds ?? this.etaSeconds,
      offerExpiresAt: clearOffer ? null : offerExpiresAt ?? this.offerExpiresAt,
      finalFare: finalFare ?? this.finalFare,
      tip: tip ?? this.tip,
      riderRatingByDriver: riderRatingByDriver ?? this.riderRatingByDriver,
      driverRatingByRider: driverRatingByRider ?? this.driverRatingByRider,
      cancelledBy: cancelledBy ?? this.cancelledBy,
    );
  }
}
