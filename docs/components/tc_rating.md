# TcRating

Calificación compacta: ★ 4.9 · 1,240 viajes.

Código: `packages/tc_design_system/lib/src/components/tc_rating.dart`

## Cuándo usarlo
- Junto al nombre de taxista o pasajero.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `value` | `double` | — | 1–5. Muestra 1 decimal, o 2 si el segundo no es 0 (4.95). |
| `trips` | `int?` | null | Número de viajes con separador de miles. |
| `dense` | `bool` | false | Versión de 14 px. |

## Variantes y estados
Estrella en `brandPressed`, número en `textPrimary` 600.

## Accesibilidad
- Se anuncia como "Calificación 4.9 de 5 · 1,240 viajes".

## Ejemplo
```dart
TcRating(value: 4.9, trips: 1240, dense: true)
```
