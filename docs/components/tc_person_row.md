# TcPersonRow

Avatar + nombre + calificación + detalle, con algo a la derecha (precio, botón).

Código: `packages/tc_design_system/lib/src/components/tc_person_row.dart`

## Cuándo usarlo
- Taxista asignado (pasajero) y pasajero de la oferta o del viaje (taxista).

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `name` | `String` | — | Nombre. |
| `rating` | `double` | — | Calificación. |
| `trips` | `int?` | null | Viajes. |
| `detail` | `String?` | null | Línea extra: "12 años manejando en el pueblo". |
| `trailing` | `Widget?` | null | Elemento a la derecha. |
| `highlight` | `bool` | false | Avatar grande con aro amarillo. |

## Accesibilidad
- Nombre en `title`; cabe en una línea con `ellipsis`.

## Ejemplo
```dart
TcPersonRow(name: driver.name, rating: driver.rating, trips: driver.trips, highlight: true)
```
