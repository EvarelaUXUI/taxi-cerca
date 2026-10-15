import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';

import 'common.dart';

/// Buscando taxi (y "un taxista está viendo tu viaje").
class SearchingPanel extends ConsumerWidget {
  const SearchingPanel({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offered = trip.status == TripStatus.offered;
    return Column(
      children: [
        const TcRadar(size: 140),
        const SizedBox(height: TcSpace.x3),
        Semantics(
          liveRegion: true,
          child: Text(
            offered ? 'Un taxista está viendo tu viaje' : 'Buscando tu taxi…',
            textAlign: TextAlign.center,
            style: context.type.h2,
          ),
        ),
        const SizedBox(height: TcSpace.x1),
        Text(
          offered ? 'En unos segundos te confirma.' : 'Le avisamos a los taxis más cercanos.',
          textAlign: TextAlign.center,
          style: context.type.body.copyWith(color: context.colors.textSecondary),
        ),
        const SizedBox(height: TcSpace.x5),
        Row(
          children: [
            Expanded(
              child: TcRouteSummary(
                pickupTitle: trip.pickup.name,
                destinationTitle: trip.destination.name,
              ),
            ),
            TcPrice(Fmt.moneyRange(trip.quote.min, trip.quote.max), size: TcPriceSize.medium, caption: trip.payment.label),
          ],
        ),
        const SizedBox(height: TcSpace.x5),
        TcButton(
          label: 'Cancelar búsqueda',
          variant: TcButtonVariant.outline,
          onPressed: () async {
            final ok = await confirmCancel(
              context,
              title: '¿Cancelar la búsqueda?',
              body: 'Todavía no hay taxista asignado, así que no se cobra nada.',
            );
            if (ok) await ref.read(tripRepositoryProvider).cancelTrip(trip.id, by: CancelledBy.rider);
          },
        ),
      ],
    );
  }
}
