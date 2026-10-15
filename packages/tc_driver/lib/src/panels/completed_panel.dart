import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';

/// Resumen al terminar: cuánto cobrar y calificar al pasajero.
class DriverCompletedPanel extends ConsumerStatefulWidget {
  const DriverCompletedPanel({super.key, required this.trip});

  final Trip trip;

  @override
  ConsumerState<DriverCompletedPanel> createState() => _DriverCompletedPanelState();
}

class _DriverCompletedPanelState extends ConsumerState<DriverCompletedPanel> {
  int _stars = 0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final trip = widget.trip;
    final fare = trip.finalFare ?? trip.quote.estimate;
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(color: c.successSoft, shape: BoxShape.circle),
          child: Icon(Icons.payments_rounded, color: c.success, size: 32),
        ),
        const SizedBox(height: TcSpace.x3),
        Semantics(header: true, child: Text('Cobra en efectivo', style: context.type.h3)),
        TcPrice(Fmt.money(fare), size: TcPriceSize.hero),
        Text(
          '+${Fmt.money(fare)} a tus ganancias de hoy',
          style: context.type.label.copyWith(color: c.success),
        ),
        const SizedBox(height: TcSpace.x5),
        Text('¿Cómo fue ${trip.rider.firstName}?', style: context.type.title),
        const SizedBox(height: TcSpace.x2),
        TcStarPicker(value: _stars, onChanged: (v) => setState(() => _stars = v)),
        const SizedBox(height: TcSpace.x4),
        TcButton(
          label: _stars == 0 ? 'Califica para seguir' : 'Listo, buscar otro viaje',
          onPressed: _stars == 0 ? null : () => ref.read(tripRepositoryProvider).rateRider(trip.id, stars: _stars),
        ),
      ],
    );
  }
}
