import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';
import 'package:tc_maps/tc_maps.dart';

import '../rider_controller.dart';

/// Inicio: "¿A dónde vas?" y accesos rápidos.
class HomePanel extends ConsumerWidget {
  const HomePanel({super.key});

  static const _shortcuts = ['mercado', 'centro', 'hospital'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final town = ref.watch(townConfigProvider);
    final rider = ref.watch(riderProfileProvider);
    final draft = ref.watch(riderDraftProvider);
    final taxis = ref.watch(nearbyTaxisProvider).value ?? const [];
    final controller = ref.read(riderDraftProvider.notifier);

    final nearest = taxis.isEmpty
        ? null
        : taxis.map((t) => metersBetween(t.position, draft.pickup.point)).reduce((a, b) => a < b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Hola, ${rider.firstName}', style: context.type.body.copyWith(color: c.textSecondary)),
            ),
            TcStatusPill(
              label: taxis.isEmpty
                  ? 'Buscando taxis…'
                  : '${taxis.length} taxis · ${Fmt.minutes(nearest! * 1.4 / (25 / 3.6))}',
              tone: TcStatusTone.success,
              pulse: taxis.isNotEmpty,
            ),
          ],
        ),
        const SizedBox(height: TcSpace.x1),
        Semantics(header: true, child: Text('¿A dónde vas?', style: context.type.h1)),
        const SizedBox(height: TcSpace.x4),
        Semantics(
          button: true,
          label: 'Buscar destino en ${town.name}',
          excludeSemantics: true,
          child: TcPressable(
            child: Material(
              color: c.surfaceSunken,
              borderRadius: TcRadius.control,
              child: InkWell(
                borderRadius: TcRadius.control,
                onTap: controller.openSearch,
                child: Container(
                  height: TcSize.button,
                  padding: const EdgeInsets.symmetric(horizontal: TcSpace.x4),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: c.textPrimary),
                      const SizedBox(width: TcSpace.x3),
                      Expanded(
                        child: Text(
                          'Busca un lugar',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.type.bodyL.copyWith(color: c.textSecondary),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: TcSpace.x3, vertical: 6),
                        decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(TcRadius.pill)),
                        child: Row(
                          children: [
                            Icon(Icons.schedule_rounded, size: TcSize.iconSm, color: c.textPrimary),
                            const SizedBox(width: 4),
                            Text('Ahora', style: context.type.label),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: TcSpace.x3),
        for (final id in _shortcuts)
          Builder(builder: (context) {
            final place = town.placeById(id);
            return TcPlaceTile(
              icon: placeIcon(place.kind),
              title: place.name,
              subtitle: place.address,
              trailing: Text(
                Fmt.distance(metersBetween(draft.pickup.point, place.point)),
                style: context.type.bodyS.copyWith(color: c.textSecondary),
              ),
              onTap: () => controller.chooseDestination(place),
            );
          }),
      ],
    );
  }
}
