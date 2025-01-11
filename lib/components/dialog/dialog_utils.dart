import 'package:flutter/material.dart';

import 'text_editing_dialog.dart';

/// 参考
/// https://zenn.dev/pressedkonbu/books/flutter-reverse-lookup-dictionary/viewer/016-input-text-on-dialog

class DialogUtils {
  DialogUtils._();

  /// タイトルのみを表示するシンプルなダイアログを表示する
  static Future<void> showOnlyTitleDialog(
    BuildContext context,
    String title,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
        );
      },
    );
  }

  /// 入力した文字列を返すダイアログを表示する
  static Future<String?> showEditingDialog(
    BuildContext context,
    String text,
  ) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return TextEditingDialog(text: text);
      },
    );
  }
}
