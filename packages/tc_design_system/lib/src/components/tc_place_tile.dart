import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';

/// Fila de lugar: ícono en círculo, nombre y dirección. Mínimo 64 de alto.
class TcPlaceTile extends StatelessWidget {
  const TcPlaceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: TcRadius.control,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: TcSpace.x2, horizontal: TcSpace.x1),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: c.surfaceSunken, shape: BoxShape.circle),
                  child: Icon(icon, size: 22, color: c.textPrimary),
                ),
                const SizedBox(width: TcSpace.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.type.title.copyWith(fontSize: 17)),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.type.bodyS.copyWith(color: c.textSecondary),
                      ),
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
