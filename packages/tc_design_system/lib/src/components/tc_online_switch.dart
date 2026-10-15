import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';
import 'tc_pressable.dart';

/// Interruptor grande "Conectarme / Desconectarme" del taxista.
/// Es un botón de ancho completo porque es la decisión más importante de su día.
class TcOnlineSwitch extends StatelessWidget {
  const TcOnlineSwitch({super.key, required this.online, required this.onChanged});

  final bool online;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bg = online ? c.surfaceInverse : c.brand;
    final fg = online ? c.textInverse : c.onBrand;
    return Semantics(
      toggled: online,
      label: online ? 'Conectado. Toca para desconectarte' : 'Desconectado. Toca para conectarte',
      excludeSemantics: true,
      child: TcPressable(
        enabled: onChanged != null,
        child: AnimatedContainer(
          duration: TcMotion.of(context, TcMotion.base),
          curve: TcMotion.enter,
          height: TcSize.button + 8,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(TcRadius.pill)),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(TcRadius.pill),
              onTap: onChanged == null ? null : () => onChanged!(!online),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: TcSpace.x2),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: TcMotion.of(context, TcMotion.base),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: online ? c.brand : c.surfaceInverse,
                      ),
                      child: Icon(
                        Icons.power_settings_new_rounded,
                        color: online ? c.onBrand : c.brand,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        online ? 'Desconectarme' : 'Conectarme',
                        textAlign: TextAlign.center,
                        style: context.type.button.copyWith(color: fg),
                      ),
                    ),
                    const SizedBox(width: 48),
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
