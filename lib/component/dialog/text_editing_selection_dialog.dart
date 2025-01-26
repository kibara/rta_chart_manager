import 'package:flutter/material.dart';

/// 参考
/// https://zenn.dev/pressedkonbu/books/flutter-reverse-lookup-dictionary/viewer/016-input-text-on-dialog

// 状態を持ったダイアログ
class TextEditingSelectionDialog extends StatefulWidget {
  const TextEditingSelectionDialog({
    super.key,
    this.text,
    required this.selection,
  });

  final String? text;
  final List<DropdownMenuItem> selection;

  @override
  State<TextEditingSelectionDialog> createState() =>
      _TextEditingSelectionDialogState();
}

class _TextEditingSelectionDialogState
    extends State<TextEditingSelectionDialog> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  late int selectedItem;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // TextFormFieldに初期値を代入する
    controller.text = widget.text ?? '';
    selectedItem = widget.selection.first.value;
    focusNode.addListener(
      () {
        // フォーカスが当たったときに文字列が選択された状態にする
        if (focusNode.hasFocus) {
          controller.selection = TextSelection(
              baseOffset: 0, extentOffset: controller.text.length);
        }
      },
    );
  }

  // List<DropdownMenuItem> _convertListToMenuItem() {
  //   return widget.selection
  //       .map((i) => DropdownMenuItem(value: i, child: Text(i.name)))
  //       .toList();
  // }

  void _onSelectionChanged(int? value) {
    if (value != null) {
      setState(() {
        selectedItem = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField(
            isExpanded: true,
            items: widget.selection,
            onChanged: (value) => _onSelectionChanged(value),
            value: selectedItem,
            decoration: InputDecoration(labelText: '種別'),
          ),
          TextFormField(
            autofocus: true,
            focusNode: focusNode,
            controller: controller,
            decoration: InputDecoration(labelText: 'やること'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // String itemName = selectedItem != null ? selectedItem!.name : '';
            Navigator.of(context)
                .pop([controller.text, selectedItem.toString()]);
          },
          child: const Text('完了'),
        )
      ],
    );
  }
}
