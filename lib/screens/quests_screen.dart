import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/quest_service.dart';
import '../models/quest.dart';

class QuestsScreen extends ConsumerWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableQuests = QuestService.getAvailableQuests();
    final activeQuests = QuestService.getActiveQuests();

    return Scaffold(
      appBar: AppBar(title: const Text('Квесты')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Активные квесты
            const Text(
              'Активные квесты:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            if (activeQuests.isEmpty)
              const Text('Нет активных квестов')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: activeQuests.length,
                  itemBuilder: (context, index) {
                    final quest = activeQuests[index];
                    return _buildQuestCard(context, quest, true);
                  },
                ),
              ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // Доступные квесты
            const Text(
              'Доступные квесты:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            if (availableQuests.isEmpty)
              const Text('Нет доступных квестов')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: availableQuests.length,
                  itemBuilder: (context, index) {
                    final quest = availableQuests[index];
                    return _buildQuestCard(context, quest, false);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestCard(BuildContext context, Quest quest, bool isActive) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quest.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(quest.description),
            const SizedBox(height: 8),
            
            if (isActive)
              LinearProgressIndicator(
                value: quest.currentCount / quest.targetCount,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
              ),
            
            if (isActive)
              Text(
                'Прогресс: ${quest.currentCount}/${quest.targetCount}',
                style: const TextStyle(fontSize: 12),
              ),
            
            const SizedBox(height: 8),
            Text(
              'Награда: ${quest.rewardGold} золота, ${quest.rewardExperience} опыта',
              style: const TextStyle(fontSize: 12, color: Colors.green),
            ),
            
            const SizedBox(height: 8),
            if (!isActive)
              ElevatedButton(
                onPressed: () {
                  QuestService.acceptQuest(quest.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Квест "${quest.title}" принят!')),
                  );
                },
                child: const Text('Принять квест'),
              ),
          ],
        ),
      ),
    );
  }
}