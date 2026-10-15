import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';

/// Ondas que salen de un centro: "buscando taxi" / "buscando viajes".
/// Con movimiento reducido se queda fijo.
class TcRadar extends StatefulWidget {
  const TcRadar({super.key, this.size = 160, this.icon = Icons.local_taxi_rounded});

  final double size;
  final IconData icon;

  @override
  State<TcRadar> createState() => _TcRadarState();
}

class _TcRadarState extends State<TcRadar> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (TcMotion.reduced(context)) {
      _c.value = 0.35;
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
    final c = context.colors;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => Stack(
            alignment: Alignment.center,
            children: [
              for (var i = 0; i < 3; i++)
                Builder(builder: (context) {
                  final t = (_c.value + i / 3) % 1;
                  return Container(
                    width: widget.size * (0.3 + t * 0.7),
                    height: widget.size * (0.3 + t * 0.7),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.brand.withValues(alpha: (1 - t) * 0.35),
                    ),
                  );
                }),
              Container(
                width: widget.size * 0.34,
                height: widget.size * 0.34,
                decoration: BoxDecoration(color: c.brand, shape: BoxShape.circle, boxShadow: TcElevation.mid(c.shadow)),
                child: Icon(widget.icon, color: c.onBrand, size: widget.size * 0.17),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
