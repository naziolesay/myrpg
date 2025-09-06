import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/character.dart';
import '../models/game_state.dart';
import '../models/item.dart';
import '../services/hive_service.dart';
import '../services/quest_service.dart';
import '../services/achievement_service.dart';

// ... существующий код characterProvider и gameStateProvider ...

// Провайдер для проверки достижений
final achievementsProvider = FutureProvider<void>((ref) async {
  await AchievementService.initializeAchievements();
});

// Провайдер для квестов
final questsProvider = FutureProvider<void>((ref) async {
  await QuestService.initializeQuests();
});

// Обновляем CharacterNotifier для обработки достижений
class CharacterNotifier extends StateNotifier<Character?> {
  CharacterNotifier() : super(null) {
    loadCharacter();
  }

  void loadCharacter() {
    final box = Hive.box<Character>('characters_box');
    state = box.get('player_character');
  }

  Future<void> saveCharacter(Character character) async {
    final box = Hive.box<Character>('characters_box');
    await box.put('player_character', character);
    state = character;
    
    // Проверяем достижения при сохранении персонажа
    AchievementService.checkCombatAchievements(character.gold, character.level);
  }

  void createNewCharacter(String name, CharacterClass characterClass) {
    late Character newCharacter;
    switch (characterClass) {
      case CharacterClass.warrior:
        newCharacter = Character(
          name: name,
          characterClass: characterClass,
          maxHealth: 100,
          maxStamina: 50,
          baseDamage: 12,
        );
        break;
      case CharacterClass.archer:
        newCharacter = Character(
          name: name,
          characterClass: characterClass,
          maxHealth: 80,
          maxStamina: 70,
          baseDamage: 10,
        );
        break;
      case CharacterClass.mage:
        newCharacter = Character(
          name: name,
          characterClass: characterClass,
          maxHealth: 70,
          maxStamina: 60,
          baseDamage: 15,
        );
        break;
    }

    saveCharacter(newCharacter);
  }
}