# TcBottomPanel

Panel inferior sobre el mapa, el patrón central de las apps de viaje. Su contenido cambia según el paso.

Código: `packages/tc_design_system/lib/src/components/tc_bottom_panel.dart`

## Cuándo usarlo
- Una vez por pantalla, anclado abajo. El contenido de cada paso va como `child` y `stateKey` identifica el paso.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `child` | `Widget` | — | Contenido del paso. |
| `stateKey` | `Object` | — | Al cambiar, el contenido se reemplaza con animación. |
| `padding` | `EdgeInsets?` | gutter | Relleno interior. |

## Variantes y estados
- Radio superior `xl` (28), sombra `high`, barra de agarre de 40×4.
- El alto se anima (`AnimatedSize`, 250 ms) y el contenido cambia con fundido + desplazamiento de 4 % (entra 250 ms, sale 150 ms).
- Respeta la zona segura inferior.

## Accesibilidad
- Cada panel debe empezar con un encabezado (`Semantics(header: true)`).

## Ejemplo
```dart
TcBottomPanel(stateKey: 'confirm', child: ConfirmPanel())
```
