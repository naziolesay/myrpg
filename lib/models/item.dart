import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 2)
enum ItemType {
  @HiveField(0)
  weapon,
  @HiveField(1)
  armor,
  @HiveField(2)
  potion,
  @HiveField(3)
  resource,
}

@HiveType(typeId: 3)
class Item {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final ItemType type;

  @HiveField(4)
  final int value; // Цена покупки/продажи

  @HiveField(5)
  final int? effectValue; // Значение эффекта (например, +10 к урону или +20 к здоровью)

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.value,
    this.effectValue,
  });
}