// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_play_time_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChartPlayTimeModelAdapter extends TypeAdapter<ChartPlayTimeModel> {
  @override
  final int typeId = 5;

  @override
  ChartPlayTimeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartPlayTimeModel(
      fields[1] as String,
      fields[2] as String,
    )
      ..id = fields[0] as String
      ..playTime = fields[3] as Duration
      ..lapTimes = (fields[4] as Map).cast<String, Duration>()
      ..startDateTime = fields[5] as DateTime;
  }

  @override
  void write(BinaryWriter writer, ChartPlayTimeModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.chartId)
      ..writeByte(2)
      ..write(obj.playTitle)
      ..writeByte(3)
      ..write(obj.playTime)
      ..writeByte(4)
      ..write(obj.lapTimes)
      ..writeByte(5)
      ..write(obj.startDateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartPlayTimeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
