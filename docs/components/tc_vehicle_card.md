# TcVehicleCard

Identificación del taxi: modelo y color, **placas grandes** y **número económico** en una placa amarilla.

Código: `packages/tc_design_system/lib/src/components/tc_vehicle_card.dart`

## Cuándo usarlo
- En el panel del pasajero cuando ya hay taxista. Es lo que la gente busca con la vista en la calle.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `model` | `String` | — | "Nissan Versa". |
| `color` | `String` | — | "Blanco". |
| `plate` | `String` | — | Placas, en `h3` con tracking. |
| `ecoNumber` | `String` | — | Número económico: "IX-027". |

## Variantes y estados
La placa del número económico imita la pintura de la puerta: amarillo con borde negro.

## Accesibilidad
- Se anuncia completo: modelo, color, placas y número.

## Ejemplo
```dart
TcVehicleCard(model: 'Nissan Versa', color: 'Blanco', plate: 'MLB-234-B', ecoNumber: 'IX-027')
```
