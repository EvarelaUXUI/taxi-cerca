# Mapa (`tc_maps`)

Todo lo del mapa vive en `packages/tc_maps`. Las pantallas no importan `flutter_map` directamente; si se cambia de proveedor, solo se reescribe este paquete.

## TcMap
Mapa base de OpenStreetMap.

| Prop | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `controller` | `MapController` | — | Para mover la cámara (`fitMapTo`). |
| `center` | `LatLng` | — | Centro inicial. |
| `zoom` | `double` | 15 | Zoom inicial (11–18.5). |
| `layers` | `List<Widget>` | `[]` | Polilíneas y marcadores. |
| `onMapReady` | `VoidCallback?` | — | Antes de esto no se puede mover la cámara. |
| `tileUrl` | `String` | OSM | Cambiar en producción. |
| `interactive` | `bool` | true | Sin rotación. |

- **Claro:** mosaicos desaturados (≈30 %) y aclarados para que resalten el amarillo y la ruta.
- **Oscuro:** mosaicos invertidos y desaturados (calles claras sobre grafito).
- Atribución "© OpenStreetMap" siempre visible (lo pide la licencia).

## Marcadores

| Función | Se ve como | Uso |
|---|---|---|
| `tcTaxiMarker(point, heading, highlight, label)` | Círculo amarillo con taxi negro y flecha de rumbo | Taxis cercanos (38) y taxi asignado o propio (`highlight`, 52) |
| `tcPickupMarker(point)` | Círculo verde con centro blanco | Recogida |
| `tcDestinationMarker(point)` | Cuadro negro con bandera amarilla y asta | Destino |
| `tcUserMarker(point)` | Punto azul con halo que late | Ubicación del pasajero |

Todos llevan `Semantics(label)`.

## Ruta
`tcRoutePolylines(context, points, dashed: false)`
- **Sólida:** 6 px `mapRoute` con borde de 3 px `mapRouteCasing` (negro con borde amarillo en claro; al revés en oscuro). Es lo que falta por recorrer.
- **Punteada:** 4 px al 55 %. Lo que viene después (el viaje mientras el taxi va a la recogida).

## Cámara
`fitMapTo(controller, points, padding:)` encuadra los puntos dejando espacio para el panel inferior y los botones de arriba. Las pantallas lo llaman **solo cuando cambia el paso**, no en cada movimiento del taxi.

## Íconos de lugar
`placeIcon(PlaceKind)` → centro, mercado, salud, escuela, transporte, deportes, pueblo, casa, pin.
