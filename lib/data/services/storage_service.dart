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

    final stringToSave = data.toString();
    print('💾 saveAchievements: $stringToSave');
    await prefs.setString(_achievementsKey, stringToSave);
  }

  /// Загрузить прогресс достижений
  Future<Map<String, int>> loadAchievements() async {
    final prefs = await _getPrefs();
    final String? savedString = prefs.getString(_achievementsKey);

    print('📂 loadAchievements raw: "$savedString"');

    if (savedString == null || savedString.isEmpty || savedString == '{}') {
      return {};
    }

    try {
      final Map<String, int> result = {};
      // Убираем { и }
      final cleaned = savedString.replaceAll('{', '').replaceAll('}', '');
      if (cleaned.isEmpty) return {};

      // Разбираем "score_10: 2, score_50: 2, score_100: 2"
      final pairs = cleaned.split(', ');

      for (var pair in pairs) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          final key = parts[0].trim();
          final value = int.tryParse(parts[1].trim()) ?? 0;
          result[key] = value;
        }
      }

      print('📂 loadAchievements parsed: $result');
      return result;
    } catch (e) {
      print('❌ Ошибка парсинга: $e');
      return {};
    }
  }

  Future<void> updateAchievement(String id, int value) async {
    print('🔄 updateAchievement START: $id = $value');

    final prefs = await _getPrefs();

    // 1️⃣ ЧИТАЕМ НАПРЯМУЮ ИЗ PREFS, А НЕ ЧЕРЕЗ loadAchievements
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
        print('❌ Ошибка парсинга: $e');
      }
    }

    print('📦 Текущие achievements: $achievements');

    // 2️⃣ Обновляем ТОЛЬКО одно
    achievements[id] = value;
    print('📦 После обновления: $achievements');

    // 3️⃣ Сохраняем ВСЁ
    final stringToSave = achievements.toString();
    print('💾 Сохраняем строку: "$stringToSave"');

    await prefs.setString(_achievementsKey, stringToSave);

    // 4️⃣ Проверяем, что сохранилось
    final savedBack = prefs.getString(_achievementsKey);
    print('✅ Проверка сохранения: "$savedBack"');

    print('🔄 updateAchievement END');
  }

  /// Сбросить все достижения
  Future<void> resetAchievements() async {
    final prefs = await _getPrefs();
    await prefs.remove(_achievementsKey);
    print('🗑️ Achievements сброшены');
  }

  /// Сохранить количество сыгранных игр (+1)
  Future<int> incrementGamesPlayed() async {
    final prefs = await _getPrefs();
    final current = prefs.getInt(_gamesPlayedKey) ?? 0;
    final newValue = current + 1;
    await prefs.setInt(_gamesPlayedKey, newValue);
    print('🎮 gamesPlayed: $current -> $newValue');
    return newValue;
  }

  /// Загрузить количество сыгранных игр
  Future<int> loadGamesPlayed() async {
    final prefs = await _getPrefs();
    final value = prefs.getInt(_gamesPlayedKey) ?? 0;
    print('📊 loadGamesPlayed: $value');
    return value;
  }

  /// Сохранить рекорд (только если больше текущего)
  Future<void> updateHighScore(int score) async {
    final prefs = await _getPrefs();
    final current = prefs.getInt(_highScoreKey) ?? 0;

    if (score > current) {
      await prefs.setInt(_highScoreKey, score);
      print('🏆 highScore: $current -> $score');
    }
  }

  /// Загрузить рекорд
  Future<int> loadHighScore() async {
    final prefs = await _getPrefs();
    final value = prefs.getInt(_highScoreKey) ?? 0;
    print('🏆 loadHighScore: $value');
    return value;
  }

  /// Добавить очки к общему счету
  Future<void> addTotalScore(int score) async {
    final prefs = await _getPrefs();
    final current = prefs.getInt(_totalScoreKey) ?? 0;
    final newValue = current + score;
    await prefs.setInt(_totalScoreKey, newValue);
    print('💰 totalScore: $current -> $newValue');
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
    print('🧹 Все данные очищены');
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