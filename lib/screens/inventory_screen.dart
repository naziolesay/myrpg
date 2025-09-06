import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/inventory.dart';
import '../models/item.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Заменить на реальные данные из провайдера
    final mockInventory = Inventory(
      items: [
        InventoryItem(
          item: Item(
            id: 'potion_1',
            name: 'Зелье здоровья',
            description: 'Восстанавливает 20 HP',
            type: ItemType.potion,
            value: 15,
            effectValue: 20,
          ),
          quantity: 3,
        ),
        InventoryItem(
          item: Item(
            id: 'sword_1',
            name: 'Стальной меч',
            description: 'Простой стальной меч',
            type: ItemType.weapon,
            value: 50,
            effectValue: 5,
          ),
          quantity: 1,
        ),
        InventoryItem(
          item: Item(
            id: 'armor_1',
            name: 'Кожаная броня',
            description: 'Прочная кожаная броня',
            type: ItemType.armor,
            value: 40,
            effectValue: 3,
          ),
          quantity: 1,
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Инвентарь')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Вместимость: ${_calculateTotalItems(mockInventory.items)}/${mockInventory.capacity}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: ListView.builder(
                itemCount: mockInventory.items.length,
                itemBuilder: (context, index) {
                  final inventoryItem = mockInventory.items[index];
                  return _buildInventoryItem(context, inventoryItem);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryItem(BuildContext context, InventoryItem inventoryItem) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: _getItemIcon(inventoryItem.item.type),
        title: Text(inventoryItem.item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(inventoryItem.item.description),
            if (inventoryItem.item.effectValue != null)
              Text(
                _getEffectDescription(inventoryItem.item.type, inventoryItem.item.effectValue!),
                style: TextStyle(color: Colors.green[700]),
              ),
          ],
        ),
        trailing: Text('x${inventoryItem.quantity}'),
        onTap: () => _useItem(context, inventoryItem.item),
      ),
    );
  }

  Icon _getItemIcon(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return const Icon(Icons.sports_martial_arts);
      case ItemType.armor:
        return const Icon(Icons.security);
      case ItemType.potion:
        return const Icon(Icons.medical_services); // Исправлено с local_potion
      case ItemType.resource:
        return const Icon(Icons.forest);
    }
  }

  String _getEffectDescription(ItemType type, int effectValue) {
    switch (type) {
      case ItemType.weapon:
        return '+$effectValue к урону';
      case ItemType.armor:
        return '+$effectValue к защите';
      case ItemType.potion:
        return 'Восстанавливает $effectValue HP';
      case ItemType.resource:
        return 'Ценный ресурс';
    }
  }

  void _useItem(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Использовать ${item.name}?'),
        content: Text(_getUseDescription(item)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.name} использован!')),
              );
            },
            child: const Text('Использовать'),
          ),
        ],
      ),
    );
  }

  String _getUseDescription(Item item) {
    switch (item.type) {
      case ItemType.potion:
        return 'Восстановит ${item.effectValue} HP';
      case ItemType.weapon:
        return 'Экипирует оружие (+${item.effectValue} к урону)';
      case ItemType.armor:
        return 'Экипирует броню (+${item.effectValue} к защите)';
      case ItemType.resource:
        return 'Использует ресурс';
    }
  }

  int _calculateTotalItems(List<InventoryItem> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}