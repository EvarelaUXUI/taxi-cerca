import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';

/// Pasajero con sesión. En la demo es fijo; con login real se sobrescribe.
final riderProfileProvider = Provider<RiderProfile>((ref) => DemoProfiles.rider);

/// Viaje actual del pasajero, en vivo.
final riderTripProvider = StreamProvider<Trip?>((ref) {
  final rider = ref.watch(riderProfileProvider);
  return ref.watch(tripRepositoryProvider).watchRiderTrip(rider.id);
});

/// Taxis libres alrededor.
final nearbyTaxisProvider = StreamProvider<List<NearbyTaxi>>(
  (ref) => ref.watch(tripRepositoryProvider).watchNearbyTaxis(),
);

/// Pasos antes de pedir el taxi. Lo que pasa después lo manda el viaje.
enum RiderStep { home, search, confirm }

@immutable
class RiderDraft {
  const RiderDraft({
    required this.step,
    required this.pickup,
    this.destination,
    this.route,
    this.loadingRoute = false,
    this.type = VehicleType.taxi,
    this.requesting = false,
    this.error,
  });

  final RiderStep step;
  final Place pickup;
  final Place? destination;
  final RouteInfo? route;
  final bool loadingRoute;
  final VehicleType type;
  final bool requesting;
  final String? error;

  RiderDraft copyWith({
    RiderStep? step,
    Place? destination,
    RouteInfo? route,
    bool clearRoute = false,
    bool? loadingRoute,
    VehicleType? type,
    bool? requesting,
    String? error,
    bool clearError = false,
  }) {
    return RiderDraft(
      step: step ?? this.step,
      pickup: pickup,
      destination: destination ?? this.destination,
      route: clearRoute ? null : route ?? this.route,
      loadingRoute: loadingRoute ?? this.loadingRoute,
      type: type ?? this.type,
      requesting: requesting ?? this.requesting,
      error: clearError ? null : error ?? this.error,
    );
  }
}

final riderDraftProvider = NotifierProvider<RiderDraftController, RiderDraft>(RiderDraftController.new);

/// Lleva el armado del viaje: elegir destino, ver precio y pedir.
class RiderDraftController extends Notifier<RiderDraft> {
  @override
  RiderDraft build() => RiderDraft(step: RiderStep.home, pickup: ref.watch(townConfigProvider).riderHome);

  void openSearch() => state = state.copyWith(step: RiderStep.search, clearError: true);

  void back() => state = switch (state.step) {
        RiderStep.confirm => state.copyWith(step: RiderStep.search, clearRoute: true),
        _ => RiderDraft(step: RiderStep.home, pickup: state.pickup),
      };

  Future<void> chooseDestination(Place place) async {
    state = state.copyWith(step: RiderStep.confirm, destination: place, clearRoute: true, loadingRoute: true, clearError: true);
    final route = await ref.read(routeServiceProvider).route(state.pickup.point, place.point);
    if (!ref.mounted || state.destination != place) return;
    state = state.copyWith(route: route, loadingRoute: false);
  }

  /// Regresa al inicio (al cerrar un viaje terminado o cancelado).
  void reset() => state = RiderDraft(step: RiderStep.home, pickup: state.pickup);

  void selectType(VehicleType type) => state = state.copyWith(type: type);

  FareQuote? quoteFor(VehicleType type) {
    final route = state.route;
    return route == null ? null : ref.read(fareCalculatorProvider).quote(route, type);
  }

  Future<void> request() async {
    final route = state.route;
    final destination = state.destination;
    if (route == null || destination == null || state.requesting) return;
    state = state.copyWith(requesting: true, clearError: true);
    try {
      await ref.read(tripRepositoryProvider).requestTrip(
            TripRequest(
              rider: ref.read(riderProfileProvider),
              pickup: state.pickup,
              destination: destination,
              type: state.type,
              route: route,
              quote: quoteFor(state.type)!,
            ),
          );
      // El viaje toma el control de la pantalla. El borrador se queda igual
      // (el panel de Confirmar sigue visible mientras sale con la animación)
      // y se limpia con [reset] cuando el pasajero cierra el viaje.
      if (ref.mounted) state = state.copyWith(requesting: false);
    } on Object catch (e) {
      debugPrint('requestTrip falló: $e');
      if (!ref.mounted) return;
      state = state.copyWith(requesting: false, error: 'No pudimos pedir tu taxi. Revisa tu conexión e intenta de nuevo.');
    }
  }
}
