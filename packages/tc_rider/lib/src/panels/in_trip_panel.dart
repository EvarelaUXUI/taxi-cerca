import 'package:flutter/material.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';

import 'common.dart';

/// A bordo: hora de llegada, avance y seguridad.
class InTripPanel extends StatelessWidget {
  const InTripPanel({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final driver = trip.driver!;
    final eta = trip.etaSeconds ?? trip.route.durationSeconds;
    final remaining = trip.route.distanceMeters * (1 - trip.progress);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PanelHeader(
          leading: TcStatusPill(
            label: trip.atDestination ? 'Llegando' : 'En viaje',
            tone: TcStatusTone.brand,
            icon: Icons.route_rounded,
          ),
          title: trip.atDestination ? 'Ya llegaste' : 'Llegas a las ${Fmt.clockIn(eta)}',
          subtitle: trip.atDestination
              ? 'Paga ${Fmt.money(trip.quote.estimate)} en efectivo a ${driver.firstName}'
              : '${Fmt.minutes(eta)} · ${Fmt.distance(remaining)} a ${trip.destination.name}',
        ),
        const SizedBox(height: TcSpace.x4),
        Semantics(
          label: 'Avance del viaje ${(trip.progress * 100).round()} por ciento',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(TcRadius.pill),
            child: LinearProgressIndicator(
              value: trip.progress,
              minHeight: 8,
              backgroundColor: c.surfaceSunken,
              color: c.brand,
            ),
          ),
        ),
        const SizedBox(height: TcSpace.x4),
        TcPersonRow(
          name: driver.name,
          rating: driver.rating,
          detail: '${driver.vehicle.ecoNumber} · ${driver.vehicle.plate}',
          trailing: TcPrice(Fmt.money(trip.quote.estimate), size: TcPriceSize.medium, caption: trip.payment.label),
        ),
        const SizedBox(height: TcSpace.x4),
        Row(
          children: [
            TcQuickAction(
              icon: Icons.ios_share_rounded,
              label: 'Compartir viaje',
              onPressed: () => showTcToast(context, 'Tu familia puede seguir el viaje (simulado)', icon: Icons.ios_share_rounded),
            ),
            const SizedBox(width: TcSpace.x2),
            TcQuickAction(
              icon: Icons.sos_rounded,
              label: 'Emergencia',
              danger: true,
              onPressed: () => showTcToast(context, 'En la app real esto llama al 911 y avisa a tus contactos', icon: Icons.sos_rounded),
            ),
          ],
        ),
      ],
    );
  }
}
