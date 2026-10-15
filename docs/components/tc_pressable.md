# TcPressable

Envoltura que encoge su hijo a 0.97 mientras se presiona. No cambia el layout.

Código: `packages/tc_design_system/lib/src/components/tc_pressable.dart`

## Cuándo usarlo
- Dentro de cualquier elemento tocable hecho a medida (tarjetas, opciones). Ya lo usan TcButton, TcIconButton, TcQuickAction y TcOnlineSwitch.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `child` | `Widget` | — | Contenido. |
| `enabled` | `bool` | true | Sin efecto si es `false`. |
| `scale` | `double` | 0.97 | Escala al presionar. |

## Variantes y estados
Entra con `exit` (150 ms) y regresa con `enter`.

## Accesibilidad
- Con movimiento reducido la duración es 0.

## Ejemplo
```dart
TcPressable(child: miTarjeta)
```
