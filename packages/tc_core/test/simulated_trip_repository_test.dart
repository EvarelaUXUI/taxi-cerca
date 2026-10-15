import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:tc_core/tc_core.dart';

void main() {
  late SimulatedTripRepository repo;
  const routes = ApproximateRouteService();
  const calc = FareCalculator(FareRules(baseFare: 25, perKm: 7, perMinute: 1.5, minimumFare: 40));
  final driverId = DemoProfiles.driver.id;
  final riderId = DemoProfiles.rider.id;

  setUp(() {
    repo = SimulatedTripRepository(town: ixtlahuaca, routes: routes, random: math.Random(7), autoStart: false);
  });
  tearDown(() => repo.dispose());

  /// Avanza la simulación en pasos de 200 ms y deja correr los futures.
  Future<void> run(Duration total) async {
    var elapsed = Duration.zero;
    while (elapsed < total) {
      repo.advance(const Duration(milliseconds: 200));
      elapsed += const Duration(milliseconds: 200);
      await Future<void>.delayed(Duration.zero);
    }
  }

  Future<Trip?> riderTrip() => repo.watchRiderTrip(riderId).first;
  Future<DriverSession> driver() => repo.watchDriver(driverId).first;

  Future<Trip> request() async {
    final pickup = ixtlahuaca.riderHome;
    final destination = ixtlahuaca.placeById('hospital');
    final route = await routes.route(pickup.point, destination.point);
    return repo.requestTrip(
      TripRequest(
        rider: DemoProfiles.rider,
        pickup: pickup,
        destination: destination,
        type: VehicleType.taxi,
        route: route,
        quote: calc.quote(route, VehicleType.taxi),
      ),
    );
  }

  test('con el taxista de la demo conectado, el viaje completo funciona', () async {
    await repo.setOnline(driverId, online: true);
    await request();
    expect((await riderTrip())!.status, TripStatus.searching);

    await run(const Duration(seconds: 2));
    final offer = (await driver()).offer;
    expect(offer, isNotNull, reason: 'la solicitud le llega al taxista de la demo');
    expect((await riderTrip())!.status, TripStatus.offered);

    await repo.acceptOffer(driverId, offer!.id);
    await Future<void>.delayed(Duration.zero);
    expect((await riderTrip())!.status, TripStatus.driverEnRoute);
    expect((await riderTrip())!.driver!.id, driverId);

    await run(const Duration(seconds: 26));
    expect((await riderTrip())!.status, TripStatus.driverArrived);

    await repo.startTrip(offer.id);
    await run(const Duration(seconds: 26));
    final atEnd = (await riderTrip())!;
    expect(atEnd.status, TripStatus.inProgress);
    expect(atEnd.atDestination, isTrue, reason: 'el taxista de la demo termina a mano');

    final before = (await driver()).earningsToday;
    await repo.completeTrip(offer.id);
    final done = (await riderTrip())!;
    expect(done.status, TripStatus.completed);
    expect(done.finalFare, done.quote.estimate);
    final session = await driver();
    expect(session.earningsToday, before + done.finalFare!);
    expect(session.lastCompleted?.id, offer.id);

    await repo.rateDriver(offer.id, stars: 5, tip: 10);
    await repo.rateRider(offer.id, stars: 5);
    expect((await driver()).lastCompleted, isNull);
    await repo.dismissRiderTrip(riderId);
    expect(await riderTrip(), isNull);
  });

  test('si el taxista de la demo rechaza, otro taxista (bot) toma el viaje', () async {
    await repo.setOnline(driverId, online: true);
    final trip = await request();
    await run(const Duration(seconds: 2));
    await repo.rejectOffer(driverId, trip.id);

    await run(const Duration(seconds: 6));
    final t = (await riderTrip())!;
    expect(t.status, TripStatus.driverEnRoute);
    expect(t.driver!.id, isNot(driverId));
  });

  test('si la oferta vence, se le pasa a otro taxista', () async {
    await repo.setOnline(driverId, online: true);
    await request();
    await run(const Duration(seconds: 2));
    expect((await driver()).offer, isNotNull);

    await run(SimulatedTripRepository.offerWindow + const Duration(seconds: 6));
    expect((await driver()).offer, isNull);
    expect((await riderTrip())!.driver?.id, isNot(driverId));
  });

  test('sin taxista de la demo, un bot atiende y termina solo', () async {
    await request();
    await run(const Duration(seconds: 80));
    expect((await riderTrip())!.status, TripStatus.completed);
  });

  test('el pasajero puede cancelar mientras busca', () async {
    final trip = await request();
    await repo.cancelTrip(trip.id, by: CancelledBy.rider);
    final t = (await riderTrip())!;
    expect(t.status, TripStatus.cancelled);
    await run(const Duration(seconds: 5));
    expect((await riderTrip())!.status, TripStatus.cancelled, reason: 'no se reasigna');
  });

  test('simular solicitud conecta al taxista y le manda una oferta', () async {
    await repo.simulateIncomingRequest(driverId);
    final s = await driver();
    expect(s.online, isTrue);
    expect(s.offer, isNotNull);
    expect(s.offer!.quote.estimate, greaterThanOrEqualTo(40));
  });

  test('el taxista no se puede desconectar a media carrera', () async {
    await repo.simulateIncomingRequest(driverId);
    final offer = (await driver()).offer!;
    await repo.acceptOffer(driverId, offer.id);
    await repo.setOnline(driverId, online: false);
    expect((await driver()).online, isTrue);
  });
}
