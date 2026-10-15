import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tc_design_system/tc_design_system.dart';

/// Línea de ruta con borde de marca. [dashed] para la ruta que todavía no se
/// recorre (p. ej. el viaje mientras el taxi va a la recogida).
PolylineLayer tcRoutePolylines(BuildContext context, List<LatLng> points, {bool dashed = false}) {
  final c = context.colors;
  if (points.length < 2) return const PolylineLayer(polylines: []);
  return PolylineLayer(
    polylines: [
      Polyline(
        points: points,
        strokeWidth: dashed ? 4 : 6,
        color: dashed ? c.mapRoute.withValues(alpha: 0.55) : c.mapRoute,
        borderStrokeWidth: dashed ? 0 : 3,
        borderColor: c.mapRouteCasing,
        pattern: dashed ? StrokePattern.dashed(segments: const [10, 8]) : const StrokePattern.solid(),
        strokeCap: StrokeCap.round,
        strokeJoin: StrokeJoin.round,
      ),
    ],
  );
}
