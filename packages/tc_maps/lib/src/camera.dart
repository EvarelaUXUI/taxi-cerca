import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Ajusta la cámara para que se vean todos los [points].
/// [padding] deja espacio para el panel inferior y los botones de arriba.
void fitMapTo(MapController controller, List<LatLng> points, {EdgeInsets padding = const EdgeInsets.all(48), double maxZoom = 17}) {
  if (points.isEmpty) return;
  // Un solo punto: se encuadra una caja de ~600 m a su alrededor para que el
  // padding también aplique y el punto quede arriba del panel.
  final coords = points.length > 1
      ? points
      : [
          LatLng(points.first.latitude - 0.003, points.first.longitude - 0.003),
          LatLng(points.first.latitude + 0.003, points.first.longitude + 0.003),
        ];
  try {
    controller.fitCamera(
      CameraFit.coordinates(coordinates: coords, padding: padding, maxZoom: maxZoom),
    );
  } on Object {
    // El mapa todavía no está listo; se reintenta en el siguiente cambio.
  }
}
