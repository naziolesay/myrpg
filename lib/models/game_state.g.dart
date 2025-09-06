// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameStateAdapter extends TypeAdapter<GameState> {
  @override
  final int typeId = 5;

  @override
  GameState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameState(
      currentLocation: fields[0] as GameLocation,
      lastSaveTime: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GameState obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.currentLocation)
      ..writeByte(1)
      ..write(obj.lastSaveTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GameLocationAdapter extends TypeAdapter<GameLocation> {
  @override
  final int typeId = 4;

  @override
  GameLocation read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GameLocation.city;
      case 1:
        return GameLocation.tavern;
      case 2:
        return GameLocation.forest;
      default:
        return GameLocation.city;
    }
  }

  @override
  void write(BinaryWriter writer, GameLocation obj) {
    switch (obj) {
      case GameLocation.city:
        writer.writeByte(0);
        break;
      case GameLocation.tavern:
        writer.writeByte(1);
        break;
      case GameLocation.forest:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
