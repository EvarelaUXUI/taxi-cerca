# Estado actual

**Última actualización:** 2026-10-14
**Fase:** F0–F4 listas y probadas de punta a punta en web · en GitHub · siguiente: feedback de Edgar en localhost y revisión de diseño

## Dónde estamos
- **Repo:** `https://github.com/EvarelaUXUI/taxi-cerca`, rama `main` publicada. Commits en español y **sin mención a Claude**.
- **Monorepo** con pub workspaces: `apps/demo`, `apps/pasajero`, `apps/taxista` + `packages/tc_design_system`, `tc_core`, `tc_maps`, `tc_rider`, `tc_driver`. `dart analyze` en 0 avisos.
- **Pruebas:** `packages/tc_core` 14 en verde (tarifas, formatos, cursor de ruta y 7 escenarios del simulador).
- **Demo web probada en doble vista** con Puppeteer: el viaje completo funciona (pedir → oferta → aceptar → llegada → viaje → cobro → calificaciones; ganancias $420 → $460).
- **Documentación:** SPEC, ARQUITECTURA, DESIGN_SYSTEM, 20 documentos de componentes, AGENTS, CLAUDE y este checkpoint.

## Cómo correrlo
```bash
cd apps/demo
flutter run -d chrome                         # desarrollo con recarga en caliente
# o lo compilado:
flutter build web && cd build/web && python3 -m http.server 8790   # http://localhost:8790
```
Pantalla ancha (≥ 900 px) = dos celulares lado a lado. Celular o ventana angosta = selector de rol (`/#/pasajero`, `/#/taxista`).

## Siguiente paso concreto
1. Edgar prueba en `http://localhost:8790` (laptop y ventana angosta) y da feedback.
2. Prueba de widget de `apps/demo` y guardar la prueba e2e de Puppeteer en el repo.
3. Revisión de diseño con `emil-design-eng` y `ux-design-auditor`; ícono de la app.
4. CI en GitHub Actions y publicar la demo web.

## Bloqueos y decisiones pendientes
- Sin Xcode ni Android Studio no se puede probar en celular nativo (solo web).
- Tarifas de la demo sin validar con taxistas reales.
- Mosaicos de OSM y OSRM públicos: solo para demo.
- En web el "sonido" de la oferta no suena (solo vibración en celular); falta un sonido propio.
