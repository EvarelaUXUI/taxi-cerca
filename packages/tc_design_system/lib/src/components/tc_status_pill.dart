import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';

enum TcStatusTone { neutral, brand, success, danger, info }

/// Píldora de estado: "En camino", "Conectado", "Efectivo". Siempre lleva texto
/// (el color nunca es el único indicador). [pulse] agrega un punto que late.
class TcStatusPill extends StatelessWidget {
  const TcStatusPill({super.key, required this.label, this.tone = TcStatusTone.neutral, this.icon, this.pulse = false});

  final String label;
  final TcStatusTone tone;
  final IconData? icon;
  final bool pulse;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (Color bg, Color fg) = switch (tone) {
      TcStatusTone.neutral => (c.surfaceSunken, c.textPrimary),
      TcStatusTone.brand => (c.brand, c.onBrand),
      TcStatusTone.success => (c.successSoft, c.success),
      TcStatusTone.danger => (c.dangerSoft, c.danger),
      TcStatusTone.info => (c.infoSoft, c.info),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TcSpace.x3, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(TcRadius.pill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pulse) ...[_PulseDot(color: fg), const SizedBox(width: TcSpace.x2)],
          if (icon != null) ...[Icon(icon, size: TcSize.iconSm, color: fg), const SizedBox(width: 6)],
          Text(label, style: context.type.label.copyWith(color: fg)),
        ],
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot({required this.color});
  final Color color;

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (TcMotion.reduced(context)) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 10,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: 1 + _c.value * 1.4,
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color.withValues(alpha: (1 - _c.value) * 0.4)),
              ),
            ),
            Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color)),
          ],
        ),
      ),
    );
  }
}
