import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';

import '../rider_controller.dart';

/// Confirmar: ruta, tipo de taxi con precio estimado, pago y "Pedir taxi".
class ConfirmPanel extends ConsumerWidget {
  const ConfirmPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final draft = ref.watch(riderDraftProvider);
    final controller = ref.read(riderDraftProvider.notifier);
    final taxis = ref.watch(nearbyTaxisProvider).value ?? const [];
    final route = draft.route;
    final destination = draft.destination;
    // Puede pasar mientras el panel sale con la animación.
    if (destination == null) return const SizedBox.shrink();

    final nearest = taxis.isEmpty
        ? 600.0
        : taxis.map((t) => metersBetween(t.position, draft.pickup.point)).reduce((a, b) => a < b ? a : b);
    // Aproximación: 40 % más por calles y 25 km/h en el pueblo.
    final pickupEta = nearest * 1.4 / (25 / 3.6);
    final selected = controller.quoteFor(draft.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TcRouteSummary(
          pickupTitle: 'Mi ubicación',
          pickupSubtitle: draft.pickup.name,
          destinationTitle: destination.name,
          destinationSubtitle: route == null
              ? 'Calculando ruta…'
              : '${Fmt.distance(route.distanceMeters)} · ${Fmt.minutes(route.durationSeconds)} de viaje',
        ),
        const SizedBox(height: TcSpace.x4),
        if (route == null)
          const _LoadingOptions()
        else
          for (final type in VehicleType.values) ...[
            _VehicleOption(
              type: type,
              quote: controller.quoteFor(type)!,
              selected: draft.type == type,
              pickupEta: pickupEta * (type == VehicleType.grande ? 1.6 : 1),
              onTap: () => controller.selectType(type),
            ),
            const SizedBox(height: TcSpace.x2),
          ],
        const SizedBox(height: TcSpace.x1),
        Row(
          children: [
            Icon(Icons.payments_outlined, color: c.success),
            const SizedBox(width: TcSpace.x2),
            Text(PaymentMethod.cash.label, style: context.type.label),
            const SizedBox(width: TcSpace.x2),
            Expanded(
              child: Text(
                'Pagas al llegar · precio estimado',
                style: context.type.bodyS.copyWith(color: c.textSecondary),
              ),
            ),
          ],
        ),
        if (draft.error != null) ...[
          const SizedBox(height: TcSpace.x2),
          Text(draft.error!, style: context.type.bodyS.copyWith(color: c.danger)),
        ],
        const SizedBox(height: TcSpace.x4),
        TcButton(
          label: selected == null
              ? 'Pedir taxi'
              : 'Pedir ${draft.type.label} · ${Fmt.moneyRange(selected.min, selected.max)}',
          icon: Icons.local_taxi_rounded,
          loading: draft.requesting,
          onPressed: route == null ? null : controller.request,
        ),
      ],
    );
  }
}

class _VehicleOption extends StatelessWidget {
  const _VehicleOption({
    required this.type,
    required this.quote,
    required this.selected,
    required this.pickupEta,
    required this.onTap,
  });

  final VehicleType type;
  final FareQuote quote;
  final bool selected;
  final double pickupEta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      selected: selected,
      button: true,
      label: '${type.label}, ${type.description}, de ${Fmt.money(quote.min)} a ${Fmt.money(quote.max)}, llega en ${Fmt.minutes(pickupEta)}',
      excludeSemantics: true,
      child: TcPressable(
        child: AnimatedContainer(
          duration: TcMotion.of(context, TcMotion.fast),
          decoration: BoxDecoration(
            color: selected ? c.brandSoft : c.surface,
            borderRadius: TcRadius.control,
            border: Border.all(color: selected ? c.textPrimary : c.border, width: selected ? 2 : 1),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: TcRadius.control,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(TcSpace.x3),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(color: c.brand, borderRadius: BorderRadius.circular(TcRadius.md)),
                      child: Icon(
                        type == VehicleType.taxi ? Icons.local_taxi_rounded : Icons.airport_shuttle_rounded,
                        color: c.onBrand,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: TcSpace.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(type.label, style: context.type.title),
                              const SizedBox(width: TcSpace.x2),
                              Icon(Icons.person_rounded, size: TcSize.iconSm, color: c.textSecondary),
                              Text('${type.seats}', style: context.type.bodyS.copyWith(color: c.textSecondary)),
                            ],
                          ),
                          Text(
                            'Llega en ${Fmt.minutes(pickupEta)} · ${type.description}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.type.bodyS.copyWith(color: c.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: TcSpace.x2),
                    TcPrice(Fmt.moneyRange(quote.min, quote.max), size: TcPriceSize.medium),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingOptions extends StatelessWidget {
  const _LoadingOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 2; i++)
          Container(
            height: 78,
            margin: const EdgeInsets.only(bottom: TcSpace.x2),
            decoration: BoxDecoration(color: context.colors.surfaceSunken, borderRadius: TcRadius.control),
            child: i == 0
                ? Center(
                    child: Text('Calculando precio…', style: context.type.body.copyWith(color: context.colors.textSecondary)),
                  )
                : null,
          ),
      ],
    );
  }
}
