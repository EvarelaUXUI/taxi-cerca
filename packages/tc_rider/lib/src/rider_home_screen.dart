import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';
import 'package:tc_maps/tc_maps.dart';

import 'panels/confirm_panel.dart';
import 'panels/driver_assigned_panel.dart';
import 'panels/home_panel.dart';
import 'panels/in_trip_panel.dart';
import 'panels/search_panel.dart';
import 'panels/searching_panel.dart';
import 'panels/trip_closed_panel.dart';
import 'rider_controller.dart';
import 'rider_map_layers.dart';

/// Pantalla única del pasajero: el mapa ocupa todo y un panel inferior cambia
/// según el paso (elegir destino → confirmar → buscando → taxi en camino →
/// en viaje → calificar).
class RiderHomeScreen extends ConsumerStatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  ConsumerState<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends ConsumerState<RiderHomeScreen> {
  final _map = MapController();
  bool _mapReady = false;
  String? _cameraKey;

  @override
  void dispose() {
    _map.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final town = ref.watch(townConfigProvider);
    final draft = ref.watch(riderDraftProvider);
    final trip = ref.watch(riderTripProvider).value;
    final taxis = ref.watch(nearbyTaxisProvider).value ?? const [];

    final (Object panelKey, Widget panel) = _panelFor(draft, trip);
    _syncCamera(draft, trip, context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: TcMap(
              controller: _map,
              center: draft.pickup.point,
              zoom: town.initialZoom,
              onMapReady: () => setState(() => _mapReady = true),
              layers: riderMapLayers(context, draft: draft, trip: trip, taxis: taxis),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(TcSpace.x4),
                child: Row(
                  children: [
                    if (trip == null && draft.step != RiderStep.home)
                      TcIconButton(
                        icon: Icons.arrow_back_rounded,
                        tooltip: 'Regresar',
                        elevated: true,
                        onPressed: ref.read(riderDraftProvider.notifier).back,
                      )
                    else
                      const _Brand(),
                    const Spacer(),
                    TcIconButton(
                      icon: Icons.my_location_rounded,
                      tooltip: 'Centrar mapa',
                      elevated: true,
                      onPressed: () {
                        _cameraKey = null;
                        _syncCamera(draft, trip, context, force: true);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.78),
              child: TcBottomPanel(stateKey: panelKey, child: panel),
            ),
          ),
        ],
      ),
    );
  }

  (Object, Widget) _panelFor(RiderDraft draft, Trip? trip) {
    if (trip != null) {
      return switch (trip.status) {
        TripStatus.searching || TripStatus.offered => ('searching', SearchingPanel(trip: trip)),
        TripStatus.driverEnRoute || TripStatus.driverArrived => (trip.status, DriverAssignedPanel(trip: trip)),
        TripStatus.inProgress => ('inProgress', InTripPanel(trip: trip)),
        TripStatus.completed || TripStatus.cancelled => (trip.status, TripClosedPanel(trip: trip)),
      };
    }
    return switch (draft.step) {
      RiderStep.home => ('home', const HomePanel()),
      RiderStep.search => ('search', const SearchPanel()),
      RiderStep.confirm => ('confirm', const ConfirmPanel()),
    };
  }

  /// Mueve la cámara solo cuando cambia el paso, no en cada tick del taxi.
  void _syncCamera(RiderDraft draft, Trip? trip, BuildContext context, {bool force = false}) {
    final key = trip != null
        ? '${trip.id}:${trip.status.name}:${trip.approachRoute != null}'
        : '${draft.step.name}:${draft.destination?.id}:${draft.route != null}';
    if (!force && (key == _cameraKey || !_mapReady)) return;
    _cameraKey = key;

    final points = riderCameraPoints(draft: draft, trip: trip);
    final height = MediaQuery.sizeOf(context).height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      fitMapTo(
        _map,
        points,
        padding: EdgeInsets.fromLTRB(56, 96, 56, (height * 0.45).clamp(240, 420)),
      );
    });
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: TcSize.touch,
      padding: const EdgeInsets.symmetric(horizontal: TcSpace.x4),
      decoration: BoxDecoration(
        color: c.brand,
        borderRadius: BorderRadius.circular(TcRadius.pill),
        boxShadow: TcElevation.mid(c.shadow),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_taxi_rounded, color: c.onBrand),
          const SizedBox(width: TcSpace.x2),
          Text('Taxi Cerca', style: context.type.title.copyWith(color: c.onBrand)),
        ],
      ),
    );
  }
}
