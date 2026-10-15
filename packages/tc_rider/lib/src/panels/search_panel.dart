import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';
import 'package:tc_maps/tc_maps.dart';

import '../rider_controller.dart';

/// Búsqueda de destino entre los lugares del pueblo.
class SearchPanel extends ConsumerStatefulWidget {
  const SearchPanel({super.key});

  @override
  ConsumerState<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends ConsumerState<SearchPanel> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  static String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp('[áä]'), 'a')
      .replaceAll(RegExp('[éë]'), 'e')
      .replaceAll(RegExp('[íï]'), 'i')
      .replaceAll(RegExp('[óö]'), 'o')
      .replaceAll(RegExp('[úü]'), 'u');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final town = ref.watch(townConfigProvider);
    final draft = ref.watch(riderDraftProvider);
    final controller = ref.read(riderDraftProvider.notifier);
    final q = _norm(_query.text.trim());
    final results = town.places
        .where((p) => q.isEmpty || _norm(p.name).contains(q) || _norm(p.address).contains(q))
        .toList()
      ..sort((a, b) => metersBetween(draft.pickup.point, a.point).compareTo(metersBetween(draft.pickup.point, b.point)));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TcRouteSummary(
          pickupTitle: 'Mi ubicación',
          pickupSubtitle: draft.pickup.name,
          destinationTitle: '¿A dónde vas?',
        ),
        const SizedBox(height: TcSpace.x4),
        TextField(
          controller: _query,
          autofocus: true,
          textInputAction: TextInputAction.search,
          style: context.type.bodyL,
          decoration: InputDecoration(
            hintText: 'Escribe un lugar o colonia',
            prefixIcon: Icon(Icons.search_rounded, color: c.textPrimary),
            suffixIcon: _query.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Borrar',
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => setState(_query.clear),
                  ),
          ),
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) {
            if (results.isNotEmpty) controller.chooseDestination(results.first);
          },
        ),
        const SizedBox(height: TcSpace.x2),
        Text('Lugares en ${town.name}', style: context.type.label.copyWith(color: c.textSecondary)),
        Flexible(
          child: results.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: TcSpace.x6),
                  child: Text(
                    'No encontramos "${_query.text}". Prueba con otro nombre, como "Mercado" o "Hospital".',
                    style: context.type.body.copyWith(color: c.textSecondary),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: results.length,
                  itemBuilder: (context, i) {
                    final place = results[i];
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
                  },
                ),
        ),
      ],
    );
  }
}
