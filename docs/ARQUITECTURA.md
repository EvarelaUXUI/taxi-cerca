# Arquitectura

## 1. Paquetes y dependencias

```
┌──────────── apps ─────────────┐
│ demo        pasajero  taxista │   ProviderScope, tema, rutas
└──┬───────────┬─────────┬──────┘
   │           │         │
   ▼           ▼         ▼
 tc_rider ◀─✕─▶ tc_driver           UI y estado de cada rol (nunca se importan entre sí)
   │               │
   └──────┬────────┘
          ▼
       tc_maps                      TcMap, marcadores, polilíneas, cámara
          │
          ▼
       tc_core                      dominio, tarifas, rutas, TripRepository, simulador
          │
          ▼
  tc_design_system                  tokens, tema, componentes Tc* (sin lógica de negocio)
```

| Paquete | Contiene | No contiene |
|---|---|---|
| `tc_design_system` | `TcPalette`, `TcColors`, `TcTypography`, `TcSpace`, `TcRadius`, `TcSize`, `TcMotion`, `TcElevation`, `TcTheme`, componentes `Tc*` | Nada de viajes, tarifas ni mapa |
| `tc_core` | Modelos, `TownConfig`, `DemoProfiles`, `FareCalculator`, `RouteService` (OSRM + aproximado), `TripRepository`, `SimulatedTripRepository`, providers base, `Fmt`, geo | Widgets |
| `tc_maps` | `TcMap`, `tcTaxiMarker`, `tcPickupMarker`, `tcDestinationMarker`, `tcUserMarker`, `tcRoutePolylines`, `fitMapTo`, `placeIcon` | Lógica de viaje |
| `tc_rider` | `RiderHomeScreen`, `RiderDraftController`, paneles | Nada del taxista |
| `tc_driver` | `DriverHomeScreen`, `OfferSheet`, paneles | Nada del pasajero |

## 2. Estado (Riverpod)

Providers base en `tc_core/lib/src/providers.dart`:

| Provider | Qué da | Se sobrescribe para… |
|---|---|---|
| `townConfigProvider` | Pueblo activo (Ixtlahuaca) | Llevar la app a otro pueblo |
| `routeServiceProvider` | `OsrmRouteService` | Usar Mapbox/Google/OSRM propio |
| `fareCalculatorProvider` | Tarifas del pueblo | — |
| `tripRepositoryProvider` | `SimulatedTripRepository` | **Backend real** |

Por rol: `riderProfileProvider`, `riderTripProvider`, `nearbyTaxisProvider`, `riderDraftProvider` (pasajero) y `driverProfileProvider`, `driverSessionProvider` (taxista).

El **viaje** (estado del servidor) llega por *streams* del repositorio. El **borrador** del pasajero (destino elegido, tipo de taxi) es estado local en `RiderDraftController`. Las pantallas son funciones de esos dos.

## 3. Del simulador a un backend real

`TripRepository` (`tc_core/lib/src/data/trip_repository.dart`) es el contrato. Para producción:

1. Crear `SupabaseTripRepository` (o Firebase / API propia) que implemente la interfaz:
   - `watchRiderTrip` / `watchDriver` / `watchNearbyTaxis` → suscripciones en tiempo real (Realtime / Firestore snapshots / WebSocket).
   - `requestTrip`, `acceptOffer`, `rejectOffer`, `markArrived`, `startTrip`, `completeTrip`, `cancelTrip`, calificaciones → llamadas a funciones del servidor.
2. **El despacho y las tarifas finales se calculan en el servidor**, nunca en el celular (el cliente solo muestra el estimado).
3. La posición del taxista la manda su app (GPS cada 3–5 s); el servidor la reparte.
4. En cada app: `ProviderScope(overrides: [tripRepositoryProvider.overrideWith(...)])`. **Las pantallas no cambian.**
5. `simulateIncomingRequest` se queda solo en el simulador (en la implementación real lanza `UnsupportedError` o no se expone).

Tablas mínimas sugeridas: `riders`, `drivers`, `vehicles`, `trips` (estado, precio, rutas), `trip_events` (bitácora), `ratings`, `driver_locations` (última posición).

## 4. Separar en dos apps

Ya está hecho a nivel de código: `apps/pasajero` solo depende de `tc_rider` y `apps/taxista` solo de `tc_driver`. Para publicarlas:

1. Cambiar `applicationId` / `bundleId` (`mx.taxicerca.pasajero`, `mx.taxicerca.taxista`), íconos y nombres.
2. Sobrescribir `tripRepositoryProvider` con el backend real en cada `main.dart`.
3. `apps/demo` se queda para presentaciones.

Si algún día se necesitan repos separados, cada paquete `tc_*` se publica como paquete privado (git o pub privado) sin cambios de código.

## 5. Mapas y rutas

- **Mosaicos:** OSM público (`tile.openstreetmap.org`), con `userAgentPackageName`. Su política prohíbe uso intensivo: en producción, Mapbox, MapTiler, Stadia o servidor propio. Se cambia en `TcMap.tileUrl`.
- **Rutas:** OSRM público con caché en memoria y tiempo de espera de 6 s. Si falla, `ApproximateRouteService` (línea en "L", 30 km/h) para que nada se trabe. En producción: OSRM propio con el mapa de México o un proveedor con contrato.
- **Filtros:** los mosaicos se desaturan (claro) o invierten (oscuro) con una matriz de color para que resalten el amarillo y la ruta.

## 6. Simulador

`SimulatedTripRepository` usa un **reloj propio** (`advance(dt)`): un `Timer` lo avanza cada 200 ms en la app y las pruebas lo avanzan a mano, sin esperas reales. Las esperas (bot acepta, oferta vence, bot arranca) se agendan sobre ese reloj. Ver reglas en `SPEC.md § 6`.

## 7. Calidad

- `analysis_options.yaml` en la raíz, heredado por todos: `strict-casts`, `strict-inference`, `strict-raw-types` + reglas de estilo.
- Pruebas unitarias del dominio en `packages/tc_core/test`; prueba de widget en `apps/demo/test`.
- Pendiente: CI en GitHub Actions (`dart analyze` + `flutter test`).
