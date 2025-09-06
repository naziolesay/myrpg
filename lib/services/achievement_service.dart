import 'package:hive/hive.dart';
import '../models/achievement.dart';
import '../models/character.dart';

class AchievementService {
  static Future<void> initializeAchievements() async {
    final box = Hive.box<Achievement>('achievements_box');

    if (box.isNotEmpty) return;

    final achievements = [
      Achievement(
        id: 'ach_first_victory',
        title: 'Первая кровь',
        description: 'Одержите первую победу в бою',
        unlockCondition: 'Победить любого врага',
      ),
      Achievement(
        id: 'ach_rich',
        title: 'Богач',
        description: 'Накопите 100 золотых монет',
        unlockCondition: 'Золото ≥ 100',
      ),
      Achievement(
        id: 'ach_explorer',
        title: 'Исследователь',
        description: 'Посетите все локации города',
        unlockCondition: 'Посетить все локации',
      ),
      Achievement(
        id: 'ach_warrior',
        title: 'Ветеран',
        description: 'Достигните 5 уровня',
        unlockCondition: 'Уровень ≥ 5',
      ),
      Achievement(
        id: 'ach_shopper',
        title: 'Покупатель',
        description: 'Купите первый предмет в магазине',
        unlockCondition: 'Купить любой предмет',
      ),
      Achievement(
        id: 'ach_critical_master',
        title: 'Мастер критов',
        description: 'Доведите шанс критического удара до 20%',
        unlockCondition: 'Крит ≥ 20%',
      ),
      Achievement(
        id: 'ach_dodge_master', 
        title: 'Неуловимый',
        description: 'Доведите шанс уклонения до 15%',
        unlockCondition: 'Уклонение ≥ 15%',
      ),
      Achievement(
        id: 'ach_veteran',
        title: 'Боевой ветеран',
        description: 'Выиграйте 10 боёв',
        unlockCondition: 'Победы ≥ 10',
      ),
      Achievement(
        id: 'ach_skill_master',
        title: 'Мастер навыков',
        description: 'Потратьте 20 очков навыков',
        unlockCondition: 'Потрачено очков ≥ 20',
      ),
    ];

    for (var achievement in achievements) {
      await box.put(achievement.id, achievement);
    }
  }

  static List<Achievement> getAllAchievements() {
    final box = Hive.box<Achievement>('achievements_box');
    return box.values.toList();
  }

  static List<Achievement> getUnlockedAchievements() {
    final box = Hive.box<Achievement>('achievements_box');
    return box.values.where((ach) => ach.isUnlocked).toList();
  }

  static List<Achievement> getLockedAchievements() {
    final box = Hive.box<Achievement>('achievements_box');
    return box.values.where((ach) => !ach.isUnlocked).toList();
  }

  static Future<void> unlockAchievement(String achievementId) async {
    final box = Hive.box<Achievement>('achievements_box');
    final achievement = box.get(achievementId);
    if (achievement != null && !achievement.isUnlocked) {
      final unlockedAchievement = Achievement(
        id: achievement.id,
        title: achievement.title,
        description: achievement.description,
        isUnlocked: true,
        unlockedDate: DateTime.now(),
        unlockCondition: achievement.unlockCondition,
      );
      await box.put(achievementId, unlockedAchievement);
    }
  }

  static Future<void> checkCombatAchievements(Character character) async {
    final box = Hive.box<Achievement>('achievements_box');
    
    // Проверка достижения "Богач"
    if (character.gold >= 100) {
      final richAchievement = box.get('ach_rich');
      if (richAchievement != null && !richAchievement.isUnlocked) {
        await unlockAchievement('ach_rich');
      }
    }

    // Проверка достижения "Ветеран"
    if (character.level >= 5) {
      final warriorAchievement = box.get('ach_warrior');
      if (warriorAchievement != null && !warriorAchievement.isUnlocked) {
        await unlockAchievement('ach_warrior');
      }
    }

    // Проверка достижений прокачки
    if (character.criticalChance >= 20) {
      final criticalAchievement = box.get('ach_critical_master');
      if (criticalAchievement != null && !criticalAchievement.isUnlocked) {
        await unlockAchievement('ach_critical_master');
      }
    }

    if (character.dodgeChance >= 15) {
      final dodgeAchievement = box.get('ach_dodge_master');
      if (dodgeAchievement != null && !dodgeAchievement.isUnlocked) {
        await unlockAchievement('ach_dodge_master');
      }
    }

    if (character.battlesWon >= 10) {
      final veteranAchievement = box.get('ach_veteran');
      if (veteranAchievement != null && !veteranAchievement.isUnlocked) {
        await unlockAchievement('ach_veteran');
      }
    }
  }

  // Метод для проверки достижений связанных с прокачкой
  static Future<void> checkSkillAchievements(int totalSkillPointsSpent) async {
    final box = Hive.box<Achievement>('achievements_box');
    
    if (totalSkillPointsSpent >= 20) {
      final skillAchievement = box.get('ach_skill_master');
      if (skillAchievement != null && !skillAchievement.isUnlocked) {
        await unlockAchievement('ach_skill_master');
      }
    }
  }
}