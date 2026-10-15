import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../geo.dart';
import '../models/route_info.dart';

/// Calcula rutas por calle. La UI y el simulador solo conocen esta interfaz.
abstract interface class RouteService {
  Future<RouteInfo> route(LatLng from, LatLng to);
}

/// Rutas con el servidor público de OSRM. Si falla o tarda, usa
/// [ApproximateRouteService] para que la demo nunca se quede trabada.
///
/// El servidor público es solo para demos; en producción se cambia por un
/// proveedor con contrato (ver `docs/ARQUITECTURA.md`).
class OsrmRouteService implements RouteService {
  OsrmRouteService({
    http.Client? client,
    this.baseUrl = 'https://router.project-osrm.org',
    this.timeout = const Duration(seconds: 6),
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  final Duration timeout;
  final _cache = <String, RouteInfo>{};
  final _fallback = const ApproximateRouteService();

  @override
  Future<RouteInfo> route(LatLng from, LatLng to) async {
    final key = '${_k(from)};${_k(to)}';
    final cached = _cache[key];
    if (cached != null) return cached;

    try {
      final uri = Uri.parse(
        '$baseUrl/route/v1/driving/${from.longitude},${from.latitude};${to.longitude},${to.latitude}'
        '?overview=full&geometries=geojson',
      );
      final res = await _client.get(uri).timeout(timeout);
      if (res.statusCode != 200) return await _fallback.route(from, to);

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final routes = body['routes'] as List<dynamic>?;
      if (body['code'] != 'Ok' || routes == null || routes.isEmpty) return await _fallback.route(from, to);

      final best = routes.first as Map<String, dynamic>;
      final coords = (best['geometry'] as Map<String, dynamic>)['coordinates'] as List<dynamic>;
      final points = [
        from,
        for (final c in coords)
          LatLng(((c as List<dynamic>)[1] as num).toDouble(), (c[0] as num).toDouble()),
        to,
      ];
      final info = RouteInfo(
        points: points,
        distanceMeters: (best['distance'] as num).toDouble(),
        durationSeconds: (best['duration'] as num).toDouble(),
      );
      _cache[key] = info;
      return info;
    } on Object {
      return await _fallback.route(from, to);
    }
  }

  // Redondeo a ~10 m para que la caché sirva aunque el punto se mueva poquito.
  String _k(LatLng p) => '${p.latitude.toStringAsFixed(4)},${p.longitude.toStringAsFixed(4)}';
}

/// Ruta aproximada sin red: línea en "L" (como calles en cuadrícula),
/// 10 % más larga por las vueltas y a 30 km/h de promedio.
class ApproximateRouteService implements RouteService {
  const ApproximateRouteService();

  @override
  Future<RouteInfo> route(LatLng from, LatLng to) async {
    final corner = LatLng(from.latitude, to.longitude);
    final meters = (metersBetween(from, corner) + metersBetween(corner, to)) * 1.1;
    return RouteInfo(
      points: [from, corner, to],
      distanceMeters: meters,
      durationSeconds: meters / (30 / 3.6),
      isApproximate: true,
    );
  }
}
