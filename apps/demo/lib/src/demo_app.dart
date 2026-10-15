import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tc_design_system/tc_design_system.dart';
import 'package:tc_driver/tc_driver.dart';
import 'package:tc_rider/tc_rider.dart';

import 'dual_view.dart';
import 'phone_surface.dart';
import 'role_picker.dart';

/// Tema elegido en la demo (claro, oscuro o el del sistema).
final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  void toggle() => state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
}

/// Ancho a partir del cual se muestran los dos celulares lado a lado.
const dualViewMinWidth = 900.0;

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LayoutBuilder(
        builder: (context, box) => box.maxWidth >= dualViewMinWidth ? const DualView() : const RolePicker(),
      ),
    ),
    GoRoute(
      path: '/pasajero',
      builder: (context, state) => const PhoneSurface(role: DemoRole.rider, child: RiderHomeScreen()),
    ),
    GoRoute(
      path: '/taxista',
      builder: (context, state) => const PhoneSurface(role: DemoRole.driver, child: DriverHomeScreen()),
    ),
  ],
);

class DemoApp extends ConsumerWidget {
  const DemoApp({super.key, this.useGoogleFonts = true});

  final bool useGoogleFonts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Taxi Cerca · Demo',
      debugShowCheckedModeBanner: false,
      theme: TcTheme.light(useGoogleFonts: useGoogleFonts),
      darkTheme: TcTheme.dark(useGoogleFonts: useGoogleFonts),
      themeMode: ref.watch(themeModeProvider),
      routerConfig: _router,
    );
  }
}
