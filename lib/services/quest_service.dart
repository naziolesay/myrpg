import 'package:hive/hive.dart';
import '../models/quest.dart';

class QuestService {
  static Future<void> initializeQuests() async {
    final box = Hive.box<Quest>('quests_box');

    if (box.isNotEmpty) return;

    final quests = [
      Quest(
        id: 'quest_1',
        title: 'Первое задание',
        description: 'Победите 3 гоблинов в лесу',
        rewardGold: 50,
        rewardExperience: 100,
        objective: 'defeat_goblins',
        targetCount: 3,
      ),
      Quest(
        id: 'quest_2',
        title: 'Сбор ресурсов',
        description: 'Соберите 10 золотых монет',
        rewardGold: 30,
        rewardExperience: 50,
        objective: 'collect_gold',
        targetCount: 10,
      ),
      Quest(
        id: 'quest_3',
        title: 'Исследователь',
        description: 'Посетите все локации',
        rewardGold: 100,
        rewardExperience: 150,
        objective: 'visit_locations',
        targetCount: 3,
      ),
    ];

    for (var quest in quests) {
      await box.put(quest.id, quest);
    }
  }

  static List<Quest> getAvailableQuests() {
    final box = Hive.box<Quest>('quests_box');
    return box.values.where((quest) => quest.status == QuestStatus.available).toList();
  }

  static List<Quest> getActiveQuests() {
    final box = Hive.box<Quest>('quests_box');
    return box.values.where((quest) => quest.status == QuestStatus.inProgress).toList();
  }

  static Future<void> acceptQuest(String questId) async {
    final box = Hive.box<Quest>('quests_box');
    final quest = box.get(questId);
    if (quest != null) {
      final updatedQuest = Quest(
        id: quest.id,
        title: quest.title,
        description: quest.description,
        status: QuestStatus.inProgress,
        rewardGold: quest.rewardGold,
        rewardExperience: quest.rewardExperience,
        objective: quest.objective,
        targetCount: quest.targetCount,
        currentCount: quest.currentCount,
      );
      await box.put(questId, updatedQuest);
    }
  }

  static Future<void> updateQuestProgress(String objective, int count) async {
    final box = Hive.box<Quest>('quests_box');
    for (var quest in box.values) {
      if (quest.status == QuestStatus.inProgress && quest.objective == objective) {
        quest.updateProgress(count);
        await box.put(quest.id, quest);
        
        // Автоматически завершаем квест если цель достигнута
        if (quest.isCompleted) {
          await completeQuest(quest.id);
        }
      }
    }
  }

  static Future<void> completeQuest(String questId) async {
    final box = Hive.box<Quest>('quests_box');
    final quest = box.get(questId);
    if (quest != null && quest.isCompleted) {
      final updatedQuest = Quest(
        id: quest.id,
        title: quest.title,
        description: quest.description,
        status: QuestStatus.completed,
        rewardGold: quest.rewardGold,
        rewardExperience: quest.rewardExperience,
        objective: quest.objective,
        targetCount: quest.targetCount,
        currentCount: quest.currentCount,
      );
      await box.put(questId, updatedQuest);
    }
  }

  // Метод для обновления прогресса после боя
  static Future<void> updateAfterCombat(String enemyType, int goldEarned) async {
    if (enemyType.toLowerCase().contains('goblin')) {
      await updateQuestProgress('defeat_goblins', 1);
    }
    await updateQuestProgress('collect_gold', goldEarned);
  }

  // Метод для обновления прогресса посещения локаций
  static Future<void> updateLocationVisit() async {
    await updateQuestProgress('visit_locations', 1);
  }
}