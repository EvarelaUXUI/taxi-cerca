import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';

/// Origen → destino en dos renglones unidos por una línea, como en un boleto.
class TcRouteSummary extends StatelessWidget {
  const TcRouteSummary({
    super.key,
    required this.pickupTitle,
    required this.destinationTitle,
    this.pickupSubtitle,
    this.destinationSubtitle,
  });

  final String pickupTitle;
  final String? pickupSubtitle;
  final String destinationTitle;
  final String? destinationSubtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget row(Widget dot, String title, String? subtitle) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 24, height: 24, child: Center(child: dot)),
            const SizedBox(width: TcSpace.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.type.title.copyWith(fontSize: 17)),
                  if (subtitle != null)
                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.type.bodyS.copyWith(color: c.textSecondary)),
                ],
              ),
            ),
          ],
        );

    return Semantics(
      label: 'De $pickupTitle a $destinationTitle',
      child: Stack(
        children: [
          Positioned(
            left: 11,
            top: 20,
            bottom: 20,
            child: Container(width: 2, color: c.borderStrong),
          ),
          Column(
            children: [
              row(
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(color: c.mapPickup, shape: BoxShape.circle, border: Border.all(color: c.surface, width: 2)),
                ),
                pickupTitle,
                pickupSubtitle,
              ),
              const SizedBox(height: TcSpace.x3),
              row(
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(color: c.mapDestination, borderRadius: BorderRadius.circular(3)),
                ),
                destinationTitle,
                destinationSubtitle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
