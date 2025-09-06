import 'package:hive/hive.dart';

part 'quest.g.dart';

@HiveType(typeId: 10)
enum QuestStatus {
  @HiveField(0)
  available,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  completed,
  @HiveField(3)
  failed
}

@HiveType(typeId: 11)
class Quest {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final QuestStatus status;

  @HiveField(4)
  final int rewardGold;

  @HiveField(5)
  final int rewardExperience;

  @HiveField(6)
  final String objective;

  @HiveField(7)
  final int targetCount;

  @HiveField(8)
  int currentCount;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    this.status = QuestStatus.available,
    required this.rewardGold,
    required this.rewardExperience,
    required this.objective,
    required this.targetCount,
    this.currentCount = 0,
  });

  void updateProgress(int count) {
    currentCount += count;
    if (currentCount >= targetCount) {
      // Status will be updated when quest is turned in
    }
  }

  bool get isCompleted => currentCount >= targetCount;
}