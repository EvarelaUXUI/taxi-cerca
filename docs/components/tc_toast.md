# showTcToast

Aviso breve de 4 s abajo de la pantalla. No roba el foco.

Código: `packages/tc_design_system/lib/src/components/tc_toast.dart`

## Cuándo usarlo
- Confirmaciones y acciones simuladas de la demo ("Llamando a Alberto… (simulado)").

## Props
| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `message` | `String` | — | Texto corto. |
| `icon` | `IconData` | info_outline | Ícono en amarillo. |

## Variantes y estados
Fondo `surfaceInverse`, texto `textInverse`, flotante con radio `md`.

## Accesibilidad
- Usa el `ScaffoldMessenger` más cercano: en la doble vista sale solo en su celular.

## Ejemplo
```dart
showTcToast(context, 'Enlace del viaje copiado', icon: Icons.ios_share_rounded);
```
