import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';

/// Aviso breve (4 s) que no roba el foco. Para acciones simuladas de la demo
/// ("Llamando…") y confirmaciones.
void showTcToast(BuildContext context, String message, {IconData icon = Icons.info_outline_rounded}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.fromLTRB(TcSpace.x4, 0, TcSpace.x4, TcSpace.x4),
        content: Row(
          children: [
            Icon(icon, color: context.colors.brand, size: 20),
            const SizedBox(width: TcSpace.x3),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}
