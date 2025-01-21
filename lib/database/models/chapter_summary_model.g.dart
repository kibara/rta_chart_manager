// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_summary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChapterSummaryModelAdapter extends TypeAdapter<ChapterSummaryModel> {
  @override
  final int typeId = 1;

  @override
  ChapterSummaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChapterSummaryModel(
      fields[3] as String,
      fields[2] as String,
      fields[1] as int,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, ChapterSummaryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.chartId)
      ..writeByte(1)
      ..write(obj.orderIndex)
      ..writeByte(2)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterSummaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
