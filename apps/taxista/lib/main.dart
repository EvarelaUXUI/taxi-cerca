import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_design_system/tc_design_system.dart';
import 'package:tc_driver/tc_driver.dart';

/// App solo para taxistas. Hoy usa el backend simulado; para producción se
/// sobrescribe `tripRepositoryProvider` aquí, en el ProviderScope.
void main() => runApp(const ProviderScope(child: TaxistaApp()));

class TaxistaApp extends StatelessWidget {
  const TaxistaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi Cerca Conductor',
      debugShowCheckedModeBanner: false,
      theme: TcTheme.light(),
      darkTheme: TcTheme.dark(),
      home: const DriverHomeScreen(),
    );
  }
}
