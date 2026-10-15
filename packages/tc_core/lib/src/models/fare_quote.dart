import 'package:flutter/foundation.dart';

/// Tipo de servicio que elige el pasajero.
enum VehicleType {
  taxi('Taxi', 'Hasta 4 personas', 4, 1.0),
  grande('Taxi Grande', 'Hasta 6 personas o con carga', 6, 1.3);

  const VehicleType(this.label, this.description, this.seats, this.multiplier);

  final String label;
  final String description;
  final int seats;
  final double multiplier;
}

enum PaymentMethod {
  cash('Efectivo');

  const PaymentMethod(this.label);
  final String label;
}

/// Precio estimado de un viaje en pesos (MXN).
@immutable
class FareQuote {
  const FareQuote({
    required this.type,
    required this.estimate,
    required this.min,
    required this.max,
  });

  final VehicleType type;

  /// Precio que se cobra si la ruta no cambia. Redondeado a múltiplos de 5.
  final int estimate;
  final int min;
  final int max;
}
