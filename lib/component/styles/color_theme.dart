import 'package:flutter/material.dart';

class ColorTheme {
  /// 背景色のベースカラー
  static Color bgBaseColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  /// プライマリカラー
  static Color primaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.inversePrimary;
  }

  /// セカンダリカラー
  static Color secondaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primaryFixedDim;
  }

  /// 文字のベースカラー
  static Color baseTextColor() {
    return Colors.black;
  }
}
