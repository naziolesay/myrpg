import 'package:hive/hive.dart';

part 'achievement.g.dart';

@HiveType(typeId: 12)
class Achievement {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isUnlocked;

  @HiveField(4)
  final DateTime? unlockedDate;

  @HiveField(5)
  final String unlockCondition;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.isUnlocked = false,
    this.unlockedDate,
    required this.unlockCondition,
  });

  void unlock() {
    if (!isUnlocked) {
      Achievement unlocked = Achievement(
        id: id,
        title: title,
        description: description,
        isUnlocked: true,
        unlockedDate: DateTime.now(),
        unlockCondition: unlockCondition,
      );
      // This would typically be saved to storage
    }
  }
}