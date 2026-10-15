# SPEC — Taxi Cerca (demo)

**Versión:** 0.1 · **Fecha:** 2026-10-14 · **Responsable:** Edgar Varela
**Estado:** demo funcional en web; pendiente validar en celular (Android/iOS)

---

## 1. Problema

En pueblos y municipios chicos como **Ixtlahuaca, Estado de México**, pedir un taxi depende de ir al sitio, llamar a un conocido o esperar en la calle:

- **No sabes cuánto vas a pagar** hasta que llegas, y el precio cambia según quién maneje.
- **No sabes quién llega ni cuándo.** No hay nombre, placas ni tiempo de espera; para mujeres, adultos mayores y gente que sale de noche esto pesa.
- **Los taxistas pierden viajes**: esperan en el sitio mientras a 3 calles alguien busca taxi.
- Las apps grandes no operan o casi no tienen conductores en estos lugares.

## 2. Propuesta

Una app **pequeña y local**, tipo Uber, hecha para el pueblo:

1. **Pasajero:** elige a dónde va, ve el **precio estimado antes de pedir**, ve **quién es el taxista** (calificación, auto, placas y número económico), el **tiempo de llegada en vivo** y la ruta. Paga en efectivo.
2. **Taxista:** se conecta, le llega una **notificación de viaje** con precio, destino, distancia, pasajero y su calificación; **acepta o rechaza** en 15 s; ve la ruta a la recogida y al destino; cobra y califica.
3. **Tarifa transparente y fija por fórmula** (banderazo + km + minuto), pensada para efectivo.

## 3. Alcance

### Dentro (demo)
- App Flutter con **dos vistas**: Pasajero y Taxista.
- **Doble vista** en pantalla ancha (los dos celulares lado a lado, compartiendo el mismo "backend" simulado) y **selector de rol** en celular.
- Mapa real (OpenStreetMap) con pines: pasajero, taxis cercanos, recogida, destino y taxi asignado moviéndose sobre la ruta por calle (OSRM).
- Flujo completo: pedir → buscar → oferta al taxista → aceptar → en camino → llegó → en viaje → fin → calificaciones (y propina).
- Cancelación del pasajero (con confirmación) y del taxista (se reasigna el viaje).
- Si el taxista de la demo no está conectado o rechaza, **un taxista simulado** toma el viaje (la demo nunca se traba).
- Modo claro y oscuro. Accesibilidad básica (contraste AA, áreas táctiles de 48 dp, etiquetas para lector de pantalla, movimiento reducido).
- Apps separadas `apps/pasajero` y `apps/taxista` que ya compilan solas.

### Fuera (por ahora)
- Backend real, login, pagos con tarjeta, notificaciones push reales, GPS real, chat y llamadas reales, panel de administración, tarifas dinámicas. Todo está en `checkpoint/BACKLOG.md`.
- Datos reales de personas: **todos los perfiles son ficticios**.

## 4. Usuarios

| Persona | Necesita |
|---|---|
| **Pasajera/o** (principal): estudiantes, señoras que van al mercado, adultos mayores que van al hospital, gente que llega a la terminal | Saber cuánto cuesta, quién llega y cuándo; sentirse segura; pocos pasos y letra grande |
| **Taxista**: conductores del pueblo, muchos con años manejando y poca costumbre de apps | Decidir rápido si le conviene un viaje (precio, distancia, destino); botones grandes; no distraerse manejando |
| **Organización / sitio de taxis** (futuro) | Ver viajes, conductores activos y calificaciones |

## 5. Flujos

### 5.1 Pasajero (una sola pantalla: mapa + panel inferior)
1. **Inicio** — "¿A dónde vas?", buscador, 3 accesos rápidos (Mercado, Centro, Hospital), píldora con taxis cercanos y tiempo.
2. **Buscar destino** — lugares del pueblo, filtro sin acentos, ordenados por cercanía.
3. **Confirmar** — ruta dibujada, *Taxi* o *Taxi Grande* con **rango de precio** y tiempo de llegada, pago en efectivo, botón "Pedir Taxi · $40–$45".
4. **Buscando** — radar; "Un taxista está viendo tu viaje" cuando hay oferta; cancelar.
5. **Taxi en camino** — "Llega en 3 min", taxista (calificación, viajes, años manejando), auto, **placas y número económico grandes**, Llamar/Mensaje/Compartir (simulados), cancelar.
6. **Taxi llegó** — "Sal a tu taxi · busca el IX-027".
7. **En viaje** — hora de llegada, barra de avance, Compartir viaje y Emergencia (simulados).
8. **Fin** — total, calificar 1–5 estrellas, propina opcional ($10/$20/$30), "Ahora no".

### 5.2 Taxista (mapa + ganancias arriba + panel inferior)
1. **Desconectado** — saludo, botón grande "Conectarme".
2. **Conectado** — "Buscando viajes…" con radar; botón "Simular solicitud (demo)".
3. **Oferta** — entra desde abajo sobre un velo, con vibración y sonido. Orden de lectura: **precio grande** → recogida (distancia/tiempo desde él) → destino (distancia/duración del viaje) → pasajero (nombre, calificación, viajes). **Anillo de 15 s**; Rechazar / Aceptar viaje.
4. **A recoger** — ruta, "Llegas en X min", Llamar/Navegar (simulados), "Ya llegué", cancelar.
5. **Esperando** — "Iniciar viaje".
6. **En viaje** — barra de avance; "Terminar viaje" (se vuelve principal al llegar al destino).
7. **Cobro** — monto a cobrar en efectivo, "+$X a tus ganancias de hoy", calificar al pasajero.

## 6. Máquina de estados del viaje

```
searching ──(despacho 1.8 s)──▶ offered ──(acepta)──▶ driverEnRoute ──(llega / "Ya llegué")──▶ driverArrived
    ▲                             │                                                           │
    └──(rechaza o vence 15 s)─────┘                                                    ("Iniciar viaje")
                                                                                              ▼
                     completed ◀──("Terminar viaje")── inProgress (progress 0→1; atDestination al llegar)

Desde searching/offered/driverEnRoute/driverArrived:
  - pasajero cancela → cancelled
  - taxista cancela  → searching (se le busca otro taxi; ese taxista queda excluido)
```

Reglas de despacho (`SimulatedTripRepository._dispatch`):
- Si el **taxista de la demo** está conectado y libre, la oferta le llega a él (para poder jugar las dos vistas).
- Si no, al taxista libre **más cercano** a la recogida que no haya rechazado ese viaje.
- Los taxistas simulados aceptan a los 2.5 s, arrancan a los 3 s de llegar y terminan solos.
- El taxista no se puede desconectar a media carrera.

Tiempo: los trayectos se **recorren comprimidos** (8–25 s), pero los tiempos que se muestran son los **reales** de la ruta.

## 7. Tarifas

Configurables por pueblo en `TownConfig.fareRules` (`packages/tc_core/lib/src/config/town_config.dart`):

| Concepto | Ixtlahuaca (demo) |
|---|---|
| Banderazo | $25 |
| Por km | $7 |
| Por minuto | $1.50 |
| Mínima | $40 |
| Rango que ve el pasajero | ±10 % |
| Redondeo | múltiplos de $5 (efectivo) |
| Taxi Grande | ×1.3 |

Ejemplo: 5 km y 10 min → 25 + 35 + 15 = **$75** (rango $70–$85).
El cobro final de la demo = estimado. *Las cifras son supuestos para la demo; hay que validarlas con taxistas del pueblo.*

## 8. Arquitectura (resumen)

Monorepo con *pub workspaces*. Detalle en `docs/ARQUITECTURA.md`.

```
apps/demo, apps/pasajero, apps/taxista
        │
packages/tc_rider   packages/tc_driver      (nunca se importan entre sí)
        └──────┬──────────┘
        packages/tc_maps
        packages/tc_core        (dominio, tarifas, TripRepository, simulador)
        packages/tc_design_system
```

- Estado: **Riverpod 3**. Navegación: **go_router 18**. Mapa: **flutter_map 8 + OSM**. Rutas: **OSRM** con respaldo sin red.
- La UI solo habla con `TripRepository`. Hoy lo implementa `SimulatedTripRepository`; mañana Supabase, Firebase o API propia, **sin tocar pantallas**.

## 9. Diseño

Sistema propio en `packages/tc_design_system` (detalle en `docs/DESIGN_SYSTEM.md`):
- Marca **amarillo taxi `#FFC800`** con **negro asfalto `#171614`**; el amarillo nunca es texto sobre blanco.
- Tipografía **Lexend** (títulos y cifras) + **Source Sans 3** (texto); escala móvil de 11 niveles, base 16.
- Componentes documentados uno por uno en `docs/components/`.

## 10. Criterios de aceptación

- [x] El pasajero ve precio estimado (rango) y tiempo de llegada **antes** de pedir.
- [x] La solicitud le llega al taxista con precio, destino, distancias, pasajero y calificación; tiene 15 s.
- [x] Al aceptar, el pasajero ve taxista, auto, placas, número económico y el taxi moviéndose por la calle.
- [x] El viaje se completa y ambos califican; las ganancias del taxista suben.
- [x] Si el taxista rechaza o no contesta, otro taxi toma el viaje.
- [x] Funciona sin servicio de rutas (línea aproximada).
- [x] `dart analyze` sin avisos y pruebas en verde.
- [ ] Probado en un celular Android y uno iPhone reales.
- [ ] Validado con 3 taxistas y 5 pasajeros del pueblo.

## 11. Preguntas abiertas

1. ¿Las tarifas de la demo se parecen a lo que se cobra hoy en Ixtlahuaca?
2. ¿Quién opera la app: un sitio de taxis, el municipio o una cooperativa?
3. ¿Los taxistas tienen celular con datos todo el día?
4. ¿Hace falta pedir por WhatsApp o llamada para quien no usa apps?
