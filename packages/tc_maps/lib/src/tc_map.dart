import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tc_design_system/tc_design_system.dart';

/// Mapa base. Los mosaicos de OSM se desaturan para que el amarillo de marca y
/// la ruta resalten; en modo oscuro se invierten.
///
/// Los mosaicos públicos de OSM sirven para demos (política de uso:
/// https://operations.osmfoundation.org/policies/tiles/). En producción se
/// cambia [tileUrl] por un proveedor con contrato.
class TcMap extends StatelessWidget {
  const TcMap({
    super.key,
    required this.controller,
    required this.center,
    this.zoom = 15,
    this.layers = const [],
    this.onMapReady,
    this.tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    this.interactive = true,
  });

  final MapController controller;
  final LatLng center;
  final double zoom;
  final List<Widget> layers;
  final VoidCallback? onMapReady;
  final String tileUrl;
  final bool interactive;

  static const _lightFilter = ColorFilter.matrix(<double>[
    // Saturación 0.3 y un poco más de brillo.
    0.5, 0.45, 0.05, 0, 14, //
    0.15, 0.8, 0.05, 0, 14, //
    0.15, 0.45, 0.4, 0, 14, //
    0, 0, 0, 1, 0, //
  ]);

  static const _darkFilter = ColorFilter.matrix(<double>[
    // Invertido y desaturado: calles claras sobre fondo grafito.
    -0.45, -0.45, -0.1, 0, 235, //
    -0.35, -0.55, -0.1, 0, 230, //
    -0.35, -0.45, -0.2, 0, 225, //
    0, 0, 0, 1, 0, //
  ]);

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      label: 'Mapa',
      child: FlutterMap(
        mapController: controller,
        options: MapOptions(
          initialCenter: center,
          initialZoom: zoom,
          minZoom: 11,
          maxZoom: 18.5,
          backgroundColor: context.colors.surfaceSunken,
          onMapReady: onMapReady,
          interactionOptions: InteractionOptions(
            flags: interactive ? InteractiveFlag.all & ~InteractiveFlag.rotate : InteractiveFlag.none,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: tileUrl,
            userAgentPackageName: 'mx.taxicerca.demo',
            tileBuilder: (context, tile, _) => ColorFiltered(colorFilter: dark ? _darkFilter : _lightFilter, child: tile),
          ),
          ...layers,
          const _Attribution(),
        ],
      ),
    );
  }
}

class _Attribution extends StatelessWidget {
  const _Attribution();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: context.colors.surface.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('© OpenStreetMap', style: context.type.caption.copyWith(fontSize: 10, color: context.colors.textSecondary)),
          ),
        ),
      ),
    );
  }
}
