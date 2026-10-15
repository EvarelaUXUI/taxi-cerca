import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';
import 'tc_pressable.dart';

/// Acción con ícono y texto debajo ("Llamar", "Mensaje", "Compartir").
/// El texto siempre se ve: los íconos solos se entienden menos.
class TcQuickAction extends StatelessWidget {
  const TcQuickAction({super.key, required this.icon, required this.label, required this.onPressed, this.danger = false});

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = danger ? c.danger : c.textPrimary;
    final bg = danger ? c.dangerSoft : c.surfaceSunken;
    return Expanded(
      child: TcPressable(
        child: Semantics(
          button: true,
          label: label,
          excludeSemantics: true,
          child: Material(
            color: bg,
            borderRadius: TcRadius.control,
            child: InkWell(
              onTap: onPressed,
              borderRadius: TcRadius.control,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 64),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: fg, size: 22),
                    const SizedBox(height: 4),
                    Text(label, style: context.type.label.copyWith(color: fg)),
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
