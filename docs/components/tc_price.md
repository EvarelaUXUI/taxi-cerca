# TcPrice

Monto con dígitos tabulares. Recibe el texto ya formateado (`Fmt.money` / `Fmt.moneyRange`).

Código: `packages/tc_design_system/lib/src/components/tc_price.dart`

## Cuándo usarlo
- Precio estimado, precio de la oferta, total a cobrar.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `text` | `String` | — | "\$85" o "\$70–\$85". |
| `size` | `TcPriceSize` | large | hero (40) · large (26) · medium (18) |
| `caption` | `String?` | null | Texto chico debajo: "Efectivo". |
| `color` | `Color?` | textPrimary | Color del monto. |

## Variantes y estados
Alineado a la derecha.

## Accesibilidad
- Los montos siempre llevan `\$` y separador de miles; la app solo maneja pesos.

## Ejemplo
```dart
TcPrice(Fmt.money(85), size: TcPriceSize.hero, caption: 'Total en efectivo')
```
