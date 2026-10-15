import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';

/// Desconectado o conectado esperando viajes.
class DriverIdlePanel extends ConsumerWidget {
  const DriverIdlePanel({super.key, required this.session});

  final DriverSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final repo = ref.read(tripRepositoryProvider);
    final town = ref.watch(townConfigProvider);
    final id = session.profile.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TcStatusPill(
                    label: session.online ? 'Conectado' : 'Desconectado',
                    tone: session.online ? TcStatusTone.success : TcStatusTone.neutral,
                    pulse: session.online,
                  ),
                  const SizedBox(height: TcSpace.x2),
                  Semantics(
                    header: true,
                    liveRegion: true,
                    child: Text(session.online ? 'Buscando viajes…' : 'Hola, ${session.profile.firstName}', style: context.type.h2),
                  ),
                  const SizedBox(height: TcSpace.x1),
                  Text(
                    session.online
                        ? 'Te avisamos con sonido cuando alguien pida un taxi cerca.'
                        : 'Conéctate para recibir viajes en ${town.name}.',
                    style: context.type.body.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            if (session.online) const TcRadar(size: 88),
          ],
        ),
        const SizedBox(height: TcSpace.x5),
        TcOnlineSwitch(online: session.online, onChanged: (v) => repo.setOnline(id, online: v)),
        const SizedBox(height: TcSpace.x2),
        TcButton(
          label: 'Simular solicitud (demo)',
          icon: Icons.notifications_active_rounded,
          variant: TcButtonVariant.ghost,
          size: TcButtonSize.compact,
          onPressed: () => repo.simulateIncomingRequest(id),
        ),
      ],
    );
  }
}
