import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/achievement_service.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAchievements = AchievementService.getAllAchievements();
    final unlockedAchievements = AchievementService.getUnlockedAchievements();
    final lockedAchievements = AchievementService.getLockedAchievements();

    return Scaffold(
      appBar: AppBar(title: const Text('Достижения')),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Все'),
                Tab(text: 'Полученные'),
                Tab(text: 'Не полученные'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildAchievementsList(context, allAchievements),
                  _buildAchievementsList(context, unlockedAchievements),
                  _buildAchievementsList(context, lockedAchievements),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsList(BuildContext context, List<Achievement> achievements) {
    if (achievements.isEmpty) {
      return const Center(
        child: Text('Нет достижений для отображения'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _buildAchievementCard(context, achievement);
      },
    );
  }

  Widget _buildAchievementCard(BuildContext context, Achievement achievement) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: achievement.isUnlocked ? Colors.green[50] : Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  achievement.isUnlocked ? Icons.verified : Icons.lock,
                  color: achievement.isUnlocked ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    achievement.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: achievement.isUnlocked ? Colors.green[800] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              achievement.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Условие: ${achievement.unlockCondition}',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            if (achievement.isUnlocked && achievement.unlockedDate != null) ...[
              const SizedBox(height: 8),
              Text(
                'Получено: ${_formatDate(achievement.unlockedDate!)}',
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}