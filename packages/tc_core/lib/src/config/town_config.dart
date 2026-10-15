import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../models/place.dart';

/// Reglas de tarifa del pueblo, en pesos (MXN).
@immutable
class FareRules {
  const FareRules({
    required this.baseFare,
    required this.perKm,
    required this.perMinute,
    required this.minimumFare,
    this.rangeSpread = 0.10,
    this.roundTo = 5,
  });

  final double baseFare;
  final double perKm;
  final double perMinute;
  final double minimumFare;

  /// Margen del rango que ve el pasajero (±10 %).
  final double rangeSpread;

  /// Los montos se redondean a este múltiplo, porque se paga en efectivo.
  final int roundTo;
}

/// Todo lo que cambia de un pueblo a otro. Para llevar el demo a otro lugar
/// basta con crear otro [TownConfig] y pasarlo en `townConfigProvider`.
@immutable
class TownConfig {
  const TownConfig({
    required this.name,
    required this.state,
    required this.center,
    required this.places,
    required this.riderHome,
    required this.driverStart,
    required this.taxiSpawnPoints,
    required this.fareRules,
    this.initialZoom = 15,
  });

  final String name;
  final String state;
  final LatLng center;
  final double initialZoom;

  /// Destinos frecuentes que el pasajero puede elegir.
  final List<Place> places;

  /// Ubicación inicial del pasajero de la demo. Es lo que ve el taxista como
  /// punto de recogida; el pasajero la ve como "Mi ubicación".
  final Place riderHome;

  /// Ubicación inicial del taxista de la demo.
  final LatLng driverStart;

  /// Dónde aparecen los taxis simulados.
  final List<LatLng> taxiSpawnPoints;
  final FareRules fareRules;

  Place placeById(String id) => places.firstWhere((p) => p.id == id);
}

/// Ixtlahuaca de Rayón, Estado de México.
/// Coordenadas tomadas de OpenStreetMap (Nominatim), octubre 2026.
const ixtlahuaca = TownConfig(
  name: 'Ixtlahuaca',
  state: 'Estado de México',
  center: LatLng(19.5652, -99.7619),
  riderHome: Place(
    id: 'home',
    name: 'Calle Santos Mercado Valdez',
    address: 'Centro, Ixtlahuaca',
    point: LatLng(19.5668, -99.7627),
    kind: PlaceKind.home,
  ),
  driverStart: LatLng(19.5698, -99.7575),
  taxiSpawnPoints: [
    LatLng(19.5640, -99.7652),
    LatLng(19.5681, -99.7600),
    LatLng(19.5625, -99.7590),
    LatLng(19.5712, -99.7640),
    LatLng(19.5660, -99.7672),
  ],
  fareRules: FareRules(baseFare: 25, perKm: 7, perMinute: 1.5, minimumFare: 40),
  places: [
    Place(
      id: 'centro',
      name: 'Centro de Ixtlahuaca',
      address: 'Jardín principal, Ixtlahuaca de Rayón',
      point: LatLng(19.56525, -99.76189),
      kind: PlaceKind.center,
    ),
    Place(
      id: 'mercado',
      name: 'Mercado Municipal',
      address: 'Calle Santos Mercado Valdez',
      point: LatLng(19.56796, -99.76343),
      kind: PlaceKind.market,
    ),
    Place(
      id: 'terminal',
      name: 'Terminal de Autobuses',
      address: 'Gustavo Baz Prada',
      point: LatLng(19.56395, -99.76516),
      kind: PlaceKind.transport,
    ),
    Place(
      id: 'hospital',
      name: 'Hospital General',
      address: 'Calle Saitama, San Francisco de Asís',
      point: LatLng(19.56997, -99.75588),
      kind: PlaceKind.health,
    ),
    Place(
      id: 'cui',
      name: 'Centro Universitario Ixtlahuaca',
      address: 'Camino al CUI',
      point: LatLng(19.57248, -99.75461),
      kind: PlaceKind.school,
    ),
    Place(
      id: 'san-francisco',
      name: 'San Francisco de Asís',
      address: 'Calle 4 de Octubre',
      point: LatLng(19.57897, -99.75742),
      kind: PlaceKind.town,
    ),
    Place(
      id: 'santo-domingo',
      name: 'Santo Domingo de Guzmán',
      address: 'Ixtlahuaca, Edo. Méx.',
      point: LatLng(19.59322, -99.77343),
      kind: PlaceKind.town,
    ),
    Place(
      id: 'emiliano-zapata',
      name: 'Emiliano Zapata',
      address: 'Ixtlahuaca, Edo. Méx.',
      point: LatLng(19.50081, -99.78081),
      kind: PlaceKind.town,
    ),
    Place(
      id: 'deportiva',
      name: 'Unidad Deportiva Gustavo Baz',
      address: 'Carretera Ixtlahuaca–Naucalpan',
      point: LatLng(19.57771, -99.70879),
      kind: PlaceKind.sports,
    ),
    Place(
      id: 'san-pedro',
      name: 'San Pedro de los Baños',
      address: 'Ixtlahuaca, Edo. Méx.',
      point: LatLng(19.66150, -99.82917),
      kind: PlaceKind.town,
    ),
    Place(
      id: 'tes-jocotitlan',
      name: 'Tecnológico de Jocotitlán',
      address: 'Carretera Ixtlahuaca–Jocotitlán',
      point: LatLng(19.67574, -99.80075),
      kind: PlaceKind.school,
    ),
  ],
);
