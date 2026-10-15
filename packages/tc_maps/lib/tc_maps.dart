/// Mapa de Taxi Cerca sobre flutter_map + OpenStreetMap.
///
/// Las pantallas solo usan [TcMap], los marcadores `Tc*Marker` y
/// [tcRoutePolylines]. Si un día se cambia de proveedor (Mapbox, Google), se
/// reescribe este paquete y nada más.
library;

export 'package:flutter_map/flutter_map.dart'
    show CameraFit, MapController, Marker, MarkerLayer, PolylineLayer, Polyline;

export 'src/camera.dart';
export 'src/markers.dart';
export 'src/place_icon.dart';
export 'src/route_layer.dart';
export 'src/tc_map.dart';
