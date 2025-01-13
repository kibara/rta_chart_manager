// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_summary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChartSummaryModelAdapter extends TypeAdapter<ChartSummaryModel> {
  @override
  final int typeId = 0;

  @override
  ChartSummaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartSummaryModel(
      fields[2] as String,
    )
      ..id = fields[0] as String
      ..orderIndex = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, ChartSummaryModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
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
      other is ChartSummaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
