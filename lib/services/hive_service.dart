import 'package:hive/hive.dart';
import '../models/item.dart'; // Добавлен импорт
import '../models/character.dart'; // Добавлен импорт

class HiveService {
  static Future<void> initializeItems() async {
    final box = Hive.box<Item>('items_box');

    // Если предметы уже есть, не добавляем их снова
    if (box.isNotEmpty) return;

    final items = [
      Item(
        id: 'sword_1',
        name: 'Стальной меч',
        description: 'Простой стальной меч',
        type: ItemType.weapon,
        value: 50,
        effectValue: 5,
      ),
      Item(
        id: 'potion_heal_1',
        name: 'Зелье здоровья',
        description: 'Восстанавливает 20 HP',
        type: ItemType.potion,
        value: 15,
        effectValue: 20,
      ),
      Item(
        id: 'armor_1',
        name: 'Кожаная броня',
        description: 'Прочная кожаная броня',
        type: ItemType.armor,
        value: 40,
        effectValue: 3,
      ),
    ];

    for (var item in items) {
      await box.put(item.id, item);
    }
  }

  // Получить все предметы из бокса
  static List<Item> getAllItems() {
    final box = Hive.box<Item>('items_box');
    return box.values.toList();
  }

  // Получить предмет по ID
  static Item? getItem(String id) {
    final box = Hive.box<Item>('items_box');
    return box.get(id);
  }
}