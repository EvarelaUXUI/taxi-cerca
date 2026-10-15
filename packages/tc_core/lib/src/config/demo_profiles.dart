import '../models/profiles.dart';

/// Perfiles ficticios de la demo. Ningún dato corresponde a personas reales.
abstract final class DemoProfiles {
  static const rider = RiderProfile(
    id: 'rider-demo',
    name: 'Mariana López',
    rating: 4.8,
    trips: 36,
    phone: '712 000 0000',
  );

  static const driver = DriverProfile(
    id: 'driver-demo',
    name: 'Alberto Sánchez',
    rating: 4.9,
    trips: 1240,
    yearsDriving: 12,
    vehicle: Vehicle(
      model: 'Nissan Versa',
      color: 'Blanco',
      plate: 'MLB-234-B',
      ecoNumber: 'IX-027',
    ),
  );

  /// Taxistas simulados que atienden cuando el de la demo no está conectado.
  static const botDrivers = [
    DriverProfile(
      id: 'bot-1',
      name: 'Rosa Martínez',
      rating: 4.95,
      trips: 860,
      yearsDriving: 8,
      vehicle: Vehicle(model: 'Chevrolet Aveo', color: 'Blanco', plate: 'MLC-118-A', ecoNumber: 'IX-014'),
    ),
    DriverProfile(
      id: 'bot-2',
      name: 'Jorge Hernández',
      rating: 4.7,
      trips: 2310,
      yearsDriving: 20,
      vehicle: Vehicle(model: 'Nissan Tsuru', color: 'Blanco', plate: 'MLA-905-C', ecoNumber: 'IX-003'),
    ),
    DriverProfile(
      id: 'bot-3',
      name: 'Luis García',
      rating: 4.85,
      trips: 540,
      yearsDriving: 4,
      vehicle: Vehicle(model: 'Toyota Avanza', color: 'Gris', plate: 'MLD-442-A', ecoNumber: 'IX-041'),
    ),
    DriverProfile(
      id: 'bot-4',
      name: 'Carmen Reyes',
      rating: 4.9,
      trips: 1105,
      yearsDriving: 10,
      vehicle: Vehicle(model: 'Kia Rio', color: 'Blanco', plate: 'MLB-771-B', ecoNumber: 'IX-022'),
    ),
    DriverProfile(
      id: 'bot-5',
      name: 'Pedro Mendoza',
      rating: 4.6,
      trips: 3020,
      yearsDriving: 25,
      vehicle: Vehicle(model: 'Nissan Tsuru', color: 'Blanco', plate: 'MLA-310-A', ecoNumber: 'IX-009'),
    ),
  ];

  /// Pasajeros simulados para "Simular solicitud" en la vista del taxista.
  static const botRiders = [
    RiderProfile(id: 'rider-1', name: 'Guadalupe Flores', rating: 4.9, trips: 112),
    RiderProfile(id: 'rider-2', name: 'José Antonio Cruz', rating: 4.6, trips: 18),
    RiderProfile(id: 'rider-3', name: 'Daniela Ortiz', rating: 5.0, trips: 7),
    RiderProfile(id: 'rider-4', name: 'Raúl Jiménez', rating: 4.7, trips: 64),
  ];
}
