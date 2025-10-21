// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BinModelAdapter extends TypeAdapter<BinModel> {
  @override
  final int typeId = 1;

  @override
  BinModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BinModel(
      id: fields[0] as String,
      name: fields[1] as String,
      location: fields[2] as String,
      fillLevel: fields[3] as double,
      status: fields[4] as BinStatus,
      lastUpdated: fields[5] as DateTime,
      history: (fields[6] as List).cast<HistoryEntry>(),
    );
  }

  @override
  void write(BinaryWriter writer, BinModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.fillLevel)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.lastUpdated)
      ..writeByte(6)
      ..write(obj.history);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BinModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HistoryEntryAdapter extends TypeAdapter<HistoryEntry> {
  @override
  final int typeId = 2;

  @override
  HistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryEntry(
      timestamp: fields[0] as DateTime,
      fillLevel: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.fillLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BinStatusAdapter extends TypeAdapter<BinStatus> {
  @override
  final int typeId = 0;

  @override
  BinStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BinStatus.normal;
      case 1:
        return BinStatus.warning;
      case 2:
        return BinStatus.full;
      default:
        return BinStatus.normal;
    }
  }

  @override
  void write(BinaryWriter writer, BinStatus obj) {
    switch (obj) {
      case BinStatus.normal:
        writer.writeByte(0);
        break;
      case BinStatus.warning:
        writer.writeByte(1);
        break;
      case BinStatus.full:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BinStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
