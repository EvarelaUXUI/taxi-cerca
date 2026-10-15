# TcQuickAction

Acción con ícono y texto debajo: Llamar, Mensaje, Compartir, Emergencia, Navegar.

Código: `packages/tc_design_system/lib/src/components/tc_quick_action.dart`

## Cuándo usarlo
- En fila (2–3) dentro de un `Row`; cada una se expande.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `icon` | `IconData` | — | Ícono de 22. |
| `label` | `String` | — | Texto siempre visible. |
| `onPressed` | `VoidCallback?` | — | Acción. |
| `danger` | `bool` | false | Rojo suave: Emergencia. |

## Variantes y estados
Alto mínimo 64, fondo `surfaceSunken` (o `dangerSoft`).

## Accesibilidad
- `Semantics(button, label)`.

## Ejemplo
```dart
Row(children: [TcQuickAction(icon: Icons.call_rounded, label: 'Llamar', onPressed: call)])
```
