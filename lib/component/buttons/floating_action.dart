import 'package:flutter/material.dart';
import 'package:rta_chart_manager/component/styles/color_theme.dart';

class FloatingAction {
  static void _defaultFunction() {}

  /// 何かを追加するフローティングアクションボタン
  static FloatingActionButton addButton(
    BuildContext context, {
    VoidCallback onPressed = _defaultFunction,
    String tooltip = 'Add',
  }) {
    return FloatingActionButton(
      backgroundColor: ColorTheme.primaryColor(context),
      foregroundColor: ColorTheme.secondaryColor(context),
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(
        Icons.add,
        color: ColorTheme.baseTextColor(),
      ),
    );
  }
}
