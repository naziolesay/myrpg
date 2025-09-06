// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestAdapter extends TypeAdapter<Quest> {
  @override
  final int typeId = 11;

  @override
  Quest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quest(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      status: fields[3] as QuestStatus,
      rewardGold: fields[4] as int,
      rewardExperience: fields[5] as int,
      objective: fields[6] as String,
      targetCount: fields[7] as int,
      currentCount: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Quest obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.rewardGold)
      ..writeByte(5)
      ..write(obj.rewardExperience)
      ..writeByte(6)
      ..write(obj.objective)
      ..writeByte(7)
      ..write(obj.targetCount)
      ..writeByte(8)
      ..write(obj.currentCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestStatusAdapter extends TypeAdapter<QuestStatus> {
  @override
  final int typeId = 10;

  @override
  QuestStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestStatus.available;
      case 1:
        return QuestStatus.inProgress;
      case 2:
        return QuestStatus.completed;
      case 3:
        return QuestStatus.failed;
      default:
        return QuestStatus.available;
    }
  }

  @override
  void write(BinaryWriter writer, QuestStatus obj) {
    switch (obj) {
      case QuestStatus.available:
        writer.writeByte(0);
        break;
      case QuestStatus.inProgress:
        writer.writeByte(1);
        break;
      case QuestStatus.completed:
        writer.writeByte(2);
        break;
      case QuestStatus.failed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
