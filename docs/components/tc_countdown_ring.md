# TcCountdownRing

Anillo que se vacía hasta una hora límite y muestra los segundos que quedan.

Código: `packages/tc_design_system/lib/src/components/tc_countdown_ring.dart`

## Cuándo usarlo
- Oferta de viaje del taxista (15 s).

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `deadline` | `DateTime` | — | Cuándo vence. |
| `total` | `Duration` | — | Duración total (para la proporción). |
| `size` | `double` | 72 | Diámetro. |

## Variantes y estados
Se repinta en cada cuadro. En los últimos 5 s se vuelve `danger`.

## Accesibilidad
- Anuncia "Quedan N segundos" cada 5 s (`liveRegion`).

## Ejemplo
```dart
TcCountdownRing(deadline: offer.offerExpiresAt!, total: const Duration(seconds: 15))
```
