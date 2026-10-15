import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';

import 'phone_surface.dart';

/// En celular: elegir con qué rol entrar a la demo.
class RolePicker extends ConsumerWidget {
  const RolePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final town = ref.watch(townConfigProvider);
    return Scaffold(
      backgroundColor: c.brand,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TcSpace.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: c.onBrand, borderRadius: BorderRadius.circular(TcRadius.lg)),
                child: Icon(Icons.local_taxi_rounded, color: c.brand, size: 40),
              ),
              const SizedBox(height: TcSpace.x5),
              Text('Taxi Cerca', style: context.type.display.copyWith(color: c.onBrand)),
              const SizedBox(height: TcSpace.x2),
              Text(
                'Taxis de ${town.name}, a un toque. Elige cómo quieres probar la demo.',
                style: context.type.bodyL.copyWith(color: c.onBrand),
              ),
              const Spacer(),
              for (final role in DemoRole.values) ...[
                _RoleCard(role: role),
                const SizedBox(height: TcSpace.x3),
              ],
              Text(
                'Tip: abre la demo en una computadora para ver a los dos lado a lado.',
                style: context.type.bodyS.copyWith(color: c.onBrand),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.role});
  final DemoRole role;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final detail = role == DemoRole.rider ? 'Pide un taxi y síguelo en el mapa' : 'Recibe viajes, acéptalos y cobra';
    return TcPressable(
      child: Material(
        color: c.surface,
        borderRadius: TcRadius.card,
        child: InkWell(
          borderRadius: TcRadius.card,
          onTap: () => context.go(role.path),
          child: Padding(
            padding: const EdgeInsets.all(TcSpace.x4),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: c.brandSoft, borderRadius: BorderRadius.circular(TcRadius.md)),
                  child: Icon(role.icon, size: 30, color: c.textPrimary),
                ),
                const SizedBox(width: TcSpace.x4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Soy ${role.label.toLowerCase()}', style: context.type.h3),
                      Text(detail, style: context.type.bodyS.copyWith(color: c.textSecondary)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: c.textPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
