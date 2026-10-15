import 'package:flutter/material.dart';
import 'package:tc_design_system/tc_design_system.dart';

/// Encabezado de panel: título grande y una línea de apoyo opcional.
class PanelHeader extends StatelessWidget {
  const PanelHeader({super.key, required this.title, this.subtitle, this.leading, this.trailing});

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[leading!, const SizedBox(height: TcSpace.x2)],
              Semantics(header: true, child: Text(title, style: context.type.h2)),
              if (subtitle != null) ...[
                const SizedBox(height: TcSpace.x1),
                Text(subtitle!, style: context.type.body.copyWith(color: context.colors.textSecondary)),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// Confirmación antes de cancelar. Devuelve `true` si la persona confirma.
Future<bool> confirmCancel(BuildContext context, {required String title, required String body}) =>
    showTcConfirm(context, title: title, body: body);
