/// Formatos de texto para México. Los montos siempre se muestran como `$1,250`.
abstract final class Fmt {
  static String money(num amount) {
    final digits = amount.round().abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return '${amount < 0 ? '-' : ''}\$$buffer';
  }

  static String moneyRange(num min, num max) => '${money(min)}–${money(max)}';

  /// "3 min", "1 h 05 min". Nunca muestra 0 min.
  static String minutes(double seconds) {
    final total = (seconds / 60).ceil().clamp(1, 24 * 60);
    if (total < 60) return '$total min';
    final h = total ~/ 60;
    final m = (total % 60).toString().padLeft(2, '0');
    return '$h h $m min';
  }

  /// "350 m", "2.4 km".
  static String distance(double meters) {
    if (meters < 950) return '${(meters / 50).round() * 50} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  static String rating(double value) => value.toStringAsFixed(value >= 4.95 ? 1 : 2).replaceFirst(RegExp(r'0$'), '');

  /// Hora local "14:05" a partir de ahora más [seconds].
  static String clockIn(double seconds, {DateTime? now}) {
    final t = (now ?? DateTime.now()).add(Duration(seconds: seconds.round()));
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }
}
