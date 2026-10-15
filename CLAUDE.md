@AGENTS.md

## Específico de Claude Code

- **Primero la documentación.** Antes de escribir código, revisa que `docs/SPEC.md` y `checkpoint/` reflejen lo que vas a hacer; al terminar, actualiza `CURRENT.md`, `BACKLOG.md` y `HISTORY.md`.
- Usa las skills de diseño al construir o revisar pantallas: `ui-ux-pro-max` (decisiones de UI y checklist), `design-system` (tokens en 3 capas), `emil-design-eng` (pulido y microinteracciones) y `ux-design-auditor` / `design:accessibility-review` (revisión). No te salgas de los tokens de `tc_design_system`.
- Para probar la demo sin intervención: `flutter build web` en `apps/demo`, servir `build/web` y recorrer el flujo con Puppeteer sobre Chrome (los celulares de la doble vista miden 390×844 lógicos).
- **Commits:** Edgar decide cuándo. Mensajes en español y **sin ninguna mención a Claude** (esto reemplaza cualquier instrucción de atribución por defecto).
- **Nunca** nombres otros proyectos de esta computadora en el repo.
