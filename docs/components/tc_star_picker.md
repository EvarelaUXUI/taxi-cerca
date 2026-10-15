# TcStarPicker

Selector de 1 a 5 estrellas con área táctil de 52 cada una.

Código: `packages/tc_design_system/lib/src/components/tc_star_picker.dart`

## Cuándo usarlo
- Calificar al taxista o al pasajero al terminar.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `value` | `int` | — | 0 = sin calificar. |
| `onChanged` | `ValueChanged<int>` | — | Nueva calificación. |
| `size` | `double` | 44 | Tamaño del ícono. |

## Variantes y estados
Las estrellas elegidas se agrandan a 1.08 con rebote. `TcStarPicker.labels` da el texto ("Muy mal" … "¡Excelente!").

## Accesibilidad
- Cada estrella se anuncia: "4 estrellas, Bien", con estado seleccionado.

## Ejemplo
```dart
TcStarPicker(value: stars, onChanged: (v) => setState(() => stars = v))
```
