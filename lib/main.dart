import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/main_menu_screen.dart';
import 'models/character.dart';
import 'models/item.dart';
import 'models/game_state.dart';
import 'models/enemy.dart';
import 'models/inventory.dart';
import 'models/quest.dart';
import 'models/achievement.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Hive.initFlutter();
    
    Hive.registerAdapter(CharacterClassAdapter());
    Hive.registerAdapter(CharacterAdapter());
    Hive.registerAdapter(ItemTypeAdapter());
    Hive.registerAdapter(ItemAdapter());
    Hive.registerAdapter(GameLocationAdapter());
    Hive.registerAdapter(GameStateAdapter());
    Hive.registerAdapter(EnemyTypeAdapter());
    Hive.registerAdapter(EnemyAdapter());
    Hive.registerAdapter(InventoryItemAdapter());
    Hive.registerAdapter(InventoryAdapter());
    Hive.registerAdapter(QuestStatusAdapter());
    Hive.registerAdapter(QuestAdapter());
    Hive.registerAdapter(AchievementAdapter());
    
    await Hive.openBox<Character>('characters_box');
    await Hive.openBox<Item>('items_box');
    await Hive.openBox<GameState>('game_state_box');
    await Hive.openBox<Quest>('quests_box');
    await Hive.openBox<Achievement>('achievements_box');
    
    print('Hive initialized successfully');
  } catch (e) {
    print('Error initializing Hive: $e');
  }
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'БК',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}