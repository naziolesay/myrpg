import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/character.dart';

class TavernScreen extends ConsumerWidget {
  const TavernScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Заголовок
          Text(
            'Таверна "У Спящего Дракона"',
            style: TextStyle(
              fontSize: screenHeight > 600 ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // Иконка
          Icon(Icons.local_bar, 
              size: screenHeight > 600 ? 64 : 48, 
              color: Colors.brown),
          const SizedBox(height: 20),
          
          // Описание
          Text(
            'Отдохните и восстановите силы после долгого пути.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: screenHeight > 600 ? 16 : 14),
          ),
          const SizedBox(height: 40),

          // Статистика
          if (character != null) ...[
            _buildStatCard('Здоровье', 
                '${character.currentHealth}/${character.maxHealth}', 
                character.currentHealth < character.maxHealth * 0.3 ? Colors.red : Colors.green),
            const SizedBox(height: 10),
            _buildStatCard('Выносливость', 
                '${character.currentStamina}/${character.maxStamina}', 
                Colors.blue),
            const SizedBox(height: 30),
            
            // Кнопка отдыха
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: character.currentHealth < character.maxHealth
                    ? () => _restInTavern(context, ref, character)
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Отдохнуть (10 золота)'),
              ),
            ),
          ],

          const Spacer(),

          // Золото
          if (character != null)
            Text(
              'Золото: ${character.gold}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _restInTavern(BuildContext context, WidgetRef ref, Character character) {
    const restCost = 10;

    if (character.gold >= restCost) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Отдохнуть в таверне?'),
          content: Text('Это будет стоить $restCost золота.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                character.gold -= restCost;
                character.rest();
                ref.read(characterProvider.notifier).saveCharacter(character);
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Вы хорошо отдохнули! Здоровье и выносливость восстановлены.')),
                );
              },
              child: const Text('Отдохнуть'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Недостаточно золота для отдыха!')),
      );
    }
  }
}