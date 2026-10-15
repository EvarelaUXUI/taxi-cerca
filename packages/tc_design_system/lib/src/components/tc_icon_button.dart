import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';
import 'tc_pressable.dart';

enum TcIconButtonVariant { surface, brand, inverse, danger }

/// Botón circular de solo ícono (48×48). [tooltip] es obligatorio: es lo que
/// lee el lector de pantalla.
class TcIconButton extends StatelessWidget {
  const TcIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.variant = TcIconButtonVariant.surface,
    this.size = TcSize.touch,
    this.elevated = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final TcIconButtonVariant variant;
  final double size;

  /// Con sombra, para flotar sobre el mapa.
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (Color bg, Color fg) = switch (variant) {
      TcIconButtonVariant.surface => (c.surface, c.textPrimary),
      TcIconButtonVariant.brand => (c.brand, c.onBrand),
      TcIconButtonVariant.inverse => (c.surfaceInverse, c.textInverse),
      TcIconButtonVariant.danger => (c.dangerSoft, c.danger),
    };
    return Tooltip(
      message: tooltip,
      child: TcPressable(
        enabled: onPressed != null,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: elevated ? TcElevation.mid(c.shadow) : null,
          ),
          child: Material(
            color: bg,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: Icon(icon, color: fg, size: size * 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
