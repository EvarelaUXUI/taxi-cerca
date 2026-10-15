import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';

/// Taxista con sesión. En la demo es fijo; con login real se sobrescribe.
final driverProfileProvider = Provider<DriverProfile>((ref) => DemoProfiles.driver);

/// Sesión del taxista en vivo: conexión, oferta, viaje y ganancias.
final driverSessionProvider = StreamProvider<DriverSession>((ref) {
  final driver = ref.watch(driverProfileProvider);
  return ref.watch(tripRepositoryProvider).watchDriver(driver.id);
});
