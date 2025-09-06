// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 3;

  @override
  Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Character(
      name: fields[0] as String,
      characterClass: fields[1] as CharacterClass,
      race: fields[2] as CharacterRace,
      gender: fields[3] as CharacterGender,
      level: fields[4] as int,
      experience: fields[5] as int,
      maxHealth: fields[6] as int,
      maxMana: fields[8] as int,
      baseDamage: fields[10] as int,
      gold: fields[11] as int,
      skillPoints: fields[12] as int,
      criticalChance: fields[13] as int,
      dodgeChance: fields[14] as int,
      battlesWon: fields[15] as int,
      battlesLost: fields[16] as int,
      strength: fields[17] as int,
      agility: fields[18] as int,
      intelligence: fields[19] as int,
      luck: fields[20] as int,
      availablePoints: fields[21] as int,
    )
      ..currentHealth = fields[7] as int
      ..currentMana = fields[9] as int;
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.characterClass)
      ..writeByte(2)
      ..write(obj.race)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.experience)
      ..writeByte(6)
      ..write(obj.maxHealth)
      ..writeByte(7)
      ..write(obj.currentHealth)
      ..writeByte(8)
      ..write(obj.maxMana)
      ..writeByte(9)
      ..write(obj.currentMana)
      ..writeByte(10)
      ..write(obj.baseDamage)
      ..writeByte(11)
      ..write(obj.gold)
      ..writeByte(12)
      ..write(obj.skillPoints)
      ..writeByte(13)
      ..write(obj.criticalChance)
      ..writeByte(14)
      ..write(obj.dodgeChance)
      ..writeByte(15)
      ..write(obj.battlesWon)
      ..writeByte(16)
      ..write(obj.battlesLost)
      ..writeByte(17)
      ..write(obj.strength)
      ..writeByte(18)
      ..write(obj.agility)
      ..writeByte(19)
      ..write(obj.intelligence)
      ..writeByte(20)
      ..write(obj.luck)
      ..writeByte(21)
      ..write(obj.availablePoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CharacterClassAdapter extends TypeAdapter<CharacterClass> {
  @override
  final int typeId = 0;

  @override
  CharacterClass read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CharacterClass.warrior;
      case 1:
        return CharacterClass.archer;
      case 2:
        return CharacterClass.mage;
      default:
        return CharacterClass.warrior;
    }
  }

  @override
  void write(BinaryWriter writer, CharacterClass obj) {
    switch (obj) {
      case CharacterClass.warrior:
        writer.writeByte(0);
        break;
      case CharacterClass.archer:
        writer.writeByte(1);
        break;
      case CharacterClass.mage:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CharacterRaceAdapter extends TypeAdapter<CharacterRace> {
  @override
  final int typeId = 1;

  @override
  CharacterRace read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CharacterRace.human;
      case 1:
        return CharacterRace.elf;
      case 2:
        return CharacterRace.orc;
      case 3:
        return CharacterRace.goblin;
      default:
        return CharacterRace.human;
    }
  }

  @override
  void write(BinaryWriter writer, CharacterRace obj) {
    switch (obj) {
      case CharacterRace.human:
        writer.writeByte(0);
        break;
      case CharacterRace.elf:
        writer.writeByte(1);
        break;
      case CharacterRace.orc:
        writer.writeByte(2);
        break;
      case CharacterRace.goblin:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterRaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CharacterGenderAdapter extends TypeAdapter<CharacterGender> {
  @override
  final int typeId = 2;

  @override
  CharacterGender read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CharacterGender.male;
      case 1:
        return CharacterGender.female;
      default:
        return CharacterGender.male;
    }
  }

  @override
  void write(BinaryWriter writer, CharacterGender obj) {
    switch (obj) {
      case CharacterGender.male:
        writer.writeByte(0);
        break;
      case CharacterGender.female:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterGenderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
