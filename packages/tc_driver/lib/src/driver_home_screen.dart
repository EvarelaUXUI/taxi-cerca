import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';
import 'package:tc_maps/tc_maps.dart';

import 'driver_providers.dart';
import 'panels/completed_panel.dart';
import 'panels/idle_panel.dart';
import 'panels/offer_sheet.dart';
import 'panels/trip_panel.dart';

final _cursors = Expando<PolylineCursor>();
PolylineCursor _cursor(RouteInfo route) => _cursors[route] ??= PolylineCursor(route.points);

/// Pantalla única del taxista: mapa con su taxi, ganancias arriba y un panel
/// que cambia con el estado. La oferta de viaje entra encima de todo.
class DriverHomeScreen extends ConsumerStatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  ConsumerState<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends ConsumerState<DriverHomeScreen> {
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
    // Aviso de oferta nueva: vibración y sonido del sistema.
    ref.listen(driverSessionProvider.select((s) => s.value?.offer?.id), (prev, next) {
      if (next != null && next != prev) {
        HapticFeedback.heavyImpact();
        SystemSound.play(SystemSoundType.alert);
      }
    });

    final town = ref.watch(townConfigProvider);
    final session = ref.watch(driverSessionProvider).value;
    if (session == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    _syncCamera(session, context);
    final trip = session.trip;
    final offer = session.offer;

    final (Object key, Widget panel) = switch ((trip, session.lastCompleted)) {
      (final Trip t, _) => ('trip:${t.status.name}', DriverTripPanel(trip: t)),
      (null, final Trip done) => ('done', DriverCompletedPanel(trip: done)),
      _ => ('idle:${session.online}', DriverIdlePanel(session: session)),
    };

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: TcMap(
              controller: _map,
              center: session.position,
              zoom: town.initialZoom,
              onMapReady: () => setState(() => _mapReady = true),
              layers: _layers(context, session),
            ),
          ),
          if (!session.online && trip == null)
            Positioned.fill(
              child: IgnorePointer(child: ColoredBox(color: context.colors.background.withValues(alpha: 0.35))),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _EarningsCard(session: session)),
                    const SizedBox(width: TcSpace.x3),
                    TcIconButton(
                      icon: Icons.my_location_rounded,
                      tooltip: 'Centrar en mi taxi',
                      elevated: true,
                      onPressed: () {
                        _cameraKey = null;
                        _syncCamera(session, context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TcBottomPanel(stateKey: key, child: panel),
          ),
          if (offer != null) Positioned.fill(child: OfferSheet(key: ValueKey(offer.id), offer: offer, driverPosition: session.position)),
        ],
      ),
    );
  }

  List<Widget> _layers(BuildContext context, DriverSession s) {
    final trip = s.trip;
    final offer = s.offer;
    final layers = <Widget>[];
    final markers = <Marker>[];

    if (trip != null) {
      switch (trip.status) {
        case TripStatus.driverEnRoute:
          layers.add(tcRoutePolylines(context, trip.route.points, dashed: true));
          final a = trip.approachRoute;
          if (a != null) layers.add(tcRoutePolylines(context, _cursor(a).remainingFrom(trip.progress)));
          markers.addAll([tcPickupMarker(trip.pickup.point, label: 'Recoger a ${trip.rider.firstName}'), tcDestinationMarker(trip.destination.point)]);
        case TripStatus.driverArrived:
          layers.add(tcRoutePolylines(context, trip.route.points));
          markers.addAll([tcPickupMarker(trip.pickup.point), tcDestinationMarker(trip.destination.point)]);
        case TripStatus.inProgress:
          layers.add(tcRoutePolylines(context, _cursor(trip.route).remainingFrom(trip.progress)));
          markers.add(tcDestinationMarker(trip.destination.point));
        default:
          break;
      }
    } else if (offer != null) {
      layers.add(tcRoutePolylines(context, offer.route.points));
      markers.addAll([tcPickupMarker(offer.pickup.point), tcDestinationMarker(offer.destination.point)]);
    }

    final heading = switch (trip?.status) {
      TripStatus.driverEnRoute when trip!.approachRoute != null => _cursor(trip.approachRoute!).at(trip.progress).heading,
      TripStatus.inProgress => _cursor(trip!.route).at(trip.progress).heading,
      _ => 0.0,
    };
    markers.add(tcTaxiMarker(s.position, heading: heading, highlight: true, label: 'Tu taxi'));
    layers.add(MarkerLayer(markers: markers));
    return layers;
  }

  void _syncCamera(DriverSession s, BuildContext context) {
    final trip = s.trip;
    final offer = s.offer;
    final key = trip != null
        ? '${trip.id}:${trip.status.name}:${trip.approachRoute != null}'
        : offer != null
            ? 'offer:${offer.id}'
            : 'idle:${s.lastCompleted?.id}';
    if (key == _cameraKey || !_mapReady) return;
    _cameraKey = key;

    final List<LatLng> points = switch (trip?.status) {
      TripStatus.driverEnRoute => [s.position, ...?trip!.approachRoute?.points, trip.pickup.point],
      TripStatus.driverArrived || TripStatus.inProgress => trip!.route.points,
      _ when offer != null => [s.position, ...offer.route.points],
      _ => [s.position],
    };
    final height = MediaQuery.sizeOf(context).height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      fitMapTo(
        _map,
        points,
        padding: EdgeInsets.fromLTRB(56, 140, 56, offer != null ? height * 0.62 : (height * 0.4).clamp(220, 380)),
      );
    });
  }
}

class _EarningsCard extends StatelessWidget {
  const _EarningsCard({required this.session});

  final DriverSession session;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TcSpace.x4, vertical: TcSpace.x3),
      decoration: BoxDecoration(
        color: c.surfaceInverse,
        borderRadius: TcRadius.card,
        boxShadow: TcElevation.mid(c.shadow),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hoy', style: context.type.caption.copyWith(color: c.textInverse.withValues(alpha: 0.7))),
                Text(
                  Fmt.money(session.earningsToday),
                  style: TcTypography.numeric(context.type.h2).copyWith(color: c.brand),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${session.tripsToday} viajes', style: context.type.label.copyWith(color: c.textInverse)),
              Row(
                children: [
                  Icon(Icons.star_rounded, size: TcSize.iconSm, color: c.brand),
                  const SizedBox(width: 2),
                  Text(session.profile.rating.toStringAsFixed(1), style: context.type.label.copyWith(color: c.textInverse)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
