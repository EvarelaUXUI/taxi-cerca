import 'package:flutter/foundation.dart';

/// Datos públicos del pasajero que ve el taxista.
@immutable
class RiderProfile {
  const RiderProfile({
    required this.id,
    required this.name,
    required this.rating,
    required this.trips,
    this.phone = '',
  });

  final String id;
  final String name;
  final double rating;
  final int trips;
  final String phone;

  String get firstName => name.split(' ').first;
}

/// Vehículo del taxista. [ecoNumber] es el número económico pintado en la puerta.
@immutable
class Vehicle {
  const Vehicle({
    required this.model,
    required this.color,
    required this.plate,
    required this.ecoNumber,
  });

  final String model;
  final String color;
  final String plate;
  final String ecoNumber;
}

/// Datos públicos del taxista que ve el pasajero.
@immutable
class DriverProfile {
  const DriverProfile({
    required this.id,
    required this.name,
    required this.rating,
    required this.trips,
    required this.vehicle,
    this.yearsDriving = 1,
  });

  final String id;
  final String name;
  final double rating;
  final int trips;
  final Vehicle vehicle;
  final int yearsDriving;

  String get firstName => name.split(' ').first;
}
