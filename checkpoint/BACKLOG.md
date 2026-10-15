# Backlog

Prioridad: **P0** bloquea la demo · **P1** la hace woow · **P2** es deseable.
Se marca `[x]` al terminar y se registra en `HISTORY.md`.

## F0 · Entorno
- [x] P0 · Instalar Flutter (Homebrew) y crear el monorepo con pub workspaces: 3 apps y 5 paquetes
- [x] P0 · `analysis_options.yaml` estricto compartido (strict-casts, strict-inference, comillas simples, comas finales…)
- [x] P0 · Documentación base: SPEC, AGENTS, CLAUDE, ARQUITECTURA, DESIGN_SYSTEM, componentes y checkpoint
- [ ] P0 · Repo en GitHub (`EvarelaUXUI/taxi-cerca`) con primer commit
- [ ] P1 · CI en GitHub Actions: `dart analyze` + `flutter test` en cada push
- [ ] P1 · Publicar la demo web (GitHub Pages, Cloudflare Pages o Vercel)
- [ ] P1 · Instalar Android Studio y Xcode; correr en Android e iPhone reales
- [ ] P2 · Fuentes empaquetadas como assets (hoy se bajan de Google Fonts al abrir)

## F1 · Sistema de diseño
- [x] P0 · Tokens en 3 capas: `TcPalette` → `TcColors`/`TcTypography` → componentes; claro y oscuro con contraste AA verificado
- [x] P0 · Escala tipográfica móvil (11 niveles, base 16, Lexend + Source Sans 3)
- [x] P0 · Componentes: Button, IconButton, Avatar, Rating, Price, StatusPill, BottomPanel, PlaceTile, VehicleCard, CountdownRing, OnlineSwitch, StarPicker, Toast, Radar, RouteSummary, PersonRow, QuickAction, ConfirmDialog, Pressable
- [ ] P1 · Revisión con `emil-design-eng` y `ux-design-auditor`
- [ ] P1 · Logo / ícono de app y splash
- [ ] P2 · Librería del sistema de diseño en Figma (variables + componentes)
- [ ] P2 · Galería de componentes (Widgetbook) para revisarlos sin correr la app

## F2 · Dominio y simulador
- [x] P0 · Modelos inmutables (`Trip`, `TripStatus`, `Place`, perfiles, `RouteInfo`, `FareQuote`, `DriverSession`)
- [x] P0 · `TownConfig` de Ixtlahuaca con 11 lugares reales (OSM)
- [x] P0 · `FareCalculator` con rango ±10 % y redondeo a $5
- [x] P0 · `RouteService`: OSRM con caché y respaldo sin red
- [x] P0 · `TripRepository` + `SimulatedTripRepository` (despacho, ofertas con vencimiento, bots, movimiento sobre ruta, reloj propio para pruebas)
- [x] P0 · Pruebas: tarifas, formatos, cursor de ruta y 7 escenarios del simulador
- [ ] P1 · Validar tarifas con taxistas de Ixtlahuaca

## F3 · Pasajero
- [x] P0 · Inicio, búsqueda, confirmar (Taxi / Taxi Grande), buscando, en camino, llegó, en viaje, fin y cancelado
- [x] P0 · Mapa con taxis cercanos, ruta, recogida, destino y taxi asignado en movimiento
- [x] P0 · Arreglar el error "Null check" que salió al pedir el taxi en la demo web
- [x] P1 · Pin del pasajero visible arriba del panel en Inicio; texto del buscador en una línea
- [ ] P1 · Prueba de widget de la demo (`apps/demo/test`) y prueba e2e con Puppeteer guardada en el repo
- [ ] P1 · Elegir punto de recogida moviendo el mapa
- [ ] P1 · GPS real (`geolocator`) con permiso
- [ ] P2 · Lugares favoritos (Casa, Trabajo) e historial de viajes

## F4 · Taxista
- [x] P0 · Conectarse, buscando viajes, oferta con anillo de 15 s, a recoger, esperando, en viaje, cobro y calificación
- [x] P0 · Ganancias y viajes del día
- [x] P0 · Vibración y sonido del sistema al llegar la oferta
- [ ] P1 · Sonido propio de "viaje nuevo" (en web hoy no suena)
- [ ] P1 · Botón "Navegar" que abra Google Maps / Waze de verdad
- [ ] P2 · Resumen semanal de ganancias

## F5 · Producción
- [ ] P0 · Backend real (Supabase o Firebase) como nueva implementación de `TripRepository`
- [ ] P0 · Login por teléfono (OTP) para pasajeros y taxistas; alta y verificación de taxistas
- [ ] P0 · Notificaciones push (FCM / APNs) para ofertas
- [ ] P0 · Proveedor de mapas y rutas con contrato (Mapbox / Google / OSRM propio)
- [ ] P1 · Panel web para el sitio de taxis (conductores, viajes, calificaciones)
- [ ] P1 · Pagos con tarjeta / transferencia
- [ ] P1 · Botón de emergencia real (911 + contactos) y compartir viaje con enlace
- [ ] P2 · Pedir por WhatsApp para quien no usa apps
