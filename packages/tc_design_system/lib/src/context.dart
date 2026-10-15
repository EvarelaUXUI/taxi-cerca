import 'package:flutter/material.dart';

import 'tokens/colors.dart';
import 'tokens/typography.dart';

/// Atajos: `context.colors.brand`, `context.type.h2`.
extension TcContext on BuildContext {
  TcColors get colors => Theme.of(this).extension<TcColors>() ?? TcColors.light;
  TcTypography get type => Theme.of(this).extension<TcTypography>() ?? TcTypography.withFamilies();
}
