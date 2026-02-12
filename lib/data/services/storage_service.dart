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

    // Сохраняем только нужные поля: id -> currentValue
    final Map<String, int> data = {};
    for (var a in achievements) {
      data[a.id] = a.currentValue;
    }

    await prefs.setString(_achievementsKey, data.toString());
  }

  /// Загрузить прогресс достижений
  Future<Map<String, int>> loadAchievements() async {
    final prefs = await _getPrefs();
    final String? savedData = prefs.getString(_achievementsKey);

    if (savedData == null || savedData.isEmpty) {
      return {};
    }

    try {
      // Парсим строку вида "{score_10: 5, score_50: 0}"
      final cleaned = savedData.replaceAll('{', '').replaceAll('}', '');
      if (cleaned.isEmpty) return {};

      final Map<String, int> result = {};
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

  /// Обновить конкретное достижение
  Future<void> updateAchievement(String id, int value) async {
    final achievements = await loadAchievements();
    achievements[id] = value;

    final prefs = await _getPrefs();
    await prefs.setString(_achievementsKey, achievements.toString());
  }

  /// Сбросить все достижения
  Future<void> resetAchievements() async {
    final prefs = await _getPrefs();
    await prefs.remove(_achievementsKey);
  }

  // ============ ИГРОВАЯ СТАТИСТИКА ============

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
    return prefs.getInt(_gamesPlayedKey) ?? 0;
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
    return prefs.getInt(_highScoreKey) ?? 0;
  }


  /// Добавить очки к общему счету
  Future<void> addTotalScore(int score) async {
    final prefs = await _getPrefs();
    final current = prefs.getInt(_totalScoreKey) ?? 0;
    await prefs.setInt(_totalScoreKey, current + score);
  }

  /// Загрузить общий счет
  Future<int> loadTotalScore() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_totalScoreKey) ?? 0;
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