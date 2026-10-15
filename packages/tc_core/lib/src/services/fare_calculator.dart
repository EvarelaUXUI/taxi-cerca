import '../config/town_config.dart';
import '../models/fare_quote.dart';
import '../models/route_info.dart';

/// Calcula precios a partir de las reglas del pueblo. Es puro y sin estado.
class FareCalculator {
  const FareCalculator(this.rules);

  final FareRules rules;

  /// Precio estimado y rango para una ruta y un tipo de servicio.
  FareQuote quote(RouteInfo route, VehicleType type) {
    final raw = _raw(route.distanceKm, route.durationMinutes) * type.multiplier;
    final estimate = _round(raw);
    return FareQuote(
      type: type,
      estimate: estimate,
      min: _round(raw * (1 - rules.rangeSpread)),
      max: _round(raw * (1 + rules.rangeSpread)),
    );
  }

  double _raw(double km, double minutes) {
    final value = rules.baseFare + rules.perKm * km + rules.perMinute * minutes;
    return value < rules.minimumFare ? rules.minimumFare : value;
  }

  int _round(double value) {
    final step = rules.roundTo;
    final rounded = (value / step).round() * step;
    return rounded < rules.minimumFare ? rules.minimumFare.round() : rounded;
  }
}
