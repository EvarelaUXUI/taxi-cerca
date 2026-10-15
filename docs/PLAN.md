# Plan — Taxi Cerca (demo Flutter, Ixtlahuaca)

## Contexto
Edgar quiere un demo funcional de una app de taxi tipo Uber para apoyar a un pueblo: **Ixtlahuaca, Estado de México**. Necesita dos vistas, **Pasajero** y **Taxista**, con mapa, pines, notificación de viaje, aceptación, ruta, precio, destino, perfil y calificación. El proyecto puede escalar, así que el entorno se arma desde el inicio con buenas prácticas, documentación (SPEC, AGENTS, CLAUDE, checkpoints), un sistema de diseño en amarillo taxi y escala tipográfica móvil. Pasajero y taxista deben poder **separarse fácil en dos apps reales** cuando se haga oficial.

La carpeta está vacía. Flutter 3.47.7 / Dart 3.13.5 ya está instalado (Homebrew). No hay Xcode ni Android SDK, así que **el demo corre en web (Chrome)**. Android e iOS quedan en el backlog cuando se instalen las herramientas.

**Regla:** ningún archivo ni documento nombra otros proyectos de la computadora.

## Decisiones clave
| Tema | Decisión | Por qué |
|---|---|---|
| Estructura | **Monorepo con Dart pub workspaces** (nativo, sin melos) | Pasajero y taxista son paquetes independientes; separarlos = crear otra app que importe solo uno |
| Estado | **Riverpod** (`flutter_riverpod`) | Estándar escalable, testeable, inyección de repositorios fácil de cambiar |
| Navegación | **go_router** | Deep links (`/pasajero`, `/taxista`, `/demo`), listo para notificaciones push |
| Mapa | **flutter_map + latlong2 + mosaicos OSM**, con filtro de desaturación para que resalte el amarillo | Sin API key; se puede cambiar a Mapbox/Google más tarde detrás de la misma interfaz |
| Rutas | **OSRM público** vía `http`, con caché en memoria y respaldo de línea interpolada si falla | Ruta por calle real y el demo nunca se rompe sin red |
| Backend | **`TripRepository` abstracto + `SimulatedTripRepository`** en memoria (streams) | Un solo "backend" que comparten las dos vistas; después se cambia por Supabase/Firebase sin tocar la UI |
| Modelos | Clases inmutables a mano con `copyWith` y `==` (sin codegen) | Cero build_runner en el demo; se puede migrar a freezed |
| Tipografía | **Lexend** (títulos y cifras) + **Source Sans 3** (texto), vía `google_fonts` | Recomendación de la skill ui-ux-pro-max: muy legibles, buenas para usuarios mayores |
| Lint | `flutter_lints` estricto + `analysis_options.yaml` compartido | Calidad desde el día 1 |

## Estructura
```
17.-Taxi-cerca/
  pubspec.yaml                 # workspace raíz
  analysis_options.yaml
  apps/
    demo/                      # app principal del demo (doble vista + selector de rol)
    pasajero/                  # entrypoint solo pasajero (prueba de que se separa)
    taxista/                   # entrypoint solo taxista
  packages/
    tc_design_system/          # tokens, tema, componentes (sin lógica de negocio)
    tc_core/                   # dominio: modelos, tarifas, repositorio, simulador, config del pueblo
    tc_maps/                   # TcMap, marcadores, polilíneas, RouteService (OSRM + respaldo)
    tc_rider/                  # UI y estado del pasajero (depende de core, maps, design_system)
    tc_driver/                 # UI y estado del taxista (no importa tc_rider, y al revés)
  docs/  SPEC.md · DESIGN_SYSTEM.md · ARQUITECTURA.md · components/*.md · PLAN.md
  checkpoint/  CURRENT.md · BACKLOG.md · HISTORY.md
  AGENTS.md · CLAUDE.md · README.md · .gitignore
```
Regla de dependencias (va en AGENTS.md): `design_system` ← `core` ← `maps` ← `rider` | `driver` ← `apps`. Un feature nunca importa al otro.

## Sistema de diseño (`tc_design_system`)
- **Color (tokens semánticos, claro y oscuro):** amarillo taxi `#FFC800` (primario, siempre con texto negro, contraste ~13:1), asfalto `#141414` (texto/CTA secundario), superficies neutras cálidas, éxito, peligro, info. El amarillo nunca va como texto sobre blanco. Contrastes verificados para WCAG AA.
- **Escala tipográfica móvil (ratio ~1.2, base 16):** display 40/44 · h1 32/38 · h2 26/32 · h3 22/28 · title 18/24 · bodyL 17/26 · body 16/24 · bodyS 14/20 · label 14/20 (600) · caption 12/16. Precios y tiempos con cifras tabulares.
- **Espaciado 4/8**, radios (8/12/20/pill), elevaciones, duraciones de movimiento (150/250/350 ms), respeto a `MediaQuery.disableAnimations`.
- **Componentes documentados** (un `.md` por componente con props, estados, uso y accesibilidad): `TcButton` (primary/secondary/ghost/danger, loading, 56 dp), `TcIconButton`, `TcAvatar` (iniciales), `TcRating`, `TcPrice`, `TcStatusPill`, `TcBottomSheet` (arrastrable), `TcPlaceTile`, `TcVehicleCard`, `TcCountdownRing`, `TcSwitchOnline`, `TcStarPicker`, `TcToast`. Áreas táctiles ≥ 48 dp.
- Se usa la skill `ui-ux-pro-max` (ya consultada), `design-system` para la arquitectura de tokens y `emil-design-eng` + `ux-design-auditor` para pulir y revisar al final.

## Dominio y simulador (`tc_core`)
- `TownConfig` de **Ixtlahuaca** (centro 19.5652, -99.7619) con lugares reales geocodificados: Centro (jardín), Mercado Municipal, Terminal de Autobuses, Hospital General, Centro Universitario Ixtlahuaca, Col. San Francisco de Asís, Santo Domingo de Guzmán, Emiliano Zapata, Unidad Deportiva Gustavo Baz, San Pedro de los Baños y TES Jocotitlán. Se cambia de pueblo en un solo archivo.
- Modelos: `Place`, `RiderProfile`, `DriverProfile` (nombre, foto/iniciales, calificación, viajes, auto, color, placas, número económico), `Trip`, `TripStatus` (`searching → offered → accepted → arriving → arrived → inProgress → completed` y `cancelled`/`expired`), `FareQuote`.
- `FareCalculator`: banderazo $25 + $7/km + $1.50/min, mínimo $40, en MXN; el pasajero ve un rango (±10%) y el final sale de la ruta real. Pago en efectivo. Dos tipos: **Taxi** y **Taxi Grande** (×1.3).
- `SimulatedTripRepository`: streams para pasajero y taxista; despacho al taxista de la demo si está conectado y es el más cercano, si no a un taxista bot. Movimiento del auto sobre la polilínea con tiempo comprimido (~20 s por tramo). Taxistas bot que se mueven por el mapa. Botón "Simular solicitud" en el taxista para usarlo solo.

## Flujo del pasajero (`tc_rider`), todo sobre el mapa con hoja inferior
1. Inicio: pin del pasajero + taxis cercanos, "¿A dónde vas?", accesos rápidos (Mercado, Centro, Hospital).
2. Destino: búsqueda en los lugares del pueblo.
3. Confirmar: ruta dibujada, Taxi / Taxi Grande con rango de precio, llegada del taxi y duración, pago en efectivo, "Pedir taxi".
4. Buscando: animación de radar, cancelar.
5. Taxi asignado: tarjeta del taxista (calificación, auto, placas, número económico), tiempo de llegada en vivo, llamar/mensaje (simulado), cancelar.
6. "Tu taxi llegó" → En viaje: avance y hora de llegada, compartir viaje y botón de emergencia (simulados).
7. Fin: total, calificar con estrellas + propina opcional.

## Flujo del taxista (`tc_driver`)
1. Desconectado: mapa con su pin, ganancias de hoy, viajes y calificación, switch "Conectarse".
2. Conectado: "Buscando viajes" (pulso) + "Simular solicitud".
3. **Notificación de viaje**: tarjeta a pantalla completa con anillo de 15 s, nombre y calificación del pasajero, distancia y tiempo a la recogida, destino, distancia del viaje, **precio grande**, pago; Aceptar / Rechazar; vibración y sonido.
4. A recoger: ruta, tarjeta del pasajero, "Ya llegué".
5. Esperando: "Iniciar viaje". 6. En viaje: ruta al destino, "Terminar viaje".
7. Resumen: cobro en efectivo, calificar al pasajero; las ganancias del día se actualizan.

## App demo (`apps/demo`)
- Pantalla ancha (≥ 900 px): **dos celulares lado a lado** (Pasajero | Taxista) con el mismo repositorio, para jugar el viaje completo en vivo.
- Celular: pantalla de elección de rol + chip flotante para cambiar. Rutas `/`, `/pasajero`, `/taxista`.
- `apps/pasajero` y `apps/taxista`: entrypoints mínimos que montan solo su paquete (así se separan).

## Documentación
- `docs/SPEC.md`: problema, propuesta, alcance (dentro y fuera), usuarios, flujos, máquina de estados, tarifas, criterios de aceptación.
- `docs/ARQUITECTURA.md`: paquetes, reglas de dependencia, cómo cambiar el simulador por un backend real, cómo separar en dos apps.
- `docs/DESIGN_SYSTEM.md` + `docs/components/*.md`: tokens, escala tipográfica, contraste y cada componente.
- `AGENTS.md` (reglas para cualquier agente), `CLAUDE.md` (`@AGENTS.md` + skills que hay que usar), `README.md` (cómo correrlo).
- `checkpoint/CURRENT.md`, `BACKLOG.md` (P0/P1/P2 por fases), `HISTORY.md` (`AAAA-MM-DD · tipo · qué · por qué`).
- `docs/PLAN.md`: copia de este plan.

## Orden de ejecución
1. Workspace, paquetes, lints, `.gitignore`, `git init` (sin commit; los commits los hace Edgar).
2. Design system: tokens, tema, componentes.
3. Core: modelos, tarifas, configuración del pueblo, simulador. Pruebas unitarias.
4. Maps: TcMap, marcadores, RouteService.
5. Pasajero → Taxista → shell del demo.
6. Documentación y checkpoints.
7. Verificación y revisión de diseño (skills `emil-design-eng` y `ux-design-auditor`).

## Verificación
- `dart analyze` sin errores ni warnings en todo el workspace.
- `flutter test`: tarifas, máquina de estados del viaje, despacho del simulador y widget test del flujo de aceptación.
- `flutter build web` de `apps/demo` → servir local y abrir en Chrome: recorrer el viaje completo en doble vista (pedir → notificación → aceptar → llegada → viaje → fin → calificaciones) y revisar a 390 px.
- Capturas de pantalla para revisar el diseño. Se le dan a Edgar el comando `flutter run -d chrome` y la URL local.
