import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

/// Categoría de un lugar; la UI la traduce a un ícono.
enum PlaceKind { center, market, health, school, transport, sports, town, home, pin }

/// Un punto con nombre: destino frecuente, recogida o ubicación del pasajero.
@immutable
class Place {
  const Place({
    required this.id,
    required this.name,
    required this.address,
    required this.point,
    this.kind = PlaceKind.pin,
  });

  final String id;
  final String name;
  final String address;
  final LatLng point;
  final PlaceKind kind;

  @override
  bool operator ==(Object other) => other is Place && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Place($id)';
}
