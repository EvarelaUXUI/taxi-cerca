# TcButton

Botón de acción. Es el único componente para acciones con texto.

Código: `packages/tc_design_system/lib/src/components/tc_button.dart`

## Cuándo usarlo
- **Una sola `primary` por pantalla**: la acción que mueve el flujo (Pedir taxi, Aceptar viaje, Iniciar viaje).
- `secondary` para acciones fuertes que no son la principal; `outline` para la alternativa (Rechazar); `ghost` para salidas suaves (Ahora no, Cancelar viaje); `danger` solo para confirmar algo destructivo.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `label` | `String` | — | Texto del botón. Verbo + objeto: "Pedir taxi". |
| `onPressed` | `VoidCallback?` | — | `null` = deshabilitado. |
| `variant` | `TcButtonVariant` | primary | primary · secondary · outline · ghost · danger |
| `size` | `TcButtonSize` | large | large (56) · compact (44 con área táctil de 48) |
| `icon` | `IconData?` | null | Ícono a la izquierda. |
| `loading` | `bool` | false | Muestra un spinner y bloquea el toque. |
| `expand` | `bool` | true | Ocupa todo el ancho. |
| `semanticLabel` | `String?` | null | Texto alterno para lector de pantalla. |

## Variantes y estados
| Variante | Fondo | Texto | Borde |
|---|---|---|---|
| primary | `brand` | `onBrand` | — |
| secondary | `surfaceInverse` | `textInverse` | — |
| outline | transparente | `textPrimary` | `borderStrong` 1.5 |
| ghost | transparente | `textPrimary` | — |
| danger | `danger` | `onStatus` | — |

Estados: **presionado** (escala 0.97 + ripple), **deshabilitado** (fondo `surfaceSunken`, texto `textTertiary`), **cargando** (spinner del color del texto, cruce de 150 ms).

## Accesibilidad
- `Semantics(button, enabled)`. Altura mínima 48.
- Texto con `ellipsis` si no cabe; preferir textos cortos.

## Ejemplo
```dart
TcButton(
  label: 'Pedir Taxi · \$40–\$45',
  icon: Icons.local_taxi_rounded,
  loading: draft.requesting,
  onPressed: controller.request,
)
```
