import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';

/// Viaje aceptado: ir por el pasajero, esperarlo y llevarlo.
class DriverTripPanel extends ConsumerWidget {
  const DriverTripPanel({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final repo = ref.read(tripRepositoryProvider);
    final rider = trip.rider;
    final eta = trip.etaSeconds;

    final (String pill, TcStatusTone tone, String title, String subtitle) = switch (trip.status) {
      TripStatus.driverEnRoute => (
          'Vas por ${rider.firstName}',
          TcStatusTone.brand,
          eta == null ? 'Calculando ruta…' : 'Llegas en ${Fmt.minutes(eta)}',
          'Recoger en ${trip.pickup.name}',
        ),
      TripStatus.driverArrived => (
          'En el punto de recogida',
          TcStatusTone.success,
          'Esperando a ${rider.firstName}',
          'Cuando suba, inicia el viaje.',
        ),
      _ => (
          trip.atDestination ? 'Llegaste al destino' : 'En viaje',
          trip.atDestination ? TcStatusTone.success : TcStatusTone.brand,
          trip.atDestination ? 'Cobra ${Fmt.money(trip.quote.estimate)}' : 'Llevando a ${rider.firstName}',
          trip.atDestination
              ? 'En efectivo, en ${trip.destination.name}.'
              : '${trip.destination.name} · ${Fmt.minutes(eta ?? 0)}',
        ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TcStatusPill(label: pill, tone: tone, pulse: trip.status == TripStatus.driverEnRoute),
        const SizedBox(height: TcSpace.x2),
        Semantics(header: true, liveRegion: true, child: Text(title, style: context.type.h2)),
        Text(subtitle, style: context.type.body.copyWith(color: c.textSecondary)),
        if (trip.status == TripStatus.inProgress) ...[
          const SizedBox(height: TcSpace.x3),
          ClipRRect(
            borderRadius: BorderRadius.circular(TcRadius.pill),
            child: LinearProgressIndicator(value: trip.progress, minHeight: 8, backgroundColor: c.surfaceSunken, color: c.brand),
          ),
        ],
        const SizedBox(height: TcSpace.x4),
        TcPersonRow(
          name: rider.name,
          rating: rider.rating,
          trips: rider.trips,
          trailing: TcPrice(Fmt.money(trip.quote.estimate), size: TcPriceSize.medium, caption: trip.payment.label),
        ),
        if (trip.status != TripStatus.inProgress) ...[
          const SizedBox(height: TcSpace.x3),
          Row(
            children: [
              TcQuickAction(
                icon: Icons.call_rounded,
                label: 'Llamar',
                onPressed: () => showTcToast(context, 'Llamando a ${rider.firstName}… (simulado)', icon: Icons.call_rounded),
              ),
              const SizedBox(width: TcSpace.x2),
              TcQuickAction(
                icon: Icons.navigation_rounded,
                label: 'Navegar',
                onPressed: () => showTcToast(context, 'En la app real abre Google Maps o Waze', icon: Icons.navigation_rounded),
              ),
            ],
          ),
        ],
        const SizedBox(height: TcSpace.x4),
        switch (trip.status) {
          TripStatus.driverEnRoute => TcButton(
              label: 'Ya llegué',
              icon: Icons.where_to_vote_rounded,
              onPressed: () => repo.markArrived(trip.id),
            ),
          TripStatus.driverArrived => TcButton(
              label: 'Iniciar viaje',
              icon: Icons.play_arrow_rounded,
              onPressed: () => repo.startTrip(trip.id),
            ),
          _ => TcButton(
              label: trip.atDestination ? 'Terminar viaje' : 'Terminar viaje antes',
              icon: Icons.flag_rounded,
              variant: trip.atDestination ? TcButtonVariant.primary : TcButtonVariant.outline,
              onPressed: () => repo.completeTrip(trip.id),
            ),
        },
        if (trip.status != TripStatus.inProgress)
          TcButton(
            label: 'Cancelar viaje',
            variant: TcButtonVariant.ghost,
            onPressed: () async {
              final ok = await showTcConfirm(
                context,
                title: '¿Soltar este viaje?',
                body: 'Le buscaremos otro taxi a ${rider.firstName}. Cancelar seguido baja tu calificación.',
              );
              if (ok) await repo.cancelTrip(trip.id, by: CancelledBy.driver);
            },
          ),
      ],
    );
  }
}
