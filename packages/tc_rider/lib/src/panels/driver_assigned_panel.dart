import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';

import 'common.dart';

/// Taxi en camino y taxi en la puerta.
class DriverAssignedPanel extends ConsumerWidget {
  const DriverAssignedPanel({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final driver = trip.driver!;
    final arrived = trip.status == TripStatus.driverArrived;
    final eta = trip.etaSeconds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PanelHeader(
          leading: TcStatusPill(
            label: arrived ? 'Tu taxi llegó' : 'En camino',
            tone: arrived ? TcStatusTone.success : TcStatusTone.brand,
            icon: arrived ? Icons.check_circle_rounded : Icons.near_me_rounded,
            pulse: !arrived,
          ),
          title: arrived
              ? 'Sal a tu taxi'
              : eta == null
                  ? 'Calculando llegada…'
                  : 'Llega en ${Fmt.minutes(eta)}',
          subtitle: arrived
              ? 'Busca el ${driver.vehicle.ecoNumber} · ${driver.vehicle.model} ${driver.vehicle.color.toLowerCase()}'
              : 'Te recoge en ${trip.pickup.name}',
        ),
        const SizedBox(height: TcSpace.x4),
        Container(
          padding: const EdgeInsets.all(TcSpace.x4),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: TcRadius.card,
            border: Border.all(color: c.border),
          ),
          child: Column(
            children: [
              TcPersonRow(
                name: driver.name,
                rating: driver.rating,
                trips: driver.trips,
                detail: '${driver.yearsDriving} años manejando en el pueblo',
                highlight: true,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: TcSpace.x3), child: Divider()),
              TcVehicleCard(
                model: driver.vehicle.model,
                color: driver.vehicle.color,
                plate: driver.vehicle.plate,
                ecoNumber: driver.vehicle.ecoNumber,
              ),
            ],
          ),
        ),
        const SizedBox(height: TcSpace.x3),
        Row(
          children: [
            TcQuickAction(
              icon: Icons.call_rounded,
              label: 'Llamar',
              onPressed: () => showTcToast(context, 'Llamando a ${driver.firstName}… (simulado)', icon: Icons.call_rounded),
            ),
            const SizedBox(width: TcSpace.x2),
            TcQuickAction(
              icon: Icons.chat_bubble_rounded,
              label: 'Mensaje',
              onPressed: () => showTcToast(context, 'Mensajes disponibles en la versión completa', icon: Icons.chat_bubble_rounded),
            ),
            const SizedBox(width: TcSpace.x2),
            TcQuickAction(
              icon: Icons.ios_share_rounded,
              label: 'Compartir',
              onPressed: () => showTcToast(context, 'Enlace del viaje copiado (simulado)', icon: Icons.ios_share_rounded),
            ),
          ],
        ),
        const SizedBox(height: TcSpace.x2),
        TcButton(
          label: 'Cancelar viaje',
          variant: TcButtonVariant.ghost,
          onPressed: () async {
            final ok = await confirmCancel(
              context,
              title: '¿Cancelar el viaje?',
              body: '${driver.firstName} ya va en camino. En la demo no se cobra, pero en la app real podría haber cargo por cancelar tarde.',
            );
            if (ok) await ref.read(tripRepositoryProvider).cancelTrip(trip.id, by: CancelledBy.rider);
          },
        ),
      ],
    );
  }
}
