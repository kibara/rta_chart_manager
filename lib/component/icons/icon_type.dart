import 'package:flutter/material.dart';

class IconType {
  static const int buy = 1; // 買う
  static const int sell = 2; // 売る
  static const int trash = 3; // 捨てる
  static const int move = 4; // 移動
  static const int buttle = 5; // 戦う
  static const int escape = 6; // 逃げる
  static const int equip = 7; // 装備する
  static const int pick = 8; // 拾う
  static const int recovery = 9; // 回復する
  static const int damage = 10; // ダメージを喰らう
  static const int event = 11; // イベントを起動する
  static const int talk = 12; // イベントを起動する
  static const int smith = 13; // 鍛治
  static const int grows = 14; // 育てる
  static const int party = 15; // 編成

  static Icon getIcon(int iconType) {
    switch (iconType) {
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
      default:
        return Icon(Icons.abc);
    }
  }
}
