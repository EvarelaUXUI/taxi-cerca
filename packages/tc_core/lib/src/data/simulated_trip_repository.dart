import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../config/demo_profiles.dart';
import '../config/town_config.dart';
import '../geo.dart';
import '../models/driver_session.dart';
import '../models/fare_quote.dart';
import '../models/profiles.dart';
import '../models/route_info.dart';
import '../models/trip.dart';
import '../services/fare_calculator.dart';
import '../services/route_service.dart';
import 'trip_repository.dart';

/// "Backend" de la demo, todo en memoria.
///
/// - Lleva un reloj propio ([_clock]) que avanza en cada tick; todas las
///   esperas (el bot acepta, la oferta vence…) se agendan sobre ese reloj, así
///   las pruebas pueden avanzar el tiempo con [advance] sin esperar de verdad.
/// - Los trayectos se recorren comprimidos (`_simSeconds`) pero el tiempo de
///   llegada que se muestra es el real de la ruta.
class SimulatedTripRepository implements TripRepository {
  SimulatedTripRepository({
    required this.town,
    required this.routes,
    math.Random? random,
    Duration tick = const Duration(milliseconds: 200),
    bool autoStart = true,
  })  : _random = random ?? math.Random(),
        _fares = FareCalculator(town.fareRules),
        _tickInterval = tick {
    _seedDrivers();
    if (autoStart) {
      _timer = Timer.periodic(tick, (_) => advance(_tickInterval));
    }
  }

  final TownConfig town;
  final RouteService routes;
  final math.Random _random;
  final FareCalculator _fares;
  final Duration _tickInterval;
  Timer? _timer;

  static const offerWindow = Duration(seconds: 15);
  static const _searchDelay = Duration(milliseconds: 1800);
  static const _botAcceptDelay = Duration(milliseconds: 2500);
  static const _botStartDelay = Duration(seconds: 3);
  static const _botFinishDelay = Duration(seconds: 2);
  static const _retryDelay = Duration(seconds: 2);

  final _changes = StreamController<void>.broadcast();
  final _trips = <String, Trip>{};
  final _riderTrip = <String, String>{};
  final _drivers = <String, _DriverState>{};
  final _legs = <String, _Leg>{};
  final _rejected = <String, Set<String>>{};
  final _scheduled = <_Scheduled>[];
  Duration _clock = Duration.zero;
  int _seq = 0;
  bool _disposed = false;

  // ── Arranque ─────────────────────────────────────────────────────────────

  void _seedDrivers() {
    _drivers[DemoProfiles.driver.id] = _DriverState(
      profile: DemoProfiles.driver,
      position: town.driverStart,
      isBot: false,
      online: false,
      earningsToday: 420,
      tripsToday: 6,
    );
    for (var i = 0; i < DemoProfiles.botDrivers.length; i++) {
      final spawn = town.taxiSpawnPoints[i % town.taxiSpawnPoints.length];
      _drivers[DemoProfiles.botDrivers[i].id] = _DriverState(
        profile: DemoProfiles.botDrivers[i],
        position: spawn,
        isBot: true,
        online: true,
      )..wanderTarget = randomPointNear(town.center, _random, minMeters: 100, maxMeters: 900);
    }
  }

  // ── Lecturas ─────────────────────────────────────────────────────────────

  Stream<T> _watch<T>(T Function() read) {
    return Stream<T>.multi((controller) {
      controller.add(read());
      final sub = _changes.stream.listen((_) => controller.add(read()));
      controller.onCancel = sub.cancel;
    });
  }

  void _notify() {
    if (!_disposed) _changes.add(null);
  }

  @override
  Stream<Trip?> watchRiderTrip(String riderId) => _watch(() => _trips[_riderTrip[riderId]]);

  @override
  Stream<List<NearbyTaxi>> watchNearbyTaxis() => _watch(
        () => [
          for (final d in _drivers.values)
            if (d.online && d.tripId == null && d.offerTripId == null)
              NearbyTaxi(id: d.profile.id, position: d.position, heading: d.heading),
        ],
      );

  @override
  Stream<DriverSession> watchDriver(String driverId) => _watch(() {
        final d = _driver(driverId);
        return DriverSession(
          profile: d.profile,
          position: d.position,
          online: d.online,
          earningsToday: d.earningsToday,
          tripsToday: d.tripsToday,
          offer: _trips[d.offerTripId],
          trip: _trips[d.tripId],
          lastCompleted: _trips[d.lastCompletedId],
        );
      });

  // ── Pasajero ─────────────────────────────────────────────────────────────

  @override
  Future<Trip> requestTrip(TripRequest request) async {
    final previous = _riderTrip[request.rider.id];
    if (previous != null && (_trips[previous]?.status.isActive ?? false)) {
      throw StateError('El pasajero ya tiene un viaje activo.');
    }
    final trip = Trip(
      id: 'trip-${++_seq}',
      rider: request.rider,
      pickup: request.pickup,
      destination: request.destination,
      type: request.type,
      quote: request.quote,
      route: request.route,
      status: TripStatus.searching,
      createdAt: DateTime.now(),
    );
    _trips[trip.id] = trip;
    _riderTrip[request.rider.id] = trip.id;
    _notify();
    _schedule(_searchDelay, () => _dispatch(trip.id));
    return trip;
  }

  @override
  Future<void> cancelTrip(String tripId, {required CancelledBy by}) async {
    final trip = _trips[tripId];
    if (trip == null || !trip.status.isActive) return;

    if (by == CancelledBy.driver && trip.status.index < TripStatus.inProgress.index) {
      // El taxista suelta el viaje: se le busca otro al pasajero.
      final driverId = trip.driver?.id;
      if (driverId != null) {
        _rejected.putIfAbsent(tripId, () => {}).add(driverId);
        _release(driverId);
      }
      _legs.remove(tripId);
      _trips[tripId] = trip.copyWith(status: TripStatus.searching, clearDriver: true, clearOffer: true, progress: 0);
      _notify();
      _schedule(_searchDelay, () => _dispatch(tripId));
      return;
    }

    _legs.remove(tripId);
    for (final d in _drivers.values) {
      if (d.tripId == tripId || d.offerTripId == tripId) _release(d.profile.id);
    }
    _trips[tripId] = trip.copyWith(status: TripStatus.cancelled, cancelledBy: by, clearOffer: true);
    _notify();
  }

  @override
  Future<void> rateDriver(String tripId, {required int stars, int tip = 0}) async {
    final trip = _trips[tripId];
    if (trip == null) return;
    _trips[tripId] = trip.copyWith(driverRatingByRider: stars, tip: tip);
    final driver = _drivers[trip.driver?.id];
    if (driver != null && tip > 0) driver.earningsToday += tip;
    _notify();
  }

  @override
  Future<void> dismissRiderTrip(String riderId) async {
    final id = _riderTrip[riderId];
    if (id == null || (_trips[id]?.status.isActive ?? false)) return;
    _riderTrip.remove(riderId);
    _notify();
  }

  // ── Taxista ──────────────────────────────────────────────────────────────

  @override
  Future<void> setOnline(String driverId, {required bool online}) async {
    final d = _driver(driverId);
    if (!online && (d.tripId != null)) return; // no se desconecta a media carrera
    if (!online && d.offerTripId != null) await rejectOffer(driverId, d.offerTripId!);
    d.online = online;
    _notify();
  }

  @override
  Future<void> acceptOffer(String driverId, String tripId) async {
    final d = _driver(driverId);
    final trip = _trips[tripId];
    if (trip == null || trip.status != TripStatus.offered || d.offerTripId != tripId) return;

    d
      ..offerTripId = null
      ..tripId = tripId;
    _trips[tripId] = trip.copyWith(
      status: TripStatus.driverEnRoute,
      driver: d.profile,
      driverPosition: d.position,
      progress: 0,
      clearOffer: true,
    );
    _notify();

    final approach = await routes.route(d.position, trip.pickup.point);
    final current = _trips[tripId];
    if (current == null || current.status != TripStatus.driverEnRoute) return;
    _legs[tripId] = _Leg(approach);
    _trips[tripId] = current.copyWith(approachRoute: approach, etaSeconds: approach.durationSeconds);
    _notify();
  }

  @override
  Future<void> rejectOffer(String driverId, String tripId) async {
    final d = _driver(driverId);
    if (d.offerTripId != tripId) return;
    d.offerTripId = null;
    _rejected.putIfAbsent(tripId, () => {}).add(driverId);
    final trip = _trips[tripId];
    if (trip != null && trip.status == TripStatus.offered) {
      _trips[tripId] = trip.copyWith(status: TripStatus.searching, clearOffer: true);
      // Los viajes de pasajeros simulados no se reasignan: desaparecen.
      if (_isBotRider(trip)) {
        _trips[tripId] = trip.copyWith(status: TripStatus.cancelled, cancelledBy: CancelledBy.system, clearOffer: true);
      } else {
        _schedule(_retryDelay, () => _dispatch(tripId));
      }
    }
    _notify();
  }

  @override
  Future<void> markArrived(String tripId) async {
    final trip = _trips[tripId];
    if (trip == null || trip.status != TripStatus.driverEnRoute) return;
    _legs.remove(tripId);
    _trips[tripId] = trip.copyWith(
      status: TripStatus.driverArrived,
      driverPosition: trip.pickup.point,
      progress: 1,
      etaSeconds: 0,
    );
    _drivers[trip.driver?.id]?.position = trip.pickup.point;
    _notify();
  }

  @override
  Future<void> startTrip(String tripId) async {
    final trip = _trips[tripId];
    if (trip == null || trip.status != TripStatus.driverArrived) return;
    _legs[tripId] = _Leg(trip.route);
    _trips[tripId] = trip.copyWith(
      status: TripStatus.inProgress,
      progress: 0,
      etaSeconds: trip.route.durationSeconds,
      driverPosition: trip.pickup.point,
    );
    _notify();
  }

  @override
  Future<void> completeTrip(String tripId) async {
    final trip = _trips[tripId];
    if (trip == null || trip.status != TripStatus.inProgress) return;
    _legs.remove(tripId);
    final fare = trip.quote.estimate;
    _trips[tripId] = trip.copyWith(
      status: TripStatus.completed,
      finalFare: fare,
      progress: 1,
      etaSeconds: 0,
      driverPosition: trip.destination.point,
    );
    final d = _drivers[trip.driver?.id];
    if (d != null) {
      d
        ..position = trip.destination.point
        ..tripId = null
        ..earningsToday += fare
        ..tripsToday += 1
        ..lastCompletedId = d.isBot ? null : tripId;
    }
    _notify();
  }

  @override
  Future<void> rateRider(String tripId, {required int stars}) async {
    final trip = _trips[tripId];
    if (trip == null) return;
    _trips[tripId] = trip.copyWith(riderRatingByDriver: stars);
    for (final d in _drivers.values) {
      if (d.lastCompletedId == tripId) d.lastCompletedId = null;
    }
    _notify();
  }

  @override
  Future<void> simulateIncomingRequest(String driverId) async {
    final d = _driver(driverId);
    if (d.tripId != null || d.offerTripId != null) return;
    d
      ..online = true
      ..lastCompletedId = null;

    final near = [...town.places]..sort((a, b) => metersBetween(a.point, d.position).compareTo(metersBetween(b.point, d.position)));
    final pickup = near[_random.nextInt(math.min(4, near.length))];
    final destinations = town.places.where((p) => p.id != pickup.id).toList();
    final destination = destinations[_random.nextInt(destinations.length)];
    final rider = DemoProfiles.botRiders[_random.nextInt(DemoProfiles.botRiders.length)];
    const type = VehicleType.taxi;

    final route = await routes.route(pickup.point, destination.point);
    if (d.tripId != null || d.offerTripId != null) return;

    final trip = Trip(
      id: 'trip-${++_seq}',
      rider: rider,
      pickup: pickup,
      destination: destination,
      type: type,
      quote: _fares.quote(route, type),
      route: route,
      status: TripStatus.searching,
      createdAt: DateTime.now(),
    );
    _trips[trip.id] = trip;
    _offer(trip.id, d);
    _notify();
  }

  // ── Despacho ─────────────────────────────────────────────────────────────

  void _dispatch(String tripId) {
    final trip = _trips[tripId];
    if (trip == null || trip.status != TripStatus.searching) return;

    final rejected = _rejected[tripId] ?? const <String>{};
    final free = _drivers.values
        .where((d) => d.online && d.tripId == null && d.offerTripId == null && !rejected.contains(d.profile.id))
        .toList();
    if (free.isEmpty) {
      _schedule(_retryDelay, () => _dispatch(tripId));
      return;
    }

    // Si el taxista de la demo está conectado y libre, la solicitud le llega a
    // él; así se puede jugar el flujo completo con las dos vistas.
    final demo = free.where((d) => !d.isBot).firstOrNull;
    free.sort((a, b) => metersBetween(a.position, trip.pickup.point).compareTo(metersBetween(b.position, trip.pickup.point)));
    _offer(tripId, demo ?? free.first);
    _notify();
  }

  void _offer(String tripId, _DriverState d) {
    final trip = _trips[tripId]!;
    d.offerTripId = tripId;
    _trips[tripId] = trip.copyWith(
      status: TripStatus.offered,
      offerExpiresAt: DateTime.now().add(offerWindow),
    );
    if (d.isBot) {
      _schedule(_botAcceptDelay, () => acceptOffer(d.profile.id, tripId));
    } else {
      _schedule(offerWindow, () {
        if (d.offerTripId == tripId) rejectOffer(d.profile.id, tripId);
      });
    }
  }

  void _release(String driverId) {
    final d = _drivers[driverId];
    if (d == null) return;
    d
      ..tripId = null
      ..offerTripId = null;
  }

  bool _isBotRider(Trip trip) => DemoProfiles.botRiders.any((r) => r.id == trip.rider.id);

  // ── Reloj ────────────────────────────────────────────────────────────────

  void _schedule(Duration delay, FutureOr<void> Function() action) {
    _scheduled.add(_Scheduled(_clock + delay, action));
  }

  /// Avanza el reloj de la simulación. El timer lo llama solo; las pruebas lo
  /// llaman a mano (con `autoStart: false`).
  @visibleForTesting
  void advance(Duration dt) {
    if (_disposed) return;
    _clock += dt;
    final seconds = dt.inMicroseconds / Duration.microsecondsPerSecond;
    var changed = false;

    // 1. Acciones agendadas que ya vencieron.
    final due = _scheduled.where((s) => s.at <= _clock).toList();
    _scheduled.removeWhere(due.contains);
    for (final s in due) {
      s.action();
    }

    // 2. Taxis con viaje avanzan sobre su ruta.
    for (final entry in _legs.entries.toList()) {
      final trip = _trips[entry.key];
      if (trip == null) continue;
      final leg = entry.value;
      final progress = math.min(1.0, trip.progress + seconds / leg.simSeconds);
      final here = leg.cursor.at(progress);
      final d = _drivers[trip.driver?.id];
      d
        ?..position = here.point
        ..heading = here.heading;
      _trips[trip.id] = trip.copyWith(
        progress: progress,
        driverPosition: here.point,
        etaSeconds: leg.route.durationSeconds * (1 - progress),
      );
      changed = true;

      if (progress >= 1) {
        _legs.remove(trip.id);
        if (trip.status == TripStatus.driverEnRoute) {
          markArrived(trip.id);
          if (d != null && d.isBot) _schedule(_botStartDelay, () => startTrip(trip.id));
        } else if (d != null && d.isBot) {
          _schedule(_botFinishDelay, () => completeTrip(trip.id));
        }
      }
    }

    // 3. Taxis libres simulados dan vueltas por el centro.
    for (final d in _drivers.values) {
      if (!d.isBot || d.tripId != null || d.offerTripId != null) continue;
      final target = d.wanderTarget ?? town.center;
      final dist = metersBetween(d.position, target);
      const speed = 6.0; // m/s, como taxi buscando pasaje
      if (dist < 15) {
        d.wanderTarget = randomPointNear(town.center, _random, minMeters: 100, maxMeters: 900);
        continue;
      }
      final f = math.min(1.0, speed * seconds / dist);
      d
        ..heading = bearingBetween(d.position, target)
        ..position = LatLng(
          d.position.latitude + (target.latitude - d.position.latitude) * f,
          d.position.longitude + (target.longitude - d.position.longitude) * f,
        );
      changed = true;
    }

    if (changed || due.isNotEmpty) _notify();
  }

  _DriverState _driver(String id) {
    final d = _drivers[id];
    if (d == null) throw ArgumentError.value(id, 'driverId', 'Taxista desconocido');
    return d;
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _changes.close();
  }
}

class _DriverState {
  _DriverState({
    required this.profile,
    required this.position,
    required this.isBot,
    required this.online,
    this.earningsToday = 0,
    this.tripsToday = 0,
  });

  final DriverProfile profile;
  final bool isBot;
  LatLng position;
  double heading = 0;
  bool online;
  int earningsToday;
  int tripsToday;
  String? tripId;
  String? offerTripId;
  String? lastCompletedId;
  LatLng? wanderTarget;
}

/// Un tramo que se recorre comprimido: entre 8 y 25 s sin importar la distancia.
class _Leg {
  _Leg(this.route)
      : cursor = PolylineCursor(route.points),
        simSeconds = (route.durationSeconds / 12).clamp(8.0, 25.0);

  final RouteInfo route;
  final PolylineCursor cursor;
  final double simSeconds;
}

class _Scheduled {
  _Scheduled(this.at, this.action);
  final Duration at;
  final FutureOr<void> Function() action;
}
