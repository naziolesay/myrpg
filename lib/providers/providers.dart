import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/character.dart';
import '../models/game_state.dart';
import '../models/item.dart';
import '../services/hive_service.dart';
import '../services/quest_service.dart';
import '../services/achievement_service.dart';

// Провайдер для главного персонажа
final characterProvider = StateNotifierProvider<CharacterNotifier, Character?>((ref) {
  return CharacterNotifier();
});

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
    
    // Проверяем достижения при сохранении персонажа (исправленный вызов)
    AchievementService.checkCombatAchievements(character);
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

// Провайдер для состояния игры
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState?>((ref) {
  return GameStateNotifier();
});

class GameStateNotifier extends StateNotifier<GameState?> {
  GameStateNotifier() : super(null) {
    loadGameState();
  }

  void loadGameState() {
    final box = Hive.box<GameState>('game_state_box');
    state = box.get('current_game_state') ?? GameState(lastSaveTime: DateTime.now());
  }

  Future<void> saveGameState(GameState gameState) async {
    final box = Hive.box<GameState>('game_state_box');
    await box.put('current_game_state', gameState);
    state = gameState;
  }

  void changeLocation(GameLocation newLocation) {
    if (state != null) {
      final updatedState = GameState(
        currentLocation: newLocation,
        lastSaveTime: DateTime.now(),
      );
      saveGameState(updatedState);
    }
  }
}

// Провайдер для предметов в магазине
final itemsProvider = FutureProvider<List<Item>>((ref) async {
  await HiveService.initializeItems();
  return HiveService.getAllItems();
});

// Провайдер для проверки достижений
final achievementsProvider = FutureProvider<void>((ref) async {
  await AchievementService.initializeAchievements();
});

// Провайдер для квестов
final questsProvider = FutureProvider<void>((ref) async {
  await QuestService.initializeQuests();
});