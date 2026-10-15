# TcRadar

Ondas amarillas que salen de un taxi: "buscando".

Código: `packages/tc_design_system/lib/src/components/tc_radar.dart`

## Cuándo usarlo
- Pasajero buscando taxi; taxista buscando viajes.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `size` | `double` | 160 | Diámetro. |
| `icon` | `IconData` | local_taxi | Ícono del centro. |

## Variantes y estados
3 ondas desfasadas, ciclo de 2.4 s.

## Accesibilidad
- Decorativo: `ExcludeSemantics`. El texto de al lado dice qué pasa. Quieto con movimiento reducido.

## Ejemplo
```dart
const TcRadar(size: 140)
```
