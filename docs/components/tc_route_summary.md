# TcRouteSummary

Origen → destino en dos renglones unidos por una línea, como un boleto.

Código: `packages/tc_design_system/lib/src/components/tc_route_summary.dart`

## Cuándo usarlo
- Buscar destino, confirmar, buscando y la oferta del taxista.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `pickupTitle` | `String` | — | Recogida. |
| `pickupSubtitle` | `String?` | null | Dirección o distancia. |
| `destinationTitle` | `String` | — | Destino. |
| `destinationSubtitle` | `String?` | null | Distancia y duración. |

## Variantes y estados
Punto verde (`mapPickup`) y cuadro negro (`mapDestination`), los mismos que en el mapa.

## Accesibilidad
- Se anuncia como "De X a Y".

## Ejemplo
```dart
TcRouteSummary(pickupTitle: 'Mi ubicación', destinationTitle: 'Hospital General', destinationSubtitle: '1.5 km · 3 min')
```
