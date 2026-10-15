import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';

/// Panel inferior sobre el mapa (el patrón de las apps de viaje).
///
/// Cambia de contenido con un fundido y ajusta su alto con animación. [stateKey]
/// identifica el paso del flujo: al cambiar, el contenido se reemplaza.
class TcBottomPanel extends StatelessWidget {
  const TcBottomPanel({super.key, required this.child, required this.stateKey, this.padding});

  final Widget child;
  final Object stateKey;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: TcRadius.sheet,
        boxShadow: TcElevation.high(c.shadow),
      ),
      child: SafeArea(
        top: false,
        child: AnimatedSize(
          duration: TcMotion.of(context, TcMotion.base),
          curve: TcMotion.enter,
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: (padding ?? const EdgeInsets.fromLTRB(TcSpace.gutter, TcSpace.x2, TcSpace.gutter, TcSpace.x4))
                .copyWith(bottom: bottomInset > 0 ? TcSpace.x2 : TcSpace.x5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: TcSpace.x4),
                  decoration: BoxDecoration(color: c.borderStrong, borderRadius: BorderRadius.circular(2)),
                ),
                AnimatedSwitcher(
                  duration: TcMotion.of(context, TcMotion.base),
                  reverseDuration: TcMotion.of(context, TcMotion.fast),
                  switchInCurve: TcMotion.enter,
                  switchOutCurve: TcMotion.exit,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(anim),
                      child: child,
                    ),
                  ),
                  layoutBuilder: (current, previous) => Stack(
                    alignment: Alignment.bottomCenter,
                    children: [...previous, ?current],
                  ),
                  child: KeyedSubtree(key: ValueKey(stateKey), child: child),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
