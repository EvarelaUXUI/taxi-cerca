# TcOnlineSwitch

Interruptor grande del taxista: Conectarme / Desconectarme. Ocupa todo el ancho porque es la decisión más importante de su día.

Código: `packages/tc_design_system/lib/src/components/tc_online_switch.dart`

## Cuándo usarlo
- Panel del taxista cuando no tiene viaje.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `online` | `bool` | — | Estado actual. |
| `onChanged` | `ValueChanged<bool>?` | — | `null` = deshabilitado. |

## Variantes y estados
Desconectado: amarillo con botón negro. Conectado: negro con botón amarillo. Transición de 250 ms. Alto 64.

## Accesibilidad
- `Semantics(toggled)` con texto que dice el estado y qué pasa al tocar.

## Ejemplo
```dart
TcOnlineSwitch(online: s.online, onChanged: (v) => repo.setOnline(id, online: v))
```
