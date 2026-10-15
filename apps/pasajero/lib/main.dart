import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_design_system/tc_design_system.dart';
import 'package:tc_rider/tc_rider.dart';

/// App solo para pasajeros. Hoy usa el backend simulado; para producción se
/// sobrescribe `tripRepositoryProvider` aquí, en el ProviderScope.
void main() => runApp(const ProviderScope(child: PasajeroApp()));

class PasajeroApp extends StatelessWidget {
  const PasajeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi Cerca',
      debugShowCheckedModeBanner: false,
      theme: TcTheme.light(),
      darkTheme: TcTheme.dark(),
      home: const RiderHomeScreen(),
    );
  }
}
