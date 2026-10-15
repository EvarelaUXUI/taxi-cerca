import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';

import '../rider_controller.dart';
import 'common.dart';

/// Viaje terminado (calificar y propina) o cancelado.
class TripClosedPanel extends ConsumerStatefulWidget {
  const TripClosedPanel({super.key, required this.trip});

  final Trip trip;

  @override
  ConsumerState<TripClosedPanel> createState() => _TripClosedPanelState();
}

class _TripClosedPanelState extends ConsumerState<TripClosedPanel> {
  int _stars = 0;
  int _tip = 0;
  bool _sending = false;

  static const _tips = [0, 10, 20, 30];

  Future<void> _finish({bool rate = true}) async {
    setState(() => _sending = true);
    final repo = ref.read(tripRepositoryProvider);
    if (rate && _stars > 0) await repo.rateDriver(widget.trip.id, stars: _stars, tip: _tip);
    ref.read(riderDraftProvider.notifier).reset();
    await repo.dismissRiderTrip(ref.read(riderProfileProvider).id);
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final c = context.colors;

    if (trip.status == TripStatus.cancelled) {
      final byDriver = trip.cancelledBy != CancelledBy.rider;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelHeader(
            title: 'Viaje cancelado',
            subtitle: byDriver
                ? 'No encontramos taxi esta vez. Intenta de nuevo en un momento.'
                : 'Cancelaste tu viaje a ${trip.destination.name}. No se te cobró nada.',
          ),
          const SizedBox(height: TcSpace.x5),
          TcButton(label: 'Entendido', onPressed: () => _finish(rate: false)),
        ],
      );
    }

    final driver = trip.driver!;
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(color: c.successSoft, shape: BoxShape.circle),
          child: Icon(Icons.check_rounded, color: c.success, size: 36),
        ),
        const SizedBox(height: TcSpace.x3),
        Semantics(header: true, child: Text('¡Llegaste!', style: context.type.h2)),
        Text(trip.destination.name, style: context.type.body.copyWith(color: c.textSecondary)),
        const SizedBox(height: TcSpace.x4),
        TcPrice(Fmt.money((trip.finalFare ?? trip.quote.estimate) + _tip), size: TcPriceSize.hero, caption: 'Total en efectivo'),
        const SizedBox(height: TcSpace.x5),
        Text('¿Cómo te fue con ${driver.firstName}?', style: context.type.title),
        const SizedBox(height: TcSpace.x2),
        TcStarPicker(value: _stars, onChanged: (v) => setState(() => _stars = v)),
        AnimatedSize(
          duration: TcMotion.of(context, TcMotion.base),
          child: _stars == 0
              ? const SizedBox(width: double.infinity)
              : Column(
                  children: [
                    Text(TcStarPicker.labels[_stars - 1], style: context.type.label.copyWith(color: c.brandText)),
                    const SizedBox(height: TcSpace.x3),
                    Text('¿Le dejas propina?', style: context.type.bodyS.copyWith(color: c.textSecondary)),
                    const SizedBox(height: TcSpace.x2),
                    Wrap(
                      spacing: TcSpace.x2,
                      children: [
                        for (final t in _tips)
                          ChoiceChip(
                            label: Text(t == 0 ? 'Sin propina' : '+${Fmt.money(t)}'),
                            selected: _tip == t,
                            showCheckmark: false,
                            labelStyle: context.type.label.copyWith(color: _tip == t ? c.onBrand : c.textPrimary),
                            selectedColor: c.brand,
                            backgroundColor: c.surfaceSunken,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            onSelected: (_) => setState(() => _tip = t),
                          ),
                      ],
                    ),
                  ],
                ),
        ),
        const SizedBox(height: TcSpace.x5),
        TcButton(
          label: _stars == 0 ? 'Califica para terminar' : 'Enviar calificación',
          loading: _sending,
          onPressed: _stars == 0 ? null : _finish,
        ),
        TcButton(label: 'Ahora no', variant: TcButtonVariant.ghost, onPressed: _sending ? null : () => _finish(rate: false)),
      ],
    );
  }
}
