# TcIconButton

Botón redondo de solo ícono, pensado para flotar sobre el mapa (Regresar, Centrar).

Código: `packages/tc_design_system/lib/src/components/tc_icon_button.dart`

## Cuándo usarlo
- Acciones de navegación o utilidades del mapa. Si la acción es importante, usa `TcButton` con texto.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `icon` | `IconData` | — | Ícono. |
| `tooltip` | `String` | — | **Obligatorio.** Lo lee el lector de pantalla. |
| `onPressed` | `VoidCallback?` | — | `null` = deshabilitado. |
| `variant` | `TcIconButtonVariant` | surface | surface · brand · inverse · danger |
| `size` | `double` | 48 | Diámetro (mínimo 48). |
| `elevated` | `bool` | false | Sombra `mid` para separarlo del mapa. |

## Variantes y estados
Estados: presionado (0.97 + ripple).

## Accesibilidad
- `Tooltip` = etiqueta accesible. Ícono al 50 % del diámetro.

## Ejemplo
```dart
TcIconButton(
  icon: Icons.my_location_rounded,
  tooltip: 'Centrar mapa',
  elevated: true,
  onPressed: recenter,
)
```
