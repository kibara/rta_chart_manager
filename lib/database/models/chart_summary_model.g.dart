// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_summary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChartSummaryModelAdapter extends TypeAdapter<ChartSummaryModel> {
  @override
  final int typeId = 1;

  @override
  ChartSummaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartSummaryModel(
      fields[3] as String,
      fields[2] as String,
      fields[1] as int,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, ChartSummaryModel obj) {
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
      other is ChartSummaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
