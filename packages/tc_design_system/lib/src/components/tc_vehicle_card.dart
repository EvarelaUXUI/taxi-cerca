import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';

/// Bloque de identificación del taxi: placas y número económico grandes,
/// que es lo que la gente busca con la vista en la calle.
class TcVehicleCard extends StatelessWidget {
  const TcVehicleCard({super.key, required this.model, required this.color, required this.plate, required this.ecoNumber});

  final String model;
  final String color;
  final String plate;
  final String ecoNumber;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: '$model $color, placas $plate, número económico $ecoNumber',
      excludeSemantics: true,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$model · $color', style: context.type.bodyS.copyWith(color: c.textSecondary)),
                const SizedBox(height: 2),
                Text(plate, style: context.type.h3.copyWith(letterSpacing: 1)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: TcSpace.x3, vertical: TcSpace.x2),
            decoration: BoxDecoration(
              color: c.brand,
              borderRadius: BorderRadius.circular(TcRadius.sm),
              border: Border.all(color: c.onBrand, width: 2),
            ),
            child: Column(
              children: [
                Text('ECO', style: context.type.caption.copyWith(color: c.onBrand, height: 1)),
                Text(ecoNumber, style: context.type.title.copyWith(color: c.onBrand, height: 1.1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
