import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';

/// Calificación compacta: ★ 4.9 (opcional: "· 1,240 viajes").
class TcRating extends StatelessWidget {
  const TcRating({super.key, required this.value, this.trips, this.dense = false});

  final double value;
  final int? trips;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = (dense ? context.type.bodyS : context.type.body).copyWith(color: c.textSecondary);
    final text = value.toStringAsFixed((value * 100).round() % 10 == 0 ? 1 : 2);
    final tripsText = trips == null ? '' : ' · ${_thousands(trips!)} viajes';
    return Semantics(
      label: 'Calificación $text de 5$tripsText',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: dense ? TcSize.iconSm : 18, color: c.brandPressed),
          const SizedBox(width: 2),
          Text(text, style: style.copyWith(color: c.textPrimary, fontWeight: FontWeight.w600)),
          if (trips != null) Text(tripsText, style: style),
        ],
      ),
    );
  }

  static String _thousands(int n) => n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}
