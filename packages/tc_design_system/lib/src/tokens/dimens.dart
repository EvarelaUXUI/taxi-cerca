import 'package:flutter/widgets.dart';

/// Espaciado en múltiplos de 4.
abstract final class TcSpace {
  static const x1 = 4.0;
  static const x2 = 8.0;
  static const x3 = 12.0;
  static const x4 = 16.0;
  static const x5 = 20.0;
  static const x6 = 24.0;
  static const x8 = 32.0;
  static const x10 = 40.0;
  static const x12 = 48.0;

  /// Margen lateral de pantalla.
  static const gutter = x5;
}

abstract final class TcRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 20.0;
  static const xl = 28.0;
  static const pill = 999.0;

  static const card = BorderRadius.all(Radius.circular(lg));
  static const control = BorderRadius.all(Radius.circular(md));
  static const sheet = BorderRadius.vertical(top: Radius.circular(xl));
}

/// Tamaños mínimos. Toda área táctil mide al menos [touch].
abstract final class TcSize {
  static const touch = 48.0;
  static const button = 56.0;
  static const buttonCompact = 44.0;
  static const iconSm = 16.0;
  static const iconMd = 24.0;
  static const iconLg = 32.0;
  static const avatarSm = 40.0;
  static const avatarMd = 56.0;
  static const avatarLg = 72.0;
}

/// Movimiento. Salir es más rápido que entrar.
abstract final class TcMotion {
  static const fast = Duration(milliseconds: 150);
  static const base = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 350);
  static const enter = Curves.easeOutCubic;
  static const exit = Curves.easeInCubic;
  static const emphasized = Curves.easeOutBack;

  /// `true` si el usuario pidió reducir animaciones.
  static bool reduced(BuildContext context) => MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// [d] o cero si hay que reducir movimiento.
  static Duration of(BuildContext context, Duration d) => reduced(context) ? Duration.zero : d;
}

/// Elevaciones: sombras suaves y consistentes.
abstract final class TcElevation {
  static List<BoxShadow> low(Color shadow) => [
        BoxShadow(color: shadow, blurRadius: 8, offset: const Offset(0, 2)),
      ];
  static List<BoxShadow> mid(Color shadow) => [
        BoxShadow(color: shadow, blurRadius: 24, offset: const Offset(0, 8)),
      ];
  static List<BoxShadow> high(Color shadow) => [
        BoxShadow(color: shadow, blurRadius: 40, offset: const Offset(0, 16)),
      ];
}
