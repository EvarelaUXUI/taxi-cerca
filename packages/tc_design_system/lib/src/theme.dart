import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens/colors.dart';
import 'tokens/dimens.dart';
import 'tokens/typography.dart';

/// Construye el `ThemeData` de Taxi Cerca a partir de los tokens.
abstract final class TcTheme {
  /// En pruebas se pasa `useGoogleFonts: false` para no ir a la red.
  static ThemeData light({bool useGoogleFonts = true}) =>
      _build(TcColors.light, Brightness.light, useGoogleFonts);

  static ThemeData dark({bool useGoogleFonts = true}) =>
      _build(TcColors.dark, Brightness.dark, useGoogleFonts);

  static ThemeData _build(TcColors c, Brightness brightness, bool fonts) {
    final type = TcTypography.withFamilies(
      heading: fonts ? GoogleFonts.lexend().fontFamily : null,
      text: fonts ? GoogleFonts.sourceSans3().fontFamily : null,
    );
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.brand,
      onPrimary: c.onBrand,
      secondary: c.surfaceInverse,
      onSecondary: c.textInverse,
      error: c.danger,
      onError: c.onStatus,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      outline: c.borderStrong,
      outlineVariant: c.border,
      surfaceContainerHighest: c.surfaceSunken,
      inverseSurface: c.surfaceInverse,
      onInverseSurface: c.textInverse,
      shadow: c.shadow,
      scrim: c.scrim,
    );
    TextStyle on(TextStyle s, Color color) => s.copyWith(color: color);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      fontFamily: type.body.fontFamily,
      extensions: [c, type],
      textTheme: TextTheme(
        displayLarge: on(type.display, c.textPrimary),
        headlineLarge: on(type.h1, c.textPrimary),
        headlineMedium: on(type.h2, c.textPrimary),
        headlineSmall: on(type.h3, c.textPrimary),
        titleLarge: on(type.title, c.textPrimary),
        titleMedium: on(type.title, c.textPrimary),
        bodyLarge: on(type.bodyL, c.textPrimary),
        bodyMedium: on(type.body, c.textPrimary),
        bodySmall: on(type.bodyS, c.textSecondary),
        labelLarge: on(type.button, c.textPrimary),
        labelMedium: on(type.label, c.textPrimary),
        labelSmall: on(type.caption, c.textSecondary),
      ),
      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
      iconTheme: IconThemeData(color: c.textPrimary, size: TcSize.iconMd),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.surfaceInverse,
        contentTextStyle: on(type.body, c.textInverse),
        shape: const RoundedRectangleBorder(borderRadius: TcRadius.control),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surfaceSunken,
        hintStyle: on(type.bodyL, c.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: TcSpace.x4, vertical: TcSpace.x4),
        border: const OutlineInputBorder(borderRadius: TcRadius.control, borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: TcRadius.control,
          borderSide: BorderSide(color: c.textPrimary, width: 2),
        ),
      ),
      focusColor: c.brand.withValues(alpha: 0.35),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
