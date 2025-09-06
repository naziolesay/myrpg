import 'package:hive/hive.dart';

part 'enemy.g.dart';

@HiveType(typeId: 6)
enum EnemyType {
  @HiveField(0)
  goblin,
  @HiveField(1)
  orc,
  @HiveField(2)
  wolf,
  @HiveField(3)
  bandit,
  @HiveField(4)
  skeleton,
}

@HiveType(typeId: 7)
class Enemy {
  @HiveField(0)
  final EnemyType type;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int maxHealth;

  @HiveField(3)
  int currentHealth;

  @HiveField(4)
  final int damage;

  @HiveField(5)
  final int experienceReward;

  @HiveField(6)
  final int goldReward;

  Enemy({
    required this.type,
    required this.name,
    required this.maxHealth,
    required this.damage,
    required this.experienceReward,
    required this.goldReward,
  }) : currentHealth = maxHealth;

  factory Enemy.create(EnemyType type) {
    switch (type) {
      case EnemyType.goblin:
        return Enemy(
          type: type,
          name: 'Гоблин',
          maxHealth: 50,
          damage: 8,
          experienceReward: 20,
          goldReward: 15,
        );
      case EnemyType.orc:
        return Enemy(
          type: type,
          name: 'Орк',
          maxHealth: 80,
          damage: 12,
          experienceReward: 35,
          goldReward: 25,
        );
      case EnemyType.wolf:
        return Enemy(
          type: type,
          name: 'Волк',
          maxHealth: 40,
          damage: 10,
          experienceReward: 15,
          goldReward: 10,
        );
      case EnemyType.bandit:
        return Enemy(
          type: type,
          name: 'Бандит',
          maxHealth: 60,
          damage: 9,
          experienceReward: 30,
          goldReward: 20,
        );
      case EnemyType.skeleton:
        return Enemy(
          type: type,
          name: 'Скелетон',
          maxHealth: 45,
          damage: 9,
          experienceReward: 25,
          goldReward: 18,
        );
    }
  }

  void takeDamage(int damage) {
    currentHealth -= damage;
    if (currentHealth < 0) currentHealth = 0;
  }

  bool get isAlive => currentHealth > 0;

  int attack() {
    return damage;
  }
}