import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/town_config.dart';
import 'data/simulated_trip_repository.dart';
import 'data/trip_repository.dart';
import 'services/fare_calculator.dart';
import 'services/route_service.dart';

/// Pueblo activo. Para otro pueblo: `townConfigProvider.overrideWithValue(...)`.
final townConfigProvider = Provider<TownConfig>((ref) => ixtlahuaca);

final routeServiceProvider = Provider<RouteService>((ref) => OsrmRouteService());

final fareCalculatorProvider = Provider<FareCalculator>(
  (ref) => FareCalculator(ref.watch(townConfigProvider).fareRules),
);

/// Backend de viajes. Hoy es el simulador; en producción se sobrescribe en el
/// `ProviderScope` de cada app con la implementación real.
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final repo = SimulatedTripRepository(
    town: ref.watch(townConfigProvider),
    routes: ref.watch(routeServiceProvider),
  );
  ref.onDispose(repo.dispose);
  return repo;
});
