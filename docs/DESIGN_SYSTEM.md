# Sistema de diseño — Taxi Cerca

Código en `packages/tc_design_system`. Un archivo por componente en `docs/components/`.

## Principios

1. **Se lee de un vistazo.** Taxistas manejando y pasajeros en la calle: cifras grandes, una acción principal por pantalla, letra de 16 o más para leer.
2. **Confianza antes que adorno.** Precio, nombre, placas y tiempo siempre visibles y grandes.
3. **Amarillo = acción y marca.** Es el color de los taxis; se usa para lo que se toca y para el taxi en el mapa, no para decorar.
4. **Para todos.** Contraste AA, áreas táctiles de 48, textos que no dependen solo del color, y se respeta "reducir movimiento".

## Arquitectura de tokens (3 capas)

```
Capa 1 · Primitivos      TcPalette.yellow500 = #FFC800        (no se usan en pantallas)
          ▼
Capa 2 · Semánticos      context.colors.brand → yellow500     (claro y oscuro)
                         context.type.h2
          ▼
Capa 3 · Componentes     TcButton(primary) → fondo brand, texto onBrand
```

Cambiar la marca o el modo oscuro se hace en la capa 2, sin tocar pantallas.

## Color

### Primitivos

| Familia | 50 | 100 | 200 | 300 | 400 | **500** | 600 | 700 | 800 | 900 |
|---|---|---|---|---|---|---|---|---|---|---|
| Amarillo taxi | `#FFF8DB` | `#FFEFB0` | `#FFE27A` | `#FFD64A` | `#FFCC1F` | **`#FFC800`** | `#E0AE00` | `#A88200` | `#7A5E00` | `#3D2F00` |

Asfalto (neutros cálidos): `25 #FAFAF7` · `50 #F4F3EF` · `100 #E9E7E1` · `200 #D6D3CB` · `300 #B5B1A7` · `400 #8C887E` · `500 #6B675E` · `600 #4F4C45` · `700 #36342F` · `800 #24231F` · `850 #1C1B18` · `900 #171614` · `950 #0E0D0C`.
Estados: verde `#187A42`/`#4CC27E`, rojo `#B3261E`/`#FF6B5E`, azul `#1F6FEB`/`#6EA8FF` (claro/oscuro) y sus fondos suaves.

### Semánticos (`TcColors`)

| Token | Claro | Oscuro | Uso |
|---|---|---|---|
| `background` | asfalto 25 | asfalto 950 | Fondo de pantalla |
| `surface` | blanco | asfalto 850 | Paneles y tarjetas |
| `surfaceSunken` | asfalto 50 | asfalto 800 | Campos, acciones rápidas |
| `surfaceInverse` | asfalto 900 | asfalto 50 | Tarjeta de ganancias, toasts |
| `border` / `borderStrong` | 100 / 200 | 700 / 600 | Divisores / contornos |
| `textPrimary` | asfalto 900 | asfalto 50 | Texto principal |
| `textSecondary` | asfalto 500 | asfalto 300 | Texto de apoyo |
| `textTertiary` | asfalto 400 | asfalto 400 | Deshabilitado, íconos (no texto clave) |
| `brand` / `brandPressed` | amarillo 500 / 600 | 500 / 400 | Acción principal, taxi |
| `brandSoft` | amarillo 50 | amarillo 900 | Opción seleccionada |
| `brandText` | amarillo 800 | amarillo 300 | Texto "amarillo" legible |
| `onBrand` | asfalto 900 | asfalto 900 | Texto/íconos sobre amarillo |
| `success` / `danger` / `info` (+ `Soft`) | verde/rojo/azul | claros | Estados con texto o ícono |
| `mapRoute` / `mapRouteCasing` | negro / amarillo | amarillo / negro | Ruta en el mapa |
| `mapPickup` / `mapDestination` | verde / negro | verde / amarillo | Pines |

### Contraste verificado (WCAG 2.1)

| Par | Contraste | Resultado |
|---|---|---|
| `onBrand` sobre `brand` | 11.6:1 | AAA |
| `textPrimary` sobre `background` | 17.3:1 | AAA |
| `textSecondary` sobre `background` | 5.4:1 | AA |
| `textSecondary` sobre `surface` | 5.6:1 | AA |
| `textTertiary` sobre `surface` | 3.5:1 | Solo texto grande / íconos |
| blanco sobre `danger` (claro) | 6.5:1 | AA |
| blanco sobre `success` (claro) | ≥ 4.5:1 | AA (se oscureció de `#1E8E4E`) |
| amarillo sobre blanco | 1.5:1 | **Prohibido para texto** |

## Tipografía

**Lexend** para títulos, botones y cifras (geométrica, muy legible) + **Source Sans 3** para texto. Escala con base 16 y razón ≈ 1.2 (tercera menor).

| Token | Tamaño / alto de línea | Peso | Fuente | Uso |
|---|---|---|---|---|
| `display` | 40 / 44 | 700 | Lexend | Precio en la oferta y al cobrar |
| `h1` | 32 / 38 | 700 | Lexend | "¿A dónde vas?" |
| `h2` | 26 / 32 | 600 | Lexend | Título de cada panel |
| `h3` | 22 / 28 | 600 | Lexend | Placas, títulos de diálogo |
| `title` | 18 / 24 | 600 | Lexend | Nombres, lugares, opciones |
| `bodyL` | 17 / 26 | 400 | Source Sans 3 | Texto principal y campos |
| `body` | 16 / 24 | 400 | Source Sans 3 | Texto general |
| `bodyS` | 14 / 20 | 400 | Source Sans 3 | Direcciones, detalles |
| `button` | 17 / 22 | 600 | Lexend | Botones |
| `label` | 14 / 20 | 600 | Source Sans 3 | Píldoras, chips |
| `caption` | 12 / 16 | 500 | Source Sans 3 | Leyendas (nunca info clave) |

- Precios, tiempos y contadores usan `TcTypography.numeric(...)` (dígitos tabulares) para que no "bailen".
- Mínimo de lectura: 14. Texto que se lee mientras se maneja: 17 o más.
- Uso: `context.type.h2`.

## Espaciado, radios, tamaños y elevación

| Token | Valores |
|---|---|
| `TcSpace` | 4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 48 (`gutter` = 20) |
| `TcRadius` | `sm` 8 · `md` 12 (controles) · `lg` 20 (tarjetas) · `xl` 28 (panel) · `pill` |
| `TcSize` | `touch` 48 · `button` 56 · `buttonCompact` 44 · íconos 16/24/32 · avatares 40/56/72 |
| `TcElevation` | `low` (pines), `mid` (botones flotantes), `high` (paneles) |

## Movimiento

| Token | Valor | Uso |
|---|---|---|
| `TcMotion.fast` | 150 ms | Presionar, cambios pequeños, salir |
| `TcMotion.base` | 250 ms | Cambiar panel, seleccionar |
| `TcMotion.slow` | 350 ms | Oferta que entra |
| `enter` / `exit` | easeOutCubic / easeInCubic | Entrar más suave, salir más rápido |

- Lo tocable se encoge a 0.97 al presionar (`TcPressable`), sin mover el layout.
- `TcMotion.of(context, d)` devuelve 0 si la persona pidió reducir movimiento; los radares y halos se quedan quietos.

## Íconos

Material Symbols redondeados (`Icons.*_rounded`), una sola familia. Tamaños 16/24/32. Ningún emoji como ícono.

## Componentes

| Componente | Archivo | Para qué |
|---|---|---|
| TcButton | [tc_button.md](components/tc_button.md) | Acciones (5 variantes, 2 tamaños, cargando) |
| TcIconButton | [tc_icon_button.md](components/tc_icon_button.md) | Botón redondo de ícono sobre el mapa |
| TcPressable | [tc_pressable.md](components/tc_pressable.md) | Respuesta al toque |
| TcBottomPanel | [tc_bottom_panel.md](components/tc_bottom_panel.md) | Panel inferior que cambia por paso |
| TcAvatar | [tc_avatar.md](components/tc_avatar.md) | Iniciales con color |
| TcRating | [tc_rating.md](components/tc_rating.md) | ★ 4.9 · 1,240 viajes |
| TcPersonRow | [tc_person_row.md](components/tc_person_row.md) | Taxista o pasajero en una fila |
| TcPrice | [tc_price.md](components/tc_price.md) | Montos |
| TcStatusPill | [tc_status_pill.md](components/tc_status_pill.md) | Estados ("En camino") |
| TcRouteSummary | [tc_route_summary.md](components/tc_route_summary.md) | Origen → destino |
| TcPlaceTile | [tc_place_tile.md](components/tc_place_tile.md) | Lugar en listas |
| TcVehicleCard | [tc_vehicle_card.md](components/tc_vehicle_card.md) | Auto, placas y número económico |
| TcQuickAction | [tc_quick_action.md](components/tc_quick_action.md) | Llamar / Mensaje / Compartir |
| TcCountdownRing | [tc_countdown_ring.md](components/tc_countdown_ring.md) | 15 s para aceptar |
| TcOnlineSwitch | [tc_online_switch.md](components/tc_online_switch.md) | Conectarme / Desconectarme |
| TcStarPicker | [tc_star_picker.md](components/tc_star_picker.md) | Calificar 1–5 |
| TcRadar | [tc_radar.md](components/tc_radar.md) | Buscando taxi / viajes |
| showTcConfirm | [tc_confirm_dialog.md](components/tc_confirm_dialog.md) | Confirmar cancelación |
| showTcToast | [tc_toast.md](components/tc_toast.md) | Avisos breves |

Componentes del mapa (en `tc_maps`): [map.md](components/map.md).
