import 'package:flutter_test/flutter_test.dart';
import 'package:tc_core/tc_core.dart';

void main() {
  const calc = FareCalculator(FareRules(baseFare: 25, perKm: 7, perMinute: 1.5, minimumFare: 40));

  RouteInfo route(double km, double min) =>
      RouteInfo(points: const [LatLng(0, 0)], distanceMeters: km * 1000, durationSeconds: min * 60);

  group('FareCalculator', () {
    test('aplica banderazo, km y minuto y redondea a 5', () {
      // 25 + 7·5 + 1.5·10 = 75
      final q = calc.quote(route(5, 10), VehicleType.taxi);
      expect(q.estimate, 75);
      expect(q.min, 70); // 67.5 → 70
      expect(q.max, 85); // 82.5 → 85 (redondeo .5 hacia arriba)
    });

    test('nunca baja de la tarifa mínima', () {
      final q = calc.quote(route(0.3, 1), VehicleType.taxi);
      expect(q.estimate, 40);
      expect(q.min, 40);
    });

    test('Taxi Grande cuesta 30 % más', () {
      final normal = calc.quote(route(10, 20), VehicleType.taxi);
      final grande = calc.quote(route(10, 20), VehicleType.grande);
      expect(grande.estimate, greaterThan(normal.estimate));
      expect(grande.estimate % 5, 0);
    });
  });

  group('Fmt', () {
    test('dinero con separador de miles', () {
      expect(Fmt.money(1250), r'$1,250');
      expect(Fmt.money(75), r'$75');
      expect(Fmt.moneyRange(70, 85), r'$70–$85');
    });

    test('minutos nunca dicen 0', () {
      expect(Fmt.minutes(5), '1 min');
      expect(Fmt.minutes(600), '10 min');
      expect(Fmt.minutes(3900), '1 h 05 min');
    });

    test('distancia en metros o kilómetros', () {
      expect(Fmt.distance(320), '300 m');
      expect(Fmt.distance(2430), '2.4 km');
    });
  });

  group('PolylineCursor', () {
    test('ubica el punto medio y la ruta restante', () {
      final cursor = PolylineCursor(const [LatLng(19.0, -99.0), LatLng(19.01, -99.0)]);
      final mid = cursor.at(0.5).point;
      expect(mid.latitude, closeTo(19.005, 1e-6));
      expect(cursor.remainingFrom(0.5).length, 2);
      expect(cursor.at(1).point, const LatLng(19.01, -99.0));
    });
  });
}
