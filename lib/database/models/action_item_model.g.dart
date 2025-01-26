// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActionItemModelAdapter extends TypeAdapter<ActionItemModel> {
  @override
  final int typeId = 3;

  @override
  ActionItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActionItemModel(
      fields[2] as String,
      fields[3] as int,
      fields[1] as int,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, ActionItemModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderIndex)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.actionType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
