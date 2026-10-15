# TcStatusPill

Píldora con el estado actual: "En camino", "Conectado", "Tu taxi llegó".

Código: `packages/tc_design_system/lib/src/components/tc_status_pill.dart`

## Cuándo usarlo
- Arriba del título de cada panel. Siempre con texto: el color nunca es el único indicador.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `label` | `String` | — | Texto corto. |
| `tone` | `TcStatusTone` | neutral | neutral · brand · success · danger · info |
| `icon` | `IconData?` | null | Ícono de 16. |
| `pulse` | `bool` | false | Punto que late: algo está pasando ahora. |

## Variantes y estados
| Tono | Fondo | Texto |
|---|---|---|
| neutral | `surfaceSunken` | `textPrimary` |
| brand | `brand` | `onBrand` |
| success | `successSoft` | `success` |
| danger | `dangerSoft` | `danger` |
| info | `infoSoft` | `info` |

## Accesibilidad
- El pulso se detiene con movimiento reducido.

## Ejemplo
```dart
TcStatusPill(label: 'En camino', tone: TcStatusTone.brand, pulse: true)
```
