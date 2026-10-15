# Taxi Cerca

Demo de una app de taxis local, tipo Uber, para **Ixtlahuaca, Estado de México**. Tiene dos vistas, **Pasajero** y **Taxista**, que comparten un backend simulado: lo que pide uno le llega al otro.

## Correr la demo

Requisitos: Flutter 3.47+ (`brew install --cask flutter`) y Chrome.

```bash
flutter pub get                 # desde la raíz (workspace)
cd apps/demo
flutter run -d chrome
```

- **Pantalla ancha (≥ 900 px):** dos celulares lado a lado. Conecta al taxista (derecha), pide un taxi (izquierda) y acepta la solicitud.
- **Celular:** elige rol; el botón "Viendo: …" cambia entre pasajero y taxista.
- Rutas directas: `/#/pasajero` y `/#/taxista`.

Apps separadas: `apps/pasajero` y `apps/taxista` (`flutter run -d chrome` en cada una).

## Calidad

```bash
dart analyze                        # desde la raíz
(cd packages/tc_core && flutter test)
(cd apps/demo && flutter test)
```

## Estructura

```
apps/      demo · pasajero · taxista
packages/  tc_design_system · tc_core · tc_maps · tc_rider · tc_driver
docs/      SPEC · ARQUITECTURA · DESIGN_SYSTEM · components/ · PLAN
checkpoint/ CURRENT · BACKLOG · HISTORY
```

Empieza por [`docs/SPEC.md`](docs/SPEC.md) y [`checkpoint/CURRENT.md`](checkpoint/CURRENT.md). Reglas para agentes de código: [`AGENTS.md`](AGENTS.md).

Mapas © colaboradores de OpenStreetMap. Rutas: OSRM. Todos los perfiles de personas son ficticios.
