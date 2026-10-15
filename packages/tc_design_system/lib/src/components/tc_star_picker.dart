import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';

/// Selector de 1 a 5 estrellas. Cada estrella mide 48×48 para tocarla fácil.
class TcStarPicker extends StatelessWidget {
  const TcStarPicker({super.key, required this.value, required this.onChanged, this.size = 44});

  final int value;
  final ValueChanged<int> onChanged;
  final double size;

  static const labels = ['Muy mal', 'Mal', 'Regular', 'Bien', '¡Excelente!'];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 1; i <= 5; i++)
          Semantics(
            button: true,
            selected: i <= value,
            label: '$i ${i == 1 ? 'estrella' : 'estrellas'}, ${labels[i - 1]}',
            excludeSemantics: true,
            child: InkResponse(
              onTap: () => onChanged(i),
              radius: size * 0.7,
              child: SizedBox.square(
                dimension: TcSize.touch + 4,
                child: AnimatedScale(
                  scale: i <= value ? 1.08 : 1,
                  duration: TcMotion.of(context, TcMotion.fast),
                  curve: TcMotion.emphasized,
                  child: Icon(
                    i <= value ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: size,
                    color: i <= value ? c.brand : c.borderStrong,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
