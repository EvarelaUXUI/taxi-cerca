# AGENTS.md — Taxi Cerca

Reglas para cualquier agente de código (Claude Code, Cursor, Codex) que trabaje en este repo.
Léelo completo antes de tocar código. Si algo aquí choca con una petición, pregunta.

## Qué es esto

Demo de una app de taxis **tipo Uber, pero local**, para **Ixtlahuaca, Estado de México**. Tiene dos vistas, **Pasajero** y **Taxista**, que comparten un "backend" simulado: lo que pide uno le llega al otro. La meta es que el demo funcione de punta a punta y que el proyecto pueda crecer a producción sin rehacerlo.

**Alcance actual: demo con datos ficticios.** No hay backend real, login, pagos ni push reales.

## Documentos que mandan

| Archivo | Para qué |
|---|---|
| `docs/SPEC.md` | Qué se construye: problema, flujos, máquina de estados, tarifas y criterios de aceptación |
| `docs/ARQUITECTURA.md` | Paquetes, reglas de dependencia, cómo pasar a backend real y cómo separar las apps |
| `docs/DESIGN_SYSTEM.md` | Tokens (color, tipografía, espaciado, movimiento) y reglas visuales |
| `docs/components/*.md` | Un archivo por componente: props, variantes, estados y accesibilidad |
| `docs/PLAN.md` | Plan original aprobado |
| `checkpoint/CURRENT.md` | En qué vamos ahorita. **Léelo al iniciar cada sesión** |
| `checkpoint/BACKLOG.md` | Qué sigue, priorizado |
| `checkpoint/HISTORY.md` | Bitácora de decisiones y avances |

## Stack (no lo cambies sin preguntar)

- **Flutter 3.47 / Dart 3.13**, monorepo con **pub workspaces** (sin melos).
- **Estado:** `flutter_riverpod` 3. **Navegación:** `go_router` 18 (solo en `apps/demo`).
- **Mapa:** `flutter_map` 8 + `latlong2` + mosaicos de OpenStreetMap. **Rutas:** OSRM público con respaldo sin red.
- **Tipografía:** `google_fonts` (Lexend + Source Sans 3).
- **Hoy corre en web (Chrome).** Android e iOS necesitan Android Studio / Xcode instalados.

## Estructura

```
apps/
  demo/          # doble vista (pantalla ancha) + selector de rol (celular). Rutas /, /pasajero, /taxista
  pasajero/      # app solo pasajero
  taxista/       # app solo taxista
packages/
  tc_design_system/  # tokens, tema y componentes Tc*. Sin lógica de negocio
  tc_core/           # modelos, TownConfig, FareCalculator, RouteService, TripRepository, simulador, providers
  tc_maps/           # TcMap, marcadores, polilíneas, cámara, íconos de lugar
  tc_rider/          # pantalla y paneles del pasajero
  tc_driver/         # pantalla, paneles y oferta del taxista
docs/  checkpoint/
```

## Reglas duras

1. **Dependencias en una sola dirección:** `tc_design_system` ← `tc_core` ← `tc_maps` ← `tc_rider` | `tc_driver` ← `apps`. **`tc_rider` y `tc_driver` nunca se importan entre sí.** Si algo lo necesitan los dos, va a `tc_core` (lógica) o `tc_design_system` (UI).
2. **La UI solo habla con `TripRepository`.** Nada de llamar al simulador directo desde pantallas. El backend real será otra implementación de esa interfaz.
3. **Nada de colores, tamaños ni fuentes a mano en pantallas.** Usa `context.colors`, `context.type`, `TcSpace`, `TcRadius`, `TcSize`, `TcMotion`. `TcPalette` (primitivos) solo se usa dentro del sistema de diseño y en el marco de la demo.
4. **El amarillo nunca es texto sobre blanco** (contraste 1.5:1). Sobre amarillo va `onBrand` (negro). Para texto "amarillo" usa `brandText`.
5. **Accesibilidad mínima:** áreas táctiles ≥ 48 dp, contraste AA, `Semantics`/`tooltip` en todo lo que solo es ícono, el color nunca es el único indicador y se respeta `TcMotion.reduced(context)`.
6. **Datos 100 % ficticios.** Nombres, placas y teléfonos inventados. Los lugares sí son reales (OSM).
7. **Un pueblo = un `TownConfig`.** Lugares, tarifas y puntos de inicio viven ahí; no los repartas por el código.
8. **Diálogos y avisos locales:** usa `showTcConfirm` y `showTcToast` (respetan el celular en el que se pidieron dentro de la doble vista).
9. **Mapas y rutas públicos son solo para demo.** En producción se cambia a un proveedor con contrato (ver `docs/ARQUITECTURA.md`).
10. **Nunca nombres otros proyectos** en código, comentarios, docs ni commits.
11. **Commits y PR sin ninguna mención a Claude** (sin `Co-Authored-By`, sin "Generated with…"). Mensajes en español.

## Cómo trabajar

- Al iniciar: lee `checkpoint/CURRENT.md` y `checkpoint/BACKLOG.md`.
- Al terminar una tarea: actualiza `CURRENT.md`, marca el ítem en `BACKLOG.md` y agrega una línea con la fecha en `HISTORY.md`.
- Componente nuevo o cambiado → actualiza su `docs/components/<nombre>.md`.
- Antes de dar algo por terminado:
  ```bash
  dart analyze                       # desde la raíz: 0 avisos
  (cd packages/tc_core && flutter test)
  (cd apps/demo && flutter test)
  (cd apps/demo && flutter run -d chrome)   # recorre el viaje en doble vista
  ```
- Escribe código como el que ya existe: **nombres en inglés, textos de UI y comentarios en español** (de México, cálido y directo).
