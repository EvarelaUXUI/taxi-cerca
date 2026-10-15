import 'package:flutter/material.dart';

import 'palette.dart';

/// Capa 2 · Colores semánticos (por propósito). Uno para claro y otro para oscuro.
///
/// Reglas de contraste (WCAG AA, verificadas):
/// - `textPrimary` y `textSecondary` ≥ 4.5:1 sobre `background` y `surface`.
/// - `textTertiary` (≈3.5:1) solo para texto de apoyo grande, íconos o deshabilitado.
/// - Sobre `brand` siempre va `onBrand` (negro asfalto, 11.6:1). El amarillo
///   **nunca** es color de texto sobre blanco (1.5:1); para eso está `brandText`.
@immutable
class TcColors extends ThemeExtension<TcColors> {
  const TcColors({
    required this.background,
    required this.surface,
    required this.surfaceSunken,
    required this.surfaceInverse,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textInverse,
    required this.brand,
    required this.brandPressed,
    required this.brandSoft,
    required this.brandText,
    required this.onBrand,
    required this.success,
    required this.successSoft,
    required this.danger,
    required this.dangerSoft,
    required this.info,
    required this.infoSoft,
    required this.onStatus,
    required this.scrim,
    required this.shadow,
    required this.mapRoute,
    required this.mapRouteCasing,
    required this.mapPickup,
    required this.mapDestination,
  });

  final Color background;
  final Color surface;
  final Color surfaceSunken;
  final Color surfaceInverse;
  final Color border;
  final Color borderStrong;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textInverse;

  final Color brand;
  final Color brandPressed;
  final Color brandSoft;
  final Color brandText;
  final Color onBrand;

  final Color success;
  final Color successSoft;
  final Color danger;
  final Color dangerSoft;
  final Color info;
  final Color infoSoft;

  /// Texto e íconos sobre `success`, `danger` o `info` sólidos.
  final Color onStatus;

  final Color scrim;
  final Color shadow;

  final Color mapRoute;
  final Color mapRouteCasing;
  final Color mapPickup;
  final Color mapDestination;

  static const light = TcColors(
    background: TcPalette.asphalt25,
    surface: TcPalette.white,
    surfaceSunken: TcPalette.asphalt50,
    surfaceInverse: TcPalette.asphalt900,
    border: TcPalette.asphalt100,
    borderStrong: TcPalette.asphalt200,
    textPrimary: TcPalette.asphalt900,
    textSecondary: TcPalette.asphalt500,
    textTertiary: TcPalette.asphalt400,
    textInverse: TcPalette.white,
    brand: TcPalette.yellow500,
    brandPressed: TcPalette.yellow600,
    brandSoft: TcPalette.yellow50,
    brandText: TcPalette.yellow800,
    onBrand: TcPalette.asphalt900,
    success: TcPalette.green700,
    successSoft: TcPalette.green50,
    danger: TcPalette.red700,
    dangerSoft: TcPalette.red50,
    info: TcPalette.blue600,
    infoSoft: TcPalette.blue50,
    onStatus: TcPalette.white,
    scrim: Color(0x99000000),
    shadow: Color(0x24171614),
    mapRoute: TcPalette.asphalt900,
    mapRouteCasing: TcPalette.yellow500,
    mapPickup: TcPalette.green700,
    mapDestination: TcPalette.asphalt900,
  );

  static const dark = TcColors(
    background: TcPalette.asphalt950,
    surface: TcPalette.asphalt850,
    surfaceSunken: TcPalette.asphalt800,
    surfaceInverse: TcPalette.asphalt50,
    border: TcPalette.asphalt700,
    borderStrong: TcPalette.asphalt600,
    textPrimary: TcPalette.asphalt50,
    textSecondary: TcPalette.asphalt300,
    textTertiary: TcPalette.asphalt400,
    textInverse: TcPalette.asphalt900,
    brand: TcPalette.yellow500,
    brandPressed: TcPalette.yellow400,
    brandSoft: TcPalette.yellow900,
    brandText: TcPalette.yellow300,
    onBrand: TcPalette.asphalt900,
    success: TcPalette.green400,
    successSoft: TcPalette.green900,
    danger: TcPalette.red400,
    dangerSoft: TcPalette.red900,
    info: TcPalette.blue400,
    infoSoft: TcPalette.blue900,
    onStatus: TcPalette.asphalt950,
    scrim: Color(0xB3000000),
    shadow: Color(0x66000000),
    mapRoute: TcPalette.yellow500,
    mapRouteCasing: TcPalette.asphalt950,
    mapPickup: TcPalette.green400,
    mapDestination: TcPalette.yellow500,
  );

  @override
  TcColors copyWith() => this;

  @override
  TcColors lerp(ThemeExtension<TcColors>? other, double t) {
    if (other is! TcColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return TcColors(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceSunken: l(surfaceSunken, other.surfaceSunken),
      surfaceInverse: l(surfaceInverse, other.surfaceInverse),
      border: l(border, other.border),
      borderStrong: l(borderStrong, other.borderStrong),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textTertiary: l(textTertiary, other.textTertiary),
      textInverse: l(textInverse, other.textInverse),
      brand: l(brand, other.brand),
      brandPressed: l(brandPressed, other.brandPressed),
      brandSoft: l(brandSoft, other.brandSoft),
      brandText: l(brandText, other.brandText),
      onBrand: l(onBrand, other.onBrand),
      success: l(success, other.success),
      successSoft: l(successSoft, other.successSoft),
      danger: l(danger, other.danger),
      dangerSoft: l(dangerSoft, other.dangerSoft),
      info: l(info, other.info),
      infoSoft: l(infoSoft, other.infoSoft),
      onStatus: l(onStatus, other.onStatus),
      scrim: l(scrim, other.scrim),
      shadow: l(shadow, other.shadow),
      mapRoute: l(mapRoute, other.mapRoute),
      mapRouteCasing: l(mapRouteCasing, other.mapRouteCasing),
      mapPickup: l(mapPickup, other.mapPickup),
      mapDestination: l(mapDestination, other.mapDestination),
    );
  }
}
