import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shop_screen.dart';
import 'quests_screen.dart';
import 'inventory_screen.dart';
import 'level_up_screen.dart';
import '../providers/providers.dart';

class CityScreen extends ConsumerWidget {
  const CityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);

    return Scaffold(
      body: Column(
        children: [
          // Шапка с информацией о персонаже
          if (character != null) _buildCharacterHeader(character),
          
          // Основной контент
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                children: [
                  _buildCityButton(
                    Icons.storefront,
                    'Магазин',
                    Colors.blue,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopScreen())),
                  ),
                  _buildCityButton(
                    Icons.assignment,
                    'Квесты',
                    Colors.green,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestsScreen())),
                  ),
                  _buildCityButton(
                    Icons.backpack,
                    'Инвентарь',
                    Colors.orange,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryScreen())),
                  ),
                  _buildCityButton(
                    Icons.auto_awesome,
                    'Прокачка',
                    Colors.purple,
                    () {
                      if (character != null && character.skillPoints > 0) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LevelUpScreen()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Нет очков для прокачки!')),
                        );
                      }
                    },
                  ),
                  _buildCityButton(
                    Icons.people,
                    'Жители',
                    Colors.brown,
                    () => _showComingSoon(context, 'Общение с жителями'),
                  ),
                  _buildCityButton(
                    Icons.celebration,
                    'Достижения',
                    Colors.pink,
                    () => _showComingSoon(context, 'Система достижений'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterHeader(Character character) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Аватар персонажа
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(character.imagePath),
          ),
          const SizedBox(width: 16),
          
          // Информация о персонаже
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ур. ${character.level} • ${_getRaceName(character.race)} • ${_getClassName(character.characterClass)}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                // HP
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: character.currentHealth / character.maxHealth,
                        backgroundColor: Colors.white30,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${character.currentHealth}/${character.maxHealth}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // MP
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.blue, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: character.currentMana / character.maxMana,
                        backgroundColor: Colors.white30,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${character.currentMana}/${character.maxMana}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Золото и очки
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.yellow, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${character.gold}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (character.skillPoints > 0)
                Text(
                  '${character.skillPoints} очков',
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCityButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _getRaceName(CharacterRace race) {
    switch (race) {
      case CharacterRace.human: return 'Человек';
      case CharacterRace.elf: return 'Эльф';
      case CharacterRace.orc: return 'Орк';
      case CharacterRace.goblin: return 'Гоблин';
    }
  }

  String _getClassName(CharacterClass cls) {
    switch (cls) {
      case CharacterClass.warrior: return 'Воин';
      case CharacterClass.archer: return 'Лучник';
      case CharacterClass.mage: return 'Маг';
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature будет доступно в следующем обновлении!')),
    );
  }
}