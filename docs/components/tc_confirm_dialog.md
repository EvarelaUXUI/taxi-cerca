# showTcConfirm

Diálogo para confirmar acciones destructivas (cancelar viaje o búsqueda). Devuelve `Future<bool>`.

Código: `packages/tc_design_system/lib/src/components/tc_confirm_dialog.dart`

## Cuándo usarlo
- Antes de cancelar. Nunca para acciones normales.

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `title` | `String` | — | Pregunta: "¿Cancelar el viaje?" |
| `body` | `String` | — | Consecuencia, en una o dos frases. |
| `confirmLabel` | `String` | Sí, cancelar | Botón `danger`. |
| `cancelLabel` | `String` | No, seguir | Botón `outline`; es la salida segura. |

## Variantes y estados
Radio `lg`, título `h3`.

## Accesibilidad
- Usa el `Navigator` más cercano (`useRootNavigator: false`): en la doble vista sale solo en el celular que lo pidió.

## Ejemplo
```dart
final ok = await showTcConfirm(context, title: '¿Cancelar el viaje?', body: '...');
```
