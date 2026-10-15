import 'package:flutter/material.dart';

/// Capa 2 · Escala tipográfica móvil.
///
/// Base 16, razón ≈ 1.2 (tercera menor). Títulos y cifras en **Lexend**
/// (geométrica, muy legible en pantallas chicas); texto en **Source Sans 3**.
///
/// | Token    | Tamaño/Alto | Peso | Fuente  | Uso                                  |
/// |----------|-------------|------|---------|--------------------------------------|
/// | display  | 40/44       | 700  | Lexend  | Precio en la oferta, cifras héroe    |
/// | h1       | 32/38       | 700  | Lexend  | Título de pantalla                   |
/// | h2       | 26/32       | 600  | Lexend  | Título de hoja o tarjeta principal   |
/// | h3       | 22/28       | 600  | Lexend  | Subtítulo, nombre del taxista        |
/// | title    | 18/24       | 600  | Lexend  | Títulos de lista y de tarjeta        |
/// | bodyL    | 17/26       | 400  | Source  | Texto principal de lectura           |
/// | body     | 16/24       | 400  | Source  | Texto general                        |
/// | bodyS    | 14/20       | 400  | Source  | Texto de apoyo, direcciones          |
/// | button   | 17/22       | 600  | Lexend  | Botones                              |
/// | label    | 14/20       | 600  | Source  | Etiquetas, chips, pestañas           |
/// | caption  | 12/16       | 500  | Source  | Leyendas, metadatos (nunca texto clave) |
///
/// Las cifras (precios, tiempos, distancias) usan dígitos tabulares con [numeric].
@immutable
class TcTypography extends ThemeExtension<TcTypography> {
  const TcTypography({
    required this.display,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.title,
    required this.bodyL,
    required this.body,
    required this.bodyS,
    required this.button,
    required this.label,
    required this.caption,
  });

  /// Crea la escala con las familias dadas (o la del sistema si son `null`).
  factory TcTypography.withFamilies({String? heading, String? text}) {
    TextStyle h(double size, double height, FontWeight w, [double tracking = 0]) => TextStyle(
          fontFamily: heading,
          fontSize: size,
          height: height / size,
          fontWeight: w,
          letterSpacing: tracking,
        );
    TextStyle t(double size, double height, FontWeight w, [double tracking = 0]) => TextStyle(
          fontFamily: text,
          fontSize: size,
          height: height / size,
          fontWeight: w,
          letterSpacing: tracking,
        );
    return TcTypography(
      display: h(40, 44, FontWeight.w700, -0.8),
      h1: h(32, 38, FontWeight.w700, -0.5),
      h2: h(26, 32, FontWeight.w600, -0.3),
      h3: h(22, 28, FontWeight.w600, -0.2),
      title: h(18, 24, FontWeight.w600),
      bodyL: t(17, 26, FontWeight.w400),
      body: t(16, 24, FontWeight.w400),
      bodyS: t(14, 20, FontWeight.w400),
      button: h(17, 22, FontWeight.w600),
      label: t(14, 20, FontWeight.w600, 0.1),
      caption: t(12, 16, FontWeight.w500, 0.2),
    );
  }

  final TextStyle display;
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle title;
  final TextStyle bodyL;
  final TextStyle body;
  final TextStyle bodyS;
  final TextStyle button;
  final TextStyle label;
  final TextStyle caption;

  /// Variante con dígitos tabulares, para que los números no "bailen".
  static TextStyle numeric(TextStyle style) =>
      style.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  @override
  TcTypography copyWith() => this;

  @override
  TcTypography lerp(ThemeExtension<TcTypography>? other, double t) => t < 0.5 ? this : other as TcTypography;
}
