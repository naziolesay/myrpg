import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class LevelUpScreen extends ConsumerWidget {
  const LevelUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);

    if (character == null || character.skillPoints == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Прокачка')),
        body: const Center(
          child: Text('Нет очков навыков для распределения'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Прокачка персонажа')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Уровень: ${character.level}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Очков навыков: ${character.skillPoints}',
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 20),

            // Характеристики
            _buildStatCard('Здоровье', '${character.maxHealth} HP', 
                () => character.improveHealth(), Icons.favorite),
            
            _buildStatCard('Урон', '${character.baseDamage} урона', 
                () => character.improveDamage(), Icons.sports_martial_arts),
            
            _buildStatCard('Шанс крита', '${character.criticalChance}%', 
                () => character.improveCritical(), Icons.crisis_alert),
            
            _buildStatCard('Уклонение', '${character.dodgeChance}%', 
                () => character.improveDodge(), Icons.shield),

            const Spacer(),
            
            // Кнопка назад
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(characterProvider.notifier).saveCharacter(character);
                  Navigator.pop(context);
                },
                child: const Text('Завершить прокачку'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, VoidCallback onImprove, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        trailing: ElevatedButton(
          onPressed: onImprove,
          child: const Text('Улучшить'),
        ),
      ),
    );
  }
}