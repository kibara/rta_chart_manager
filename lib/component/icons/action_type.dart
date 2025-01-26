import 'package:flutter/material.dart';

enum ActionType {
  section(99, 'セクション'),
  buy(1, '買う'),
  sell(2, '売る'),
  trash(3, '捨てる'),
  move(4, '移動'),
  buttle(5, '戦闘'),
  escape(6, '逃走'),
  equip(7, '装備'),
  pick(8, '宝箱'),
  recovery(9, '回復'),
  damage(10, 'HP調整'),
  event(11, 'イベント起動'),
  talk(12, '会話'),
  smith(13, '鍛治'),
  grows(14, '育成'),
  party(15, '編成'),
  ;

  const ActionType(this.id, this.displayName);

  final int id;
  final String displayName;

  static List<DropdownMenuItem> getDropdownMenuItemList() {
    return ActionType.values
        .map((v) => DropdownMenuItem(
            value: v.id,
            child: Row(
              spacing: 8.0,
              children: [
                ActionType.getIcon(v),
                Text(v.displayName),
              ],
            )))
        .toList();
  }

  static Icon getIconByInt(int actionType) {
    return getIcon(
        ActionType.values.where((v) => v.id == actionType).firstOrNull ??
            ActionType.section);
  }

  static Icon getIcon(ActionType actionType) {
    switch (actionType) {
      case section:
        return Icon(Icons.folder, color: Colors.black);

      case buy:
        return Icon(Icons.shopping_cart, color: Colors.greenAccent);
      case sell:
        return Icon(Icons.shopping_cart, color: Colors.redAccent);
      case trash:
        return Icon(Icons.delete, color: Colors.grey);
      case move:
        return Icon(Icons.flight, color: Colors.lightBlueAccent);
      case buttle:
        return Icon(Icons.pets, color: Colors.redAccent);
      case escape:
        return Icon(Icons.directions_run, color: Colors.redAccent);
      case equip:
        return Icon(Icons.construction, color: Colors.teal);
      case pick:
        return Icon(Icons.search, color: Colors.amberAccent);
      case recovery:
        return Icon(Icons.favorite, color: Colors.greenAccent);
      case damage:
        return Icon(Icons.favorite, color: Colors.redAccent);
      case event:
        return Icon(Icons.event, color: Colors.blueGrey);
      case talk:
        return Icon(Icons.record_voice_over, color: Colors.brown);
      case smith:
        return Icon(Icons.gavel, color: Colors.brown);
      case grows:
        return Icon(Icons.upgrade, color: Colors.greenAccent);
      case party:
        return Icon(Icons.group_add, color: Colors.greenAccent);
    }
  }
}
