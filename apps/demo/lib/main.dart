import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/demo_app.dart';

void main() {
  // Un solo ProviderScope: pasajero y taxista comparten el mismo "backend"
  // simulado, así lo que pide uno le llega al otro.
  runApp(const ProviderScope(child: DemoApp()));
}
