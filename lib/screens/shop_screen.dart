import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/item.dart';
import '../models/character.dart'; // Добавлен импорт

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);
    final itemsAsync = ref.watch(itemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Магазин')),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
        data: (items) {
          return Column(
            children: [
              // Информация о персонаже
              if (character != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Золото: ${character.gold}'),
                        Text('Уровень: ${character.level}'),
                      ],
                    ),
                  ),
                ),

              // Список предметов
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildItemCard(context, ref, item, character);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, WidgetRef ref, Item item, Character? character) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: _getItemIcon(item.type),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description),
            if (item.effectValue != null)
              Text(
                _getEffectDescription(item.type, item.effectValue!),
                style: TextStyle(color: Colors.green[700]),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${item.value} золота'),
            ElevatedButton(
              onPressed: character != null && character.gold >= item.value
                  ? () => _buyItem(context, ref, item, character)
                  : null,
              child: const Text('Купить'),
            ),
          ],
        ),
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

  void _buyItem(BuildContext context, WidgetRef ref, Item item, Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Купить ${item.name}?'),
        content: Text('Цена: ${item.value} золота'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              // Обновляем персонажа
              character.gold -= item.value;
              // TODO: Добавить предмет в инвентарь
              ref.read(characterProvider.notifier).saveCharacter(character);
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.name} куплен!')),
              );
            },
            child: const Text('Купить'),
          ),
        ],
      ),
    );
  }
}