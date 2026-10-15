# TcAvatar

Círculo con iniciales; el color sale del nombre para distinguir personas. En la demo no hay fotos.

Código: `packages/tc_design_system/lib/src/components/tc_avatar.dart`

## Cuándo usarlo
- Taxista y pasajero en tarjetas y listas.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `name` | `String` | — | Nombre completo; usa primera y última inicial. |
| `size` | `double` | 56 | 40 · 56 · 72 (`TcSize.avatar*`). |
| `ring` | `bool` | false | Aro amarillo: el taxista asignado. |

## Variantes y estados
5 tonos suaves con texto oscuro (contraste ≥ 7:1).

## Accesibilidad
- Se anuncia con el nombre (`Semantics(label: name, image: true)`).

## Ejemplo
```dart
TcAvatar(name: 'Alberto Sánchez', ring: true)
```
