import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';

/// Avatar con iniciales. En la demo no hay fotos reales; el color sale del
/// nombre para que cada persona se distinga.
class TcAvatar extends StatelessWidget {
  const TcAvatar({super.key, required this.name, this.size = TcSize.avatarMd, this.ring = false});

  final String name;
  final double size;

  /// Aro amarillo de marca (taxista asignado).
  final bool ring;

  static const _tones = [
    (Color(0xFFFFE27A), Color(0xFF3D2F00)),
    (Color(0xFFD6E4FF), Color(0xFF0B2A5B)),
    (Color(0xFFD4F0DF), Color(0xFF0D3B21)),
    (Color(0xFFFFDCD6), Color(0xFF4A120E)),
    (Color(0xFFE9E1FF), Color(0xFF2A1B5C)),
  ];

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _tones[name.codeUnits.fold<int>(0, (a, b) => a + b) % _tones.length];
    final avatar = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Text(
        initials,
        style: context.type.title.copyWith(color: fg, fontSize: size * 0.36, height: 1),
      ),
    );
    return Semantics(
      label: name,
      image: true,
      excludeSemantics: true,
      child: ring
          ? Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: context.colors.brand, width: 3)),
              child: avatar,
            )
          : avatar,
    );
  }
}
