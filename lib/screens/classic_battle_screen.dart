import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/enemy.dart';
import '../models/character.dart';
import '../services/achievement_service.dart';
import '../services/quest_service.dart';

class ClassicBattleScreen extends ConsumerStatefulWidget {
  final EnemyType enemyType;

  const ClassicBattleScreen({super.key, required this.enemyType});

  @override
  ConsumerState<ClassicBattleScreen> createState() => _ClassicBattleScreenState();
}

class _ClassicBattleScreenState extends ConsumerState<ClassicBattleScreen> {
  late Enemy _enemy;
  late Character _character;
  
  Map<String, bool> _attacks = {
    'удар в голову': false,
    'удар в грудь': false,
    'удар в живот': false,
    'удар в пояс(пак)': false,
    'удар по ногам': false,
  };

  String? _selectedDefense;

  @override
  void initState() {
    super.initState();
    _enemy = Enemy.create(widget.enemyType);
    _character = ref.read(characterProvider)!;
  }

  void _executeAttack() {
    final selectedAttacks = _attacks.entries.where((e) => e.value).map((e) => e.key).toList();

    if (selectedAttacks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы один удар!')),
      );
      return;
    }

    if (_selectedDefense == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите защиту!')),
      );
      return;
    }

    int damage = _character.attack() * selectedAttacks.length;
    _enemy.takeDamage(damage);

    int enemyDamage = _enemy.attack();
    _character.takeDamage(enemyDamage);

    ref.read(characterProvider.notifier).saveCharacter(_character);

    setState(() {
      _attacks = _attacks.map((key, value) => MapEntry(key, false));
      _selectedDefense = null;
    });

    if (!_enemy.isAlive) {
      _showVictory();
    } else if (_character.currentHealth <= 0) {
      _showDefeat();
    }
  }

  void _showVictory() async {
    // Разблокируем достижение "Первая кровь"
    await AchievementService.unlockAchievement('ach_first_victory');
    
    // Обновляем прогресс квестов
    await QuestService.updateAfterCombat(_enemy.name, _enemy.goldReward);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Победа!'),
        content: Text('Вы победили ${_enemy.name} и получили ${_enemy.goldReward} золота!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Бой с ${_enemy.name}'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Заголовок
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.blue[800],
                  child: const Text(
                    'Бойцовский клуб',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                // Имя игрока
                Text(
                  _character.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Удары
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: _attacks.entries.map((entry) {
                        return CheckboxListTile(
                          title: Text(entry.key),
                          value: entry.value,
                          onChanged: (value) {
                            setState(() {
                              _attacks[entry.key] = value!;
                            });
                          },
                          dense: true,
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),

                // Противник
                Text(
                  '${_enemy.name} [${_enemy.currentHealth}/${_enemy.maxHealth}]',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Защита
                const Text(
                  'Защита',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Варианты защиты
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildDefenseOption('блок головы, груди и живота'),
                        _buildDefenseOption('блок груди, живота и пояса'),
                        _buildDefenseOption('блок живота, пояса и ног'),
                        _buildDefenseOption('блок пояса, ног и головы'),
                        _buildDefenseOption('блок ног, головы и груди'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),

                // Статус
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          'Ваше здоровье: ${_character.currentHealth}/${_character.maxHealth}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _character.currentHealth < 30 ? Colors.red : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Здоровье ${_enemy.name}: ${_enemy.currentHealth}/${_enemy.maxHealth}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Кнопка атаки
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _executeAttack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Атаковать'),
                  ),
                ),

                const SizedBox(height: 10),

                // Кнопка назад
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Бежать из боя'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefenseOption(String title) {
    return RadioListTile<String>(
      title: Text(title),
      value: title,
      groupValue: _selectedDefense,
      onChanged: (value) {
        setState(() {
          _selectedDefense = value;
        });
      },
      dense: true,
    );
  }
}