import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../context.dart';
import '../tokens/typography.dart';

/// Anillo que se vacía hasta [deadline] y muestra los segundos restantes.
/// Se usa en la oferta de viaje del taxista.
class TcCountdownRing extends StatefulWidget {
  const TcCountdownRing({super.key, required this.deadline, required this.total, this.size = 72});

  final DateTime deadline;
  final Duration total;
  final double size;

  @override
  State<TcCountdownRing> createState() => _TcCountdownRingState();
}

class _TcCountdownRingState extends State<TcCountdownRing> with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker((_) => setState(() {}))..start();

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final left = widget.deadline.difference(DateTime.now());
    final fraction = (left.inMilliseconds / widget.total.inMilliseconds).clamp(0.0, 1.0);
    final seconds = (left.inMilliseconds / 1000).ceil().clamp(0, 999);
    final urgent = seconds <= 5;
    return Semantics(
      label: 'Quedan $seconds segundos',
      liveRegion: seconds % 5 == 0,
      child: SizedBox.square(
        dimension: widget.size,
        child: CustomPaint(
          painter: _RingPainter(
            fraction: fraction,
            track: c.border,
            fill: urgent ? c.danger : c.textPrimary,
          ),
          child: Center(
            child: Text(
              '$seconds',
              style: TcTypography.numeric(context.type.h3).copyWith(color: urgent ? c.danger : c.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.fraction, required this.track, required this.fill});

  final double fraction;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 6.0;
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect.deflate(stroke / 2), 0, math.pi * 2, false, paint..color = track);
    canvas.drawArc(rect.deflate(stroke / 2), -math.pi / 2, math.pi * 2 * fraction, false, paint..color = fill);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.fraction != fraction || old.fill != fill;
}
