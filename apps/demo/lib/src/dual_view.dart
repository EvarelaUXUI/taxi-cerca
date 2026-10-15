import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';
import 'package:tc_driver/tc_driver.dart';
import 'package:tc_rider/tc_rider.dart';

import 'demo_app.dart';
import 'phone_surface.dart';

/// En pantalla ancha: los dos celulares lado a lado con el mismo backend.
class DualView extends ConsumerWidget {
  const DualView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final town = ref.watch(townConfigProvider);
    const bg = TcPalette.asphalt950;
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(TcSpace.x8, TcSpace.x5, TcSpace.x8, TcSpace.x5),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: TcPalette.yellow500, borderRadius: BorderRadius.circular(TcRadius.md)),
                    child: const Icon(Icons.local_taxi_rounded, color: TcPalette.asphalt900),
                  ),
                  const SizedBox(width: TcSpace.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Taxi Cerca · Demo', style: context.type.h3.copyWith(color: TcPalette.white)),
                        Text(
                          '${town.name}, ${town.state}. Pide un taxi a la izquierda: la solicitud le llega al taxista de la derecha.',
                          style: context.type.bodyS.copyWith(color: TcPalette.asphalt300),
                        ),
                      ],
                    ),
                  ),
                  _HeaderButton(
                    icon: Theme.of(context).brightness == Brightness.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    label: Theme.of(context).brightness == Brightness.dark ? 'Modo claro' : 'Modo oscuro',
                    onTap: ref.read(themeModeProvider.notifier).toggle,
                  ),
                ],
              ),
              const SizedBox(height: TcSpace.x5),
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: _Phone(role: DemoRole.rider, child: RiderHomeScreen())),
                    SizedBox(width: TcSpace.x12),
                    Flexible(child: _Phone(role: DemoRole.driver, child: DriverHomeScreen())),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: TcPalette.yellow500),
      label: Text(label, style: context.type.label.copyWith(color: TcPalette.white)),
      style: TextButton.styleFrom(minimumSize: const Size(TcSize.touch, TcSize.touch)),
    );
  }
}

/// Marco de celular de 390×844 que se escala para caber en el alto disponible.
class _Phone extends StatelessWidget {
  const _Phone({required this.role, required this.child});

  final DemoRole role;
  final Widget child;

  static const _size = Size(390, 844);
  static const _bezel = 12.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(role.icon, color: TcPalette.yellow500, size: 20),
            const SizedBox(width: TcSpace.x2),
            Text(role.label, style: context.type.title.copyWith(color: TcPalette.white)),
          ],
        ),
        const SizedBox(height: TcSpace.x3),
        Expanded(
          child: FittedBox(
            child: Container(
              width: _size.width + _bezel * 2,
              height: _size.height + _bezel * 2,
              padding: const EdgeInsets.all(_bezel),
              decoration: BoxDecoration(
                color: TcPalette.asphalt800,
                borderRadius: BorderRadius.circular(56),
                border: Border.all(color: TcPalette.asphalt600, width: 2),
                boxShadow: const [BoxShadow(color: Color(0x80000000), blurRadius: 60, offset: Offset(0, 30))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(44),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    size: _size,
                    padding: const EdgeInsets.only(top: 47, bottom: 34),
                    viewPadding: const EdgeInsets.only(top: 47, bottom: 34),
                    viewInsets: EdgeInsets.zero,
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(child: PhoneSurface(role: role, showRoleSwitch: false, child: child)),
                      const Positioned(top: 0, left: 0, right: 0, child: _StatusBar()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    final color = context.colors.textPrimary;
    final style = context.type.label.copyWith(color: color, fontWeight: FontWeight.w700);
    return IgnorePointer(
      child: SizedBox(
        height: 47,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              Text('9:41', style: style),
              const Spacer(),
              Container(
                width: 120,
                height: 32,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
              ),
              const Spacer(),
              Icon(Icons.signal_cellular_alt_rounded, size: 16, color: color),
              const SizedBox(width: 4),
              Icon(Icons.wifi_rounded, size: 16, color: color),
              const SizedBox(width: 4),
              Icon(Icons.battery_full_rounded, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
