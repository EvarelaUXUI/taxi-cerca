# TcPlaceTile

Fila de lugar con ícono en círculo, nombre y dirección. Mínimo 64 de alto.

Código: `packages/tc_design_system/lib/src/components/tc_place_tile.dart`

## Cuándo usarlo
- Accesos rápidos y resultados de búsqueda.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `icon` | `IconData` | — | Usa `placeIcon(kind)` de `tc_maps`. |
| `title` | `String` | — | Nombre del lugar. |
| `subtitle` | `String` | — | Dirección. |
| `onTap` | `VoidCallback?` | null | Elegir. |
| `trailing` | `Widget?` | null | Normalmente la distancia. |

## Variantes y estados
Ripple con radio `md`.

## Accesibilidad
- Título y dirección en una línea con `ellipsis`.

## Ejemplo
```dart
TcPlaceTile(icon: placeIcon(place.kind), title: place.name, subtitle: place.address, onTap: ...)
```
