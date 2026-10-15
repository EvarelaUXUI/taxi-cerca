import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';
import 'tc_avatar.dart';
import 'tc_rating.dart';

/// Avatar, nombre, calificación y un detalle. Para el taxista (lo ve el
/// pasajero) y el pasajero (lo ve el taxista).
class TcPersonRow extends StatelessWidget {
  const TcPersonRow({
    super.key,
    required this.name,
    required this.rating,
    this.trips,
    this.detail,
    this.trailing,
    this.highlight = false,
  });

  final String name;
  final double rating;
  final int? trips;
  final String? detail;
  final Widget? trailing;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TcAvatar(name: name, ring: highlight, size: highlight ? TcSize.avatarMd : TcSize.avatarSm + 4),
        const SizedBox(width: TcSpace.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.type.title),
              const SizedBox(height: 2),
              TcRating(value: rating, trips: trips, dense: true),
              if (detail != null)
                Text(detail!, style: context.type.bodyS.copyWith(color: context.colors.textSecondary)),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
