import 'package:bounce_and_collect/domain/entities/achievement.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _achievementsKey = 'achievements';
  static const String _gamesPlayedKey = 'games_played';
  static const String _highScoreKey = 'high_score';
  static const String _totalScoreKey = 'total_score';

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  /// Сохранить прогресс достижений
  Future<void> saveAchievements(List<Achievement> achievements) async {
    final prefs = await _getPrefs();

    final Map<String, int> data = {};
    for (var a in achievements) {
      data[a.id] = a.currentValue;
    }

    final stringToSave = data.toString();
    await prefs.setString(_achievementsKey, stringToSave);
  }

  /// Загрузить прогресс достижений
  Future<Map<String, int>> loadAchievements() async {
    final prefs = await _getPrefs();
    final String? savedString = prefs.getString(_achievementsKey);

    if (savedString == null || savedString.isEmpty || savedString == '{}') {
      return {};
    }

    try {
      final Map<String, int> result = {};
      final cleaned = savedString.replaceAll('{', '').replaceAll('}', '');
      if (cleaned.isEmpty) return {};

      final pairs = cleaned.split(', ');

      for (var pair in pairs) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          final key = parts[0].trim();
          final value = int.tryParse(parts[1].trim()) ?? 0;
          result[key] = value;
        }
      }

      return result;
    } catch (e) {
      return {};
    }
  }

  Future<void> updateAchievement(String id, int value) async {

    final prefs = await _getPrefs();

    final String? savedString = prefs.getString(_achievementsKey);
    final Map<String, int> achievements = {};

    if (savedString != null && savedString.isNotEmpty && savedString != 'null' && savedString != '{}') {
      try {
        final cleaned = savedString.replaceAll('{', '').replaceAll('}', '');
        if (cleaned.isNotEmpty) {
          final pairs = cleaned.split(', ');
          for (var pair in pairs) {
            final parts = pair.split(':');
            if (parts.length == 2) {
              final key = parts[0].trim();
              final val = int.tryParse(parts[1].trim()) ?? 0;
              achievements[key] = val;
            }
          }
        }
      } catch (e) {
        print('Ошибка парсинга: $e');
      }
    }

    achievements[id] = value;
    final stringToSave = achievements.toString();
    await prefs.setString(_achievementsKey, stringToSave);
  }

  /// Сбросить все достижения
  Future<void> resetAchievements() async {
    final prefs = await _getPrefs();
    await prefs.remove(_achievementsKey);
  }

  /// Сохранить количество сыгранных игр (+1)
  Future<int> incrementGamesPlayed() async {
    final prefs = await _getPrefs();
    final current = prefs.getInt(_gamesPlayedKey) ?? 0;
    final newValue = current + 1;
    await prefs.setInt(_gamesPlayedKey, newValue);
    return newValue;
  }

  /// Загрузить количество сыгранных игр
  Future<int> loadGamesPlayed() async {
    final prefs = await _getPrefs();
    final value = prefs.getInt(_gamesPlayedKey) ?? 0;
    return value;
  }

  /// Сохранить рекорд (только если больше текущего)
  Future<void> updateHighScore(int score) async {
    final prefs = await _getPrefs();
    final current = prefs.getInt(_highScoreKey) ?? 0;

    if (score > current) {
      await prefs.setInt(_highScoreKey, score);
    }
  }

  /// Загрузить рекорд
  Future<int> loadHighScore() async {
    final prefs = await _getPrefs();
    final value = prefs.getInt(_highScoreKey) ?? 0;
    return value;
  }

  /// Добавить очки к общему счету
  Future<void> addTotalScore(int score) async {
    final prefs = await _getPrefs();
    final current = prefs.getInt(_totalScoreKey) ?? 0;
    final newValue = current + score;
    await prefs.setInt(_totalScoreKey, newValue);
  }

  /// Загрузить общий счет
  Future<int> loadTotalScore() async {
    final prefs = await _getPrefs();
    final value = prefs.getInt(_totalScoreKey) ?? 0;
    return value;
  }

  /// Очистить ВСЕ данные (для тестирования)
  Future<void> clearAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }

  /// Получить всю статистику одной строкой
  Future<Map<String, dynamic>> getAllStats() async {
    return {
      'gamesPlayed': await loadGamesPlayed(),
      'highScore': await loadHighScore(),
      'totalScore': await loadTotalScore(),
      'achievements': await loadAchievements(),
    };
  }
}