import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_screen.dart';
import '../providers/providers.dart';
import '../models/character.dart';

class CreateCharacterScreen extends ConsumerStatefulWidget {
  const CreateCharacterScreen({super.key});

  @override
  ConsumerState<CreateCharacterScreen> createState() => _CreateCharacterScreenState();
}

class _CreateCharacterScreenState extends ConsumerState<CreateCharacterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  CharacterClass _selectedClass = CharacterClass.warrior;
  CharacterRace _selectedRace = CharacterRace.human;
  CharacterGender _selectedGender = CharacterGender.male;
  
  int _strength = 3;
  int _agility = 3;
  int _intelligence = 3;
  int _luck = 3;
  int _availablePoints = 5;

  final Map<CharacterClass, String> _classDescriptions = {
    CharacterClass.warrior: 'Сильный воин. Высокое здоровье и урон.',
    CharacterClass.archer: 'Ловкий стрелок. Высокая точность и криты.',
    CharacterClass.mage: 'Мудрый маг. Сильная магия и интеллект.',
  };

  final Map<CharacterRace, String> _raceDescriptions = {
    CharacterRace.human: 'Универсальная раса. Сбалансированные характеристики.',
    CharacterRace.elf: 'Изящные эльфы. Высокий интеллект и ловкость.',
    CharacterRace.orc: 'Сильные орки. Мощная сила и здоровье.',
    CharacterRace.goblin: 'Хитрые гоблины. Удача и проворство.',
  };

  final Map<CharacterRace, Map<String, int>> _raceBonuses = {
    CharacterRace.human: {'Сила': 1, 'Ловкость': 1, 'Интеллект': 1, 'Удача': 1},
    CharacterRace.elf: {'Сила': 0, 'Ловкость': 2, 'Интеллект': 2, 'Удача': 0},
    CharacterRace.orc: {'Сила': 3, 'Ловкость': 0, 'Интеллект': 0, 'Удача': 1},
    CharacterRace.goblin: {'Сила': 0, 'Ловкость': 2, 'Интеллект': 0, 'Удача': 3},
  };

  void _createCharacter() {
    if (_formKey.currentState!.validate() && _availablePoints == 0) {
      // Создаем персонажа с выбранными характеристиками
      final character = Character(
        name: _nameController.text.trim(),
        characterClass: _selectedClass,
        race: _selectedRace,
        gender: _selectedGender,
        maxHealth: 50 + _strength * 2,
        maxMana: 30 + _intelligence * 2,
        baseDamage: 8 + _strength,
        strength: _strength,
        agility: _agility,
        intelligence: _intelligence,
        luck: _luck,
        availablePoints: 0,
      );

      ref.read(characterProvider.notifier).saveCharacter(character);
      ref.read(gameStateProvider.notifier).saveGameState(
            GameState(lastSaveTime: DateTime.now()),
          );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GameScreen()),
      );
    } else if (_availablePoints > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Распределите все очки характеристик!')),
      );
    }
  }

  void _increaseStat(String stat) {
    if (_availablePoints > 0) {
      setState(() {
        switch (stat) {
          case 'strength':
            _strength++;
            break;
          case 'agility':
            _agility++;
            break;
          case 'intelligence':
            _intelligence++;
            break;
          case 'luck':
            _luck++;
            break;
        }
        _availablePoints--;
      });
    }
  }

  void _decreaseStat(String stat) {
    setState(() {
      switch (stat) {
        case 'strength':
          if (_strength > 3) {
            _strength--;
            _availablePoints++;
          }
          break;
        case 'agility':
          if (_agility > 3) {
            _agility--;
            _availablePoints++;
          }
          break;
        case 'intelligence':
          if (_intelligence > 3) {
            _intelligence--;
            _availablePoints++;
          }
          break;
        case 'luck':
          if (_luck > 3) {
            _luck--;
            _availablePoints++;
          }
          break;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Создание персонажа')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Имя персонажа
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Имя персонажа',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите имя персонажа';
                  }
                  if (value.length < 2) {
                    return 'Имя должно быть длиннее 2 символов';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Пол персонажа
              const Text('Пол:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildGenderButton(CharacterGender.male, 'Мужской', Icons.male),
                  _buildGenderButton(CharacterGender.female, 'Женский', Icons.female),
                ],
              ),
              const SizedBox(height: 20),

              // Раса персонажа
              const Text('Раса:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildRaceButton(CharacterRace.human, 'Человек'),
                  _buildRaceButton(CharacterRace.elf, 'Эльф'),
                  _buildRaceButton(CharacterRace.orc, 'Орк'),
                  _buildRaceButton(CharacterRace.goblin, 'Гоблин'),
                ],
              ),
              const SizedBox(height: 10),
              Text(_raceDescriptions[_selectedRace]!),
              Text('Бонусы: ${_raceBonuses[_selectedRace]!.entries.map((e) => '${e.key}: +${e.value}').join(', ')}'),
              const SizedBox(height: 20),

              // Класс персонажа
              const Text('Класс:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildClassButton(CharacterClass.warrior, 'Воин', Icons.security),
                  _buildClassButton(CharacterClass.archer, 'Лучник', Icons.arrow_circle_up),
                  _buildClassButton(CharacterClass.mage, 'Маг', Icons.auto_awesome),
                ],
              ),
              const SizedBox(height: 10),
              Text(_classDescriptions[_selectedClass]!),
              const SizedBox(height: 20),

              // Характеристики
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Характеристики:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Очков для распределения: $_availablePoints',
                        style: TextStyle(
                          color: _availablePoints > 0 ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildStatRow('Сила', _strength, 'strength'),
                      _buildStatRow('Ловкость', _agility, 'agility'),
                      _buildStatRow('Интеллект', _intelligence, 'intelligence'),
                      _buildStatRow('Удача', _luck, 'luck'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Кнопка создания
              ElevatedButton(
                onPressed: _createCharacter,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Создать персонажа',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(CharacterGender gender, String label, IconData icon) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 32),
          onPressed: () => setState(() => _selectedGender = gender),
          style: IconButton.styleFrom(
            backgroundColor: _selectedGender == gender ? Colors.blue : Colors.grey[300],
            foregroundColor: _selectedGender == gender ? Colors.white : Colors.black,
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildRaceButton(CharacterRace race, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedRace == race,
      onSelected: (selected) => setState(() => _selectedRace = race),
    );
  }

  Widget _buildClassButton(CharacterClass cls, String label, IconData icon) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 32),
          onPressed: () => setState(() => _selectedClass = cls),
          style: IconButton.styleFrom(
            backgroundColor: _selectedClass == cls ? Colors.blue : Colors.grey[300],
            foregroundColor: _selectedClass == cls ? Colors.white : Colors.black,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildStatRow(String name, int value, String stat) {
    return Row(
      children: [
        Expanded(child: Text('$name: $value')),
        IconButton(
          icon: const Icon(Icons.remove, size: 20),
          onPressed: () => _decreaseStat(stat),
        ),
        IconButton(
          icon: const Icon(Icons.add, size: 20),
          onPressed: () => _increaseStat(stat),
        ),
      ],
    );
  }
}