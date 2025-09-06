import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'city_screen.dart';
import 'tavern_screen.dart';
import 'forest_screen.dart';
import '../providers/providers.dart';
import '../models/game_state.dart';
import '../services/quest_service.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  Widget _getLocationScreen(GameLocation location) {
    switch (location) {
      case GameLocation.city:
        return const CityScreen();
      case GameLocation.tavern:
        return const TavernScreen();
      case GameLocation.forest:
        return const ForestScreen();
    }
  }

  String _getLocationName(GameLocation location) {
    switch (location) {
      case GameLocation.city:
        return 'Город';
      case GameLocation.tavern:
        return 'Таверна';
      case GameLocation.forest:
        return 'Лес';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final character = ref.watch(characterProvider);

    // Если данные не загружены, показываем загрузку
    if (gameState == null || character == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text('Загрузка игры...'),
            ],
          ),
        ),
      );
    }

    // При смене локации обновляем квесты
    WidgetsBinding.instance.addPostFrameCallback((_) {
      QuestService.updateLocationVisit();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Локация: ${_getLocationName(gameState.currentLocation)}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              await ref.read(characterProvider.notifier).saveCharacter(character);
              await ref.read(gameStateProvider.notifier).saveGameState(gameState);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Игра сохранена!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: _getLocationScreen(gameState.currentLocation),
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          currentIndex: gameState.currentLocation.index,
          onTap: (index) {
            final newLocation = GameLocation.values[index];
            ref.read(gameStateProvider.notifier).changeLocation(newLocation);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              label: 'Город',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_bar),
              label: 'Таверна',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.nature),
              label: 'Лес',
            ),
          ],
        ),
      ),
    );
  }
}