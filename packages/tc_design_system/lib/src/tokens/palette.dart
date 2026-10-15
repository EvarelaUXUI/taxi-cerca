import 'package:flutter/painting.dart';

/// Capa 1 · Primitivos. Valores crudos de color.
///
/// **No se usan directo en pantallas ni componentes**: pasan siempre por
/// [TcColors] (capa semántica) para que el modo oscuro y los cambios de marca
/// se hagan en un solo lugar.
abstract final class TcPalette {
  // Amarillo taxi (marca). 500 es el color de marca.
  static const yellow50 = Color(0xFFFFF8DB);
  static const yellow100 = Color(0xFFFFEFB0);
  static const yellow200 = Color(0xFFFFE27A);
  static const yellow300 = Color(0xFFFFD64A);
  static const yellow400 = Color(0xFFFFCC1F);
  static const yellow500 = Color(0xFFFFC800);
  static const yellow600 = Color(0xFFE0AE00);
  static const yellow700 = Color(0xFFA88200);
  static const yellow800 = Color(0xFF7A5E00);
  static const yellow900 = Color(0xFF3D2F00);

  // Asfalto: neutros con un toque cálido para que convivan con el amarillo.
  static const white = Color(0xFFFFFFFF);
  static const asphalt25 = Color(0xFFFAFAF7);
  static const asphalt50 = Color(0xFFF4F3EF);
  static const asphalt100 = Color(0xFFE9E7E1);
  static const asphalt200 = Color(0xFFD6D3CB);
  static const asphalt300 = Color(0xFFB5B1A7);
  static const asphalt400 = Color(0xFF8C887E);
  static const asphalt500 = Color(0xFF6B675E);
  static const asphalt600 = Color(0xFF4F4C45);
  static const asphalt700 = Color(0xFF36342F);
  static const asphalt800 = Color(0xFF24231F);
  static const asphalt850 = Color(0xFF1C1B18);
  static const asphalt900 = Color(0xFF171614);
  static const asphalt950 = Color(0xFF0E0D0C);

  // Estados.
  static const green50 = Color(0xFFE6F4EC);
  static const green400 = Color(0xFF4CC27E);
  static const green700 = Color(0xFF187A42);
  static const green900 = Color(0xFF0D3B21);
  static const red50 = Color(0xFFFDECEA);
  static const red400 = Color(0xFFFF6B5E);
  static const red700 = Color(0xFFB3261E);
  static const red900 = Color(0xFF4A120E);
  static const blue50 = Color(0xFFE8F0FE);
  static const blue400 = Color(0xFF6EA8FF);
  static const blue600 = Color(0xFF1F6FEB);
  static const blue900 = Color(0xFF0B2A5B);
}
