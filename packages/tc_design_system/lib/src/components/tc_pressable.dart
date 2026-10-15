import 'package:flutter/material.dart';

import '../tokens/dimens.dart';

/// Envuelve un hijo tocable y lo encoge un poco (0.97) mientras se presiona.
/// No cambia el tamaño del layout, solo la escala visual.
class TcPressable extends StatefulWidget {
  const TcPressable({super.key, required this.child, this.enabled = true, this.scale = 0.97});

  final Widget child;
  final bool enabled;
  final double scale;

  @override
  State<TcPressable> createState() => _TcPressableState();
}

class _TcPressableState extends State<TcPressable> {
  bool _down = false;

  void _set(bool v) {
    if (widget.enabled && _down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: TcMotion.of(context, TcMotion.fast),
        curve: _down ? TcMotion.exit : TcMotion.enter,
        child: widget.child,
      ),
    );
  }
}
