import 'dart:math';
import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 0)
enum CharacterClass {
  @HiveField(0)
  warrior,
  @HiveField(1)
  archer,
  @HiveField(2)
  mage,
}

@HiveType(typeId: 1)
enum CharacterRace {
  @HiveField(0)
  human,
  @HiveField(1)
  elf,
  @HiveField(2)
  orc,
  @HiveField(3)
  goblin,
}

@HiveType(typeId: 2)
enum CharacterGender {
  @HiveField(0)
  male,
  @HiveField(1)
  female,
}

@HiveType(typeId: 3)
class Character {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final CharacterClass characterClass;

  @HiveField(2)
  final CharacterRace race;

  @HiveField(3)
  final CharacterGender gender;

  @HiveField(4)
  int level;

  @HiveField(5)
  int experience;

  @HiveField(6)
  int maxHealth;

  @HiveField(7)
  int currentHealth;

  @HiveField(8)
  int maxMana;

  @HiveField(9)
  int currentMana;

  @HiveField(10)
  int baseDamage;

  @HiveField(11)
  int gold;

  @HiveField(12)
  int skillPoints;

  @HiveField(13)
  int criticalChance;

  @HiveField(14)
  int dodgeChance;

  @HiveField(15)
  int battlesWon;

  @HiveField(16)
  int battlesLost;

  // Базовые характеристики
  @HiveField(17)
  int strength;

  @HiveField(18)
  int agility;

  @HiveField(19)
  int intelligence;

  @HiveField(20)
  int luck;

  @HiveField(21)
  int availablePoints;

  Character({
    required this.name,
    required this.characterClass,
    required this.race,
    required this.gender,
    this.level = 1,
    this.experience = 0,
    required this.maxHealth,
    required this.maxMana,
    required this.baseDamage,
    this.gold = 0,
    this.skillPoints = 0,
    this.criticalChance = 5,
    this.dodgeChance = 5,
    this.battlesWon = 0,
    this.battlesLost = 0,
    this.strength = 3,
    this.agility = 3,
    this.intelligence = 3,
    this.luck = 3,
    this.availablePoints = 5,
  }) : currentHealth = maxHealth, currentMana = maxMana;

  // Геттер для изображения персонажа
  String get imagePath {
    String genderStr = gender == CharacterGender.male ? 'male' : 'female';
    String raceStr = '';
    
    switch (race) {
      case CharacterRace.human:
        raceStr = 'human';
        break;
      case CharacterRace.elf:
        raceStr = 'elf';
        break;
      case CharacterRace.orc:
        raceStr = 'orc';
        break;
      case CharacterRace.goblin:
        raceStr = 'goblin';
        break;
    }
    
    return 'assets/images/player_${raceStr}_$genderStr.png';
  }

  // Метод для получения опыта до следующего уровня
  int get experienceToNextLevel => level * 100;

  // Метод для добавления опыта и проверки повышения уровня
  void gainExperience(int exp) {
    experience += exp;
    while (experience >= experienceToNextLevel) {
      levelUp();
    }
  }

  // Метод повышения уровня
  void levelUp() {
    level++;
    experience -= experienceToNextLevel;
    skillPoints += 2;
    availablePoints += 1;
    
    // Базовая прокачка характеристик в зависимости от класса
    maxHealth += 10 + (characterClass == CharacterClass.warrior ? 5 : 0);
    maxMana += 5 + (characterClass == CharacterClass.mage ? 5 : 0);
    baseDamage += 2 + (characterClass == CharacterClass.mage ? 1 : 0);
    
    // Бонусы от характеристик
    maxHealth += strength;
    maxMana += intelligence;
    baseDamage += (strength ~/ 2);
    criticalChance += luck ~/ 2;
    dodgeChance += agility ~/ 2;
    
    currentHealth = maxHealth;
    currentMana = maxMana;
  }

  // Методы для распределения очков характеристик
  void increaseStrength() {
    if (availablePoints > 0) {
      strength++;
      availablePoints--;
      maxHealth += 2;
      baseDamage += 1;
    }
  }

  void increaseAgility() {
    if (availablePoints > 0) {
      agility++;
      availablePoints--;
      dodgeChance += 1;
      criticalChance += 1;
    }
  }

  void increaseIntelligence() {
    if (availablePoints > 0) {
      intelligence++;
      availablePoints--;
      maxMana += 3;
    }
  }

  void increaseLuck() {
    if (availablePoints > 0) {
      luck++;
      availablePoints--;
      criticalChance += 2;
    }
  }

  // Метод для атаки с учетом шанса крита
  int attack() {
    final random = Random();
    final isCritical = random.nextInt(100) < criticalChance;
    final damage = isCritical ? (baseDamage * 1.5).round() : baseDamage;
    return damage;
  }

  // Метод для проверки уклонения
  bool tryDodge() {
    final random = Random();
    return random.nextInt(100) < dodgeChance;
  }

  // Метод для получения урона
  void takeDamage(int damage) {
    if (tryDodge()) {
      return; // Успешное уклонение
    }
    currentHealth -= damage;
    if (currentHealth < 0) currentHealth = 0;
  }

  // Метод для лечения
  void heal(int amount) {
    currentHealth += amount;
    if (currentHealth > maxHealth) currentHealth = maxHealth;
  }

  // Метод для использования маны
  bool useMana(int amount) {
    if (currentMana >= amount) {
      currentMana -= amount;
      return true;
    }
    return false;
  }

  // Метод для восстановления маны
  void restoreMana(int amount) {
    currentMana += amount;
    if (currentMana > maxMana) currentMana = maxMana;
  }

  // Восстановление после боя
  void rest() {
    currentHealth = maxHealth;
    currentMana = maxMana;
  }

  // Прокачка навыков
  void improveHealth() {
    if (skillPoints > 0) {
      maxHealth += 10;
      currentHealth += 10;
      skillPoints--;
    }
  }

  void improveDamage() {
    if (skillPoints > 0) {
      baseDamage += 2;
      skillPoints--;
    }
  }

  void improveCritical() {
    if (skillPoints > 0 && criticalChance < 30) {
      criticalChance += 2;
      skillPoints--;
    }
  }

  void improveDodge() {
    if (skillPoints > 0 && dodgeChance < 25) {
      dodgeChance += 2;
      skillPoints--;
    }
  }

  @override
  String toString() {
    return 'Character{name: $name, race: $race, class: $characterClass, level: $level}';
  }
}