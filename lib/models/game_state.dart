import 'package:hive/hive.dart';

part 'game_state.g.dart';

@HiveType(typeId: 4)
enum GameLocation {
  @HiveField(0)
  city,
  @HiveField(1)
  tavern,
  @HiveField(2)
  forest,
}

@HiveType(typeId: 5)
class GameState {
  @HiveField(0)
  GameLocation currentLocation;

  @HiveField(1)
  DateTime lastSaveTime;

  GameState({
    this.currentLocation = GameLocation.city,
    required this.lastSaveTime,
  });
}