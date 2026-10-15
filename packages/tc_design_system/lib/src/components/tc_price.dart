import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/typography.dart';

enum TcPriceSize { hero, large, medium }

/// Monto en pesos con dígitos tabulares. Recibe el texto ya formateado
/// (`$85` o `$70–$85`) para no acoplar el sistema de diseño a la lógica de tarifas.
class TcPrice extends StatelessWidget {
  const TcPrice(this.text, {super.key, this.size = TcPriceSize.large, this.caption, this.color});

  final String text;
  final TcPriceSize size;

  /// Texto chico debajo, p. ej. "Efectivo" o "Precio estimado".
  final String? caption;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final t = context.type;
    final base = switch (size) {
      TcPriceSize.hero => t.display,
      TcPriceSize.large => t.h2,
      TcPriceSize.medium => t.title,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(text, style: TcTypography.numeric(base).copyWith(color: color ?? context.colors.textPrimary)),
        if (caption != null) Text(caption!, style: t.caption.copyWith(color: context.colors.textSecondary)),
      ],
    );
  }
}
