import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'battle_screen_v2.dart';
import '../providers/providers.dart';
import '../models/character.dart';
import '../models/enemy.dart';

class ForestScreen extends ConsumerWidget {
  const ForestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Заголовок
                const Text(
                  'Темный Лес',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Иконка
                const Icon(Icons.forest, size: 64, color: Colors.green),
                const SizedBox(height: 20),

                // Описание
                const Text(
                  'Опасный лес полный монстров и тайн.\nБудьте осторожны!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 40),

                // Статистика персонажа
                if (character != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            'Уровень: ${character.level}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Здоровье: ${character.currentHealth}/${character.maxHealth}',
                            style: TextStyle(
                              color: character.currentHealth < character.maxHealth * 0.3
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Золото: ${character.gold}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Кнопки действий
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  children: [
                    // Кнопка боя с гоблином
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BattleScreenV2(enemyType: EnemyType.goblin),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sports_martial_arts, size: 32),
                          SizedBox(height: 8),
                          Text('Сражаться с гоблином'),
                        ],
                      ),
                    ),

                    // Кнопка боя с орком
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BattleScreenV2(enemyType: EnemyType.orc),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sports_martial_arts, size: 32),
                          SizedBox(height: 8),
                          Text('Сражаться с орком'),
                        ],
                      ),
                    ),

                    // Кнопка боя со скелетоном
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BattleScreenV2(enemyType: EnemyType.skeleton),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sports_martial_arts, size: 32),
                          SizedBox(height: 8),
                          Text('Сражаться со скелетоном'),
                        ],
                      ),
                    ),

                    // Кнопка сбора ресурсов
                    ElevatedButton(
                      onPressed: character != null
                          ? () => _gatherResources(context, ref, character)
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.eco, size: 32),
                          SizedBox(height: 8),
                          Text('Собирать травы'),
                        ],
                      ),
                    ),

                    // Кнопка исследования
                    ElevatedButton(
                      onPressed: () => _exploreForest(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 32),
                          SizedBox(height: 8),
                          Text('Исследовать'),
                        ],
                      ),
                    ),

                    // Кнопка возврата
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.exit_to_app, size: 32),
                          SizedBox(height: 8),
                          Text('Вернуться'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _gatherResources(BuildContext context, WidgetRef ref, Character character) {
    final random = Random();
    final success = random.nextBool();
    
    if (success) {
      final goldFound = random.nextInt(10) + 5;
      character.gold += goldFound;
      ref.read(characterProvider.notifier).saveCharacter(character);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Вы нашли $goldFound золота!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вы ничего не нашли...')),
      );
    }
  }

  void _exploreForest(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Вы исследовали местность, но ничего интересного не нашли.')),
    );
  }
}