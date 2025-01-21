// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_detail_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChapterDetailModelAdapter extends TypeAdapter<ChapterDetailModel> {
  @override
  final int typeId = 2;

  @override
  ChapterDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChapterDetailModel(
      fields[3] as String,
      fields[6] as String,
      fields[1] as int,
    )
      ..id = fields[0] as String
      ..estimateTime = fields[4] as Duration
      ..actionItems = (fields[5] as List).cast<ActionItemModel>();
  }

  @override
  void write(BinaryWriter writer, ChapterDetailModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.chartId)
      ..writeByte(6)
      ..write(obj.summaryId)
      ..writeByte(1)
      ..write(obj.orderIndex)
      ..writeByte(4)
      ..write(obj.estimateTime)
      ..writeByte(5)
      ..write(obj.actionItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
