import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/enemy.dart';
import '../models/character.dart';
import '../services/achievement_service.dart';
import '../services/quest_service.dart';

class BattleScreenV2 extends ConsumerStatefulWidget {
  final EnemyType enemyType;

  const BattleScreenV2({super.key, required this.enemyType});

  @override
  ConsumerState<BattleScreenV2> createState() => _BattleScreenV2State();
}

class _BattleScreenV2State extends ConsumerState<BattleScreenV2> {
  late Enemy _enemy;
  late Character _character;
  
  String? _selectedAttack;
  String? _selectedDefense;
  final List<String> _battleLog = [];
  bool _playerTurn = true;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _enemy = Enemy.create(widget.enemyType);
    _character = ref.read(characterProvider)!;
    _battleLog.add('Бой начинается! ${_character.name} против ${_enemy.name}');
  }

  void _executeAttack() {
    if (_selectedAttack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите удар!')),
      );
      return;
    }

    if (_selectedDefense == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите защиту!')),
      );
      return;
    }

    // Ход игрока
    int damage = _calculateDamage(_selectedAttack!);
    final isCritical = _random.nextInt(100) < _character.criticalChance;
    final actualDamage = isCritical ? (damage * 1.5).round() : damage;
    
    _enemy.takeDamage(actualDamage);
    
    String logMessage = '${_character.name} наносит ${_enemy.name} $actualDamage урона в $_selectedAttack!';
    if (isCritical) {
      logMessage += ' КРИТИЧЕСКИЙ УДАР!';
    }
    _battleLog.add(logMessage);

    setState(() => _playerTurn = false);

    Future.delayed(const Duration(seconds: 1), () {
      if (!_enemy.isAlive) {
        _character.battlesWon++;
        _showVictory();
        return;
      }
      _enemyTurn();
    });
  }

  void _enemyTurn() {
    if (_character.tryDodge()) {
      _battleLog.add('${_character.name} уклоняется от атаки ${_enemy.name}!');
    } else {
      int enemyDamage = _enemy.attack();
      _character.takeDamage(enemyDamage);
      _battleLog.add('${_enemy.name} наносит ${_character.name} $enemyDamage урона!');
    }

    setState(() {
      _playerTurn = true;
      _selectedAttack = null;
      _selectedDefense = null;
    });

    ref.read(characterProvider.notifier).saveCharacter(_character);

    if (_character.currentHealth <= 0) {
      _character.battlesLost++;
      _showDefeat();
    }
  }

  int _calculateDamage(String attackType) {
    int baseDamage = _character.attack();
    switch (attackType) {
      case 'Голова': return (baseDamage * 1.5).round();
      case 'Корпус': return baseDamage;
      case 'Ноги': return (baseDamage * 0.8).round();
      default: return baseDamage;
    }
  }

  void _showVictory() async {
    await AchievementService.unlockAchievement('ach_first_victory');
    await QuestService.updateAfterCombat(_enemy.name, _enemy.goldReward);
    _battleLog.add('ПОБЕДА! Вы получаете ${_enemy.goldReward} золота и ${_enemy.experienceReward} опыта!');

    // Сохраняем персонажа с обновленной статистикой
    ref.read(characterProvider.notifier).saveCharacter(_character);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Победа!'),
        content: Text('Вы победили ${_enemy.name}!\n+${_enemy.goldReward} золота\n+${_enemy.experienceReward} опыта'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDefeat() {
    _battleLog.add('ПОРАЖЕНИЕ... Вы проиграли бой.');
    
    // Сохраняем персонажа с обновленной статистикой
    ref.read(characterProvider.notifier).saveCharacter(_character);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Поражение'),
        content: const Text('Вы проиграли бой...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getEnemyImage() {
    switch (_enemy.type) {
      case EnemyType.goblin: return 'assets/images/goblin.png';
      case EnemyType.orc: return 'assets/images/orc.png';
      case EnemyType.wolf: return 'assets/images/skeleton.png';
      case EnemyType.bandit: return 'assets/images/player.png';
      case EnemyType.skeleton: return 'assets/images/skeleton.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Бой с ${_enemy.name}'),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          // Верхняя часть - персонажи
          Expanded(
            flex: 3,
            child: Row(
              children: [
                // Игрок
                Expanded(
                  child: _buildCharacterCard(
                    _character.name,
                    'assets/images/player.png',
                    _character.currentHealth,
                    _character.maxHealth,
                  ),
                ),
                
                // Противник
                Expanded(
                  child: _buildCharacterCard(
                    _enemy.name,
                    _getEnemyImage(),
                    _enemy.currentHealth,
                    _enemy.maxHealth,
                  ),
                ),
              ],
            ),
          ),

          // Центральная часть - выбор удара и защиты
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                // Выбор удара
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Куда бьём?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildAttackButton('Голова'),
                      _buildAttackButton('Корпус'),
                      _buildAttackButton('Ноги'),
                    ],
                  ),
                ),

                // Выбор защиты
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Что блокируем?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildDefenseButton('Голова'),
                      _buildDefenseButton('Корпус'),
                      _buildDefenseButton('Ноги'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Кнопка атаки
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _playerTurn ? _executeAttack : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(_playerTurn ? 'УДАРИТЬ' : 'Ход противника...'),
              ),
            ),
          ),

          // Лог боя
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Colors.black87,
              ),
              child: ListView.builder(
                reverse: true,
                itemCount: _battleLog.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      _battleLog[_battleLog.length - 1 - index],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(String name, String imagePath, int currentHealth, int maxHealth) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Аватар (без обрезки в круг)
            Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            
            // Имя
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            
            // HP
            Text(
              'HP: $currentHealth/$maxHealth',
              style: TextStyle(
                color: currentHealth < maxHealth * 0.3 ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // Прогресс бар HP
            Container(
              width: 100,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: LinearProgressIndicator(
                value: currentHealth / maxHealth,
                backgroundColor: Colors.grey[300],
                color: currentHealth < maxHealth * 0.3 ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttackButton(String part) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: _playerTurn ? () => setState(() => _selectedAttack = part) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedAttack == part ? Colors.blue[800] : Colors.grey[300],
          foregroundColor: _selectedAttack == part ? Colors.white : Colors.black,
          minimumSize: const Size(double.infinity, 40),
        ),
        child: Text(part),
      ),
    );
  }

  Widget _buildDefenseButton(String part) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: _playerTurn ? () => setState(() => _selectedDefense = part) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedDefense == part ? Colors.green[800] : Colors.grey[300],
          foregroundColor: _selectedDefense == part ? Colors.white : Colors.black,
          minimumSize: const Size(double.infinity, 40),
        ),
        child: Text(part),
      ),
    );
  }
}