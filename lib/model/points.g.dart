// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PointsAdapter extends TypeAdapter<Points> {
  @override
  final int typeId = 1;

  @override
  Points read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Points(
      fields[0] as double,
      fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Points obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.alphabetPercent)
      ..writeByte(1)
      ..write(obj.practicePercent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
