import 'package:flutter/material.dart';

import '../context.dart';
import '../tokens/dimens.dart';
import 'tc_button.dart';

/// Pide confirmación antes de una acción destructiva. Devuelve `true` si se confirma.
/// Usa el `Navigator` más cercano para que, en la demo de dos celulares, el
/// diálogo salga solo en el celular que lo pidió.
Future<bool> showTcConfirm(
  BuildContext context, {
  required String title,
  required String body,
  String confirmLabel = 'Sí, cancelar',
  String cancelLabel = 'No, seguir',
}) async {
  final result = await showDialog<bool>(
    context: context,
    useRootNavigator: false,
    builder: (context) => AlertDialog(
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: TcRadius.card),
      title: Text(title, style: context.type.h3),
      content: Text(body, style: context.type.body.copyWith(color: context.colors.textSecondary)),
      actionsPadding: const EdgeInsets.fromLTRB(TcSpace.x4, 0, TcSpace.x4, TcSpace.x4),
      actions: [
        Row(
          children: [
            Expanded(
              child: TcButton(
                label: cancelLabel,
                variant: TcButtonVariant.outline,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ),
            const SizedBox(width: TcSpace.x3),
            Expanded(
              child: TcButton(
                label: confirmLabel,
                variant: TcButtonVariant.danger,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  return result ?? false;
}
