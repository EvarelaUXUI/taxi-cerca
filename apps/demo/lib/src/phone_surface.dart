import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tc_design_system/tc_design_system.dart';

enum DemoRole {
  rider('Pasajero', Icons.person_pin_circle_rounded, '/pasajero'),
  driver('Taxista', Icons.local_taxi_rounded, '/taxista');

  const DemoRole(this.label, this.icon, this.path);
  final String label;
  final IconData icon;
  final String path;

  DemoRole get other => this == rider ? driver : rider;
}

/// Aísla una pantalla como si fuera su propio celular: su propio Navigator
/// (diálogos) y ScaffoldMessenger (avisos), para que en la doble vista no se
/// mezclen. Con [showRoleSwitch] agrega el botón para cambiar de rol.
class PhoneSurface extends StatelessWidget {
  const PhoneSurface({super.key, required this.role, required this.child, this.showRoleSwitch = true});

  final DemoRole role;
  final Widget child;
  final bool showRoleSwitch;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (context) => Stack(
            children: [
              Positioned.fill(child: child),
              if (showRoleSwitch)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 76),
                      child: Center(child: _RoleSwitch(role: role)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleSwitch extends StatelessWidget {
  const _RoleSwitch({required this.role});
  final DemoRole role;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Tooltip(
      message: 'Cambiar a ${role.other.label}',
      child: Material(
        color: c.surfaceInverse.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(TcRadius.pill),
        child: InkWell(
          borderRadius: BorderRadius.circular(TcRadius.pill),
          onTap: () => context.go(role.other.path),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: TcSize.touch - 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TcSpace.x4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(role.icon, size: 18, color: c.brand),
                  const SizedBox(width: 6),
                  Text('Viendo: ${role.label}', style: context.type.label.copyWith(color: c.textInverse)),
                  const SizedBox(width: 6),
                  Icon(Icons.swap_horiz_rounded, size: 18, color: c.textInverse),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
