import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';
import 'tc_pressable.dart';

enum TcButtonVariant {
  /// Amarillo con texto negro. Una sola por pantalla: la acción principal.
  primary,

  /// Negro asfalto con texto blanco. Acción fuerte que no es la principal.
  secondary,

  /// Contorno. Acciones de apoyo.
  outline,

  /// Solo texto. Acciones terciarias ("Ahora no").
  ghost,

  /// Rojo. Cancelar viaje, emergencia.
  danger,
}

enum TcButtonSize { large, compact }

/// Botón de Taxi Cerca. Alto 56 (large) o 44 (compact, con área táctil de 48).
class TcButton extends StatelessWidget {
  const TcButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = TcButtonVariant.primary,
    this.size = TcButtonSize.large,
    this.icon,
    this.loading = false,
    this.expand = true,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final TcButtonVariant variant;
  final TcButtonSize size;
  final IconData? icon;
  final bool loading;
  final bool expand;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null && !loading;

    // Tokens de componente: fondo, texto y borde por variante.
    final (Color bg, Color fg, Color? border) = switch (variant) {
      TcButtonVariant.primary => (c.brand, c.onBrand, null),
      TcButtonVariant.secondary => (c.surfaceInverse, c.textInverse, null),
      TcButtonVariant.outline => (Colors.transparent, c.textPrimary, c.borderStrong),
      TcButtonVariant.ghost => (Colors.transparent, c.textPrimary, null),
      TcButtonVariant.danger => (c.danger, c.onStatus, null),
    };
    final height = size == TcButtonSize.large ? TcSize.button : TcSize.buttonCompact;
    final textStyle = size == TcButtonSize.large ? context.type.button : context.type.label;

    final content = loading
        ? SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: size == TcButtonSize.large ? 22 : 18, color: fg),
                const SizedBox(width: TcSpace.x2),
              ],
              Flexible(
                child: Text(label, overflow: TextOverflow.ellipsis, style: textStyle.copyWith(color: fg)),
              ),
            ],
          );

    final button = TcPressable(
      enabled: enabled,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: semanticLabel,
        child: Material(
          color: enabled ? bg : (bg == Colors.transparent ? bg : c.surfaceSunken),
          shape: RoundedRectangleBorder(
            borderRadius: size == TcButtonSize.large ? TcRadius.control : BorderRadius.circular(TcRadius.sm + 2),
            side: border == null ? BorderSide.none : BorderSide(color: border, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height, minWidth: TcSize.touch),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: TcSpace.x5),
                child: Center(
                  widthFactor: 1,
                  child: DefaultTextStyle.merge(
                    style: TextStyle(color: enabled ? fg : c.textTertiary),
                    child: IconTheme.merge(
                      data: IconThemeData(color: enabled ? fg : c.textTertiary),
                      child: AnimatedSwitcher(duration: TcMotion.of(context, TcMotion.fast), child: content),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final sized = size == TcButtonSize.compact
        ? ConstrainedBox(constraints: const BoxConstraints(minHeight: TcSize.touch), child: Center(widthFactor: 1, heightFactor: 1, child: button))
        : button;
    return expand ? SizedBox(width: double.infinity, child: sized) : sized;
  }
}
