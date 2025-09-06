import 'package:hive/hive.dart';
import 'item.dart';

part 'inventory.g.dart';

@HiveType(typeId: 8)
class InventoryItem {
  @HiveField(0)
  final Item item;

  @HiveField(1)
  int quantity;

  InventoryItem({
    required this.item,
    this.quantity = 1,
  });
}

@HiveType(typeId: 9)
class Inventory {
  @HiveField(0)
  List<InventoryItem> items;

  @HiveField(1)
  int capacity;

  Inventory({
    this.items = const [],
    this.capacity = 20,
  });

  bool addItem(Item item, [int quantity = 1]) {
    if (_getTotalItems() + quantity > capacity) {
      return false;
    }

    final existingItem = items.firstWhere(
      (invItem) => invItem.item.id == item.id,
      orElse: () => InventoryItem(item: item, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      existingItem.quantity += quantity;
    } else {
      items.add(InventoryItem(item: item, quantity: quantity));
    }

    return true;
  }

  bool removeItem(String itemId, [int quantity = 1]) {
    final itemIndex = items.indexWhere((invItem) => invItem.item.id == itemId);

    if (itemIndex == -1) return false;

    if (items[itemIndex].quantity > quantity) {
      items[itemIndex].quantity -= quantity;
    } else {
      items.removeAt(itemIndex);
    }

    return true;
  }

  int getItemQuantity(String itemId) {
    return items.firstWhere(
      (invItem) => invItem.item.id == itemId,
      orElse: () => InventoryItem(item: Item(id: '', name: '', description: '', type: ItemType.potion, value: 0), quantity: 0),
    ).quantity;
  }

  int _getTotalItems() {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isFull => _getTotalItems() >= capacity;

  List<InventoryItem> getItemsByType(ItemType type) {
    return items.where((item) => item.item.type == type).toList();
  }
}