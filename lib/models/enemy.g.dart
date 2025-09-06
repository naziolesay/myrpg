// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enemy.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnemyAdapter extends TypeAdapter<Enemy> {
  @override
  final int typeId = 7;

  @override
  Enemy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Enemy(
      type: fields[0] as EnemyType,
      name: fields[1] as String,
      maxHealth: fields[2] as int,
      damage: fields[4] as int,
      experienceReward: fields[5] as int,
      goldReward: fields[6] as int,
    )..currentHealth = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, Enemy obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.maxHealth)
      ..writeByte(3)
      ..write(obj.currentHealth)
      ..writeByte(4)
      ..write(obj.damage)
      ..writeByte(5)
      ..write(obj.experienceReward)
      ..writeByte(6)
      ..write(obj.goldReward);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnemyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EnemyTypeAdapter extends TypeAdapter<EnemyType> {
  @override
  final int typeId = 6;

  @override
  EnemyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EnemyType.goblin;
      case 1:
        return EnemyType.orc;
      case 2:
        return EnemyType.wolf;
      case 3:
        return EnemyType.bandit;
      case 4:
        return EnemyType.skeleton;
      default:
        return EnemyType.goblin;
    }
  }

  @override
  void write(BinaryWriter writer, EnemyType obj) {
    switch (obj) {
      case EnemyType.goblin:
        writer.writeByte(0);
        break;
      case EnemyType.orc:
        writer.writeByte(1);
        break;
      case EnemyType.wolf:
        writer.writeByte(2);
        break;
      case EnemyType.bandit:
        writer.writeByte(3);
        break;
      case EnemyType.skeleton:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnemyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
