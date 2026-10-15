import 'package:flutter/widgets.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_maps/tc_maps.dart';

import 'rider_controller.dart';

final _cursors = Expando<PolylineCursor>();

PolylineCursor _cursor(RouteInfo route) => _cursors[route] ??= PolylineCursor(route.points);

/// Capas del mapa del pasajero según el paso del viaje.
List<Widget> riderMapLayers(
  BuildContext context, {
  required RiderDraft draft,
  required Trip? trip,
  required List<NearbyTaxi> taxis,
}) {
  if (trip == null) {
    final route = draft.route;
    return [
      if (route != null) tcRoutePolylines(context, route.points),
      MarkerLayer(
        markers: [
          for (final t in taxis) tcTaxiMarker(t.position, heading: t.heading),
          if (route != null && draft.destination != null) ...[
            tcPickupMarker(draft.pickup.point),
            tcDestinationMarker(draft.destination!.point, label: draft.destination!.name),
          ] else
            tcUserMarker(draft.pickup.point),
        ],
      ),
    ];
  }

  final driverPos = trip.driverPosition;
  final layers = <Widget>[];
  switch (trip.status) {
    case TripStatus.searching || TripStatus.offered:
      layers.add(tcRoutePolylines(context, trip.route.points));
    case TripStatus.driverEnRoute:
      layers.add(tcRoutePolylines(context, trip.route.points, dashed: true));
      final approach = trip.approachRoute;
      if (approach != null) layers.add(tcRoutePolylines(context, _cursor(approach).remainingFrom(trip.progress)));
    case TripStatus.driverArrived:
      layers.add(tcRoutePolylines(context, trip.route.points, dashed: true));
    case TripStatus.inProgress:
      layers.add(tcRoutePolylines(context, _cursor(trip.route).remainingFrom(trip.progress)));
    case TripStatus.completed || TripStatus.cancelled:
      break;
  }

  final waiting = trip.status == TripStatus.searching || trip.status == TripStatus.offered;
  layers.add(
    MarkerLayer(
      markers: [
        if (waiting)
          for (final t in taxis) tcTaxiMarker(t.position, heading: t.heading),
        if (trip.status.index <= TripStatus.driverArrived.index) tcPickupMarker(trip.pickup.point),
        tcDestinationMarker(trip.destination.point, label: trip.destination.name),
        if (driverPos != null && trip.status.hasDriver)
          tcTaxiMarker(driverPos, highlight: true, label: 'Tu taxi', heading: _heading(trip)),
      ],
    ),
  );
  return layers;
}

double _heading(Trip trip) {
  final route = switch (trip.status) {
    TripStatus.driverEnRoute => trip.approachRoute,
    TripStatus.inProgress => trip.route,
    _ => null,
  };
  return route == null ? 0 : _cursor(route).at(trip.progress).heading;
}

/// Puntos que deben verse en cada paso.
List<LatLng> riderCameraPoints({required RiderDraft draft, required Trip? trip}) {
  if (trip == null) {
    return draft.route?.points ?? [draft.pickup.point];
  }
  return switch (trip.status) {
    TripStatus.driverEnRoute => [...?trip.approachRoute?.points, trip.pickup.point],
    TripStatus.driverArrived => [trip.pickup.point],
    _ => trip.route.points,
  };
}
