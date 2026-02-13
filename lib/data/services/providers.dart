import 'package:bounce_and_collect/domain/entities/achievement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage_service.dart';


/// Провайдер для StorageService
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// FutureProvider для загрузки достижений
final achievementsFutureProvider = FutureProvider<List<Achievement>>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  final savedData = await storage.loadAchievements();
  final gamesPlayed = await storage.loadGamesPlayed();

  final achievements = Achievement.all.map((template) {
    final savedValue = savedData[template.id] ?? 0;

    if (template.id == 'games_5' || template.id == 'games_20') {
      return template.copyWith(
        currentValue: gamesPlayed,
        isUnlocked: gamesPlayed >= template.targetValue,
      );
    }

    return template.copyWith(
      currentValue: savedValue,
      isUnlocked: savedValue >= template.targetValue,
    );
  }).toList();

  return achievements;
});

/// Провайдер для StateProvider с ачивками (для обновления в реальном времени)
final achievementsProvider = StateProvider<List<Achievement>>((ref) {
  return Achievement.all;
});

/// Провайдер для количества игр
final gamesPlayedProvider = FutureProvider<int>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  return await storage.loadGamesPlayed();
});

/// Провайдер для рекорда
final highScoreProvider = FutureProvider<int>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  return await storage.loadHighScore();
});

/// StateNotifier для управления достижениями
final achievementsNotifierProvider = StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  return AchievementsNotifier(ref);
});

class AchievementsNotifier extends StateNotifier<List<Achievement>> {
  final Ref ref;

  AchievementsNotifier(this.ref) : super(Achievement.all) {
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final storage = ref.read(storageServiceProvider);
    final savedData = await storage.loadAchievements();
    final gamesPlayed = await storage.loadGamesPlayed();

    final updated = state.map((a) {
      if (a.id == 'games_5' || a.id == 'games_20') {
        return a.copyWith(
          currentValue: gamesPlayed,
          isUnlocked: gamesPlayed >= a.targetValue,
        );
      }

      final savedValue = savedData[a.id] ?? 0;
      return a.copyWith(
        currentValue: savedValue,
        isUnlocked: savedValue >= a.targetValue,
      );
    }).toList();

    state = updated;
  }

  /// Добавление прогресса к достижению
  Future<void> addProgress(String id, int amount) async {
    final storage = ref.read(storageServiceProvider);

    final index = state.indexWhere((a) => a.id == id);
    if (index == -1) return;

    final achievement = state[index];
    if (achievement.isUnlocked) return;

    final updated = achievement.addProgress(amount);
    final newState = [...state];
    newState[index] = updated;
    state = newState;

    // Сохраняем в SharedPreferences
    await storage.updateAchievement(id, updated.currentValue);
  }

  /// Обновление прогресса по очкам
  Future<void> updateScoreProgress(int score) async {
    await addProgress('score_10', score);
    await addProgress('score_50', score);
    await addProgress('score_100', score);

    final storage = ref.read(storageServiceProvider);
    await storage.updateHighScore(score);
    await storage.addTotalScore(score);
  }

  /// Обновить прогресс по играм
  Future<void> incrementGamesPlayed() async {
    final storage = ref.read(storageServiceProvider);
    final gamesPlayed = await storage.incrementGamesPlayed();

    final updated = state.map((a) {
      if (a.id == 'games_5' || a.id == 'games_20') {
        final isUnlocked = gamesPlayed >= a.targetValue;
        return a.copyWith(
          currentValue: gamesPlayed,
          isUnlocked: isUnlocked,
        );
      }
      return a;
    }).toList();

    state = updated;
    await storage.saveAchievements(state);
  }

  /// Сбросить все достижения
  Future<void> resetAll() async {
    final storage = ref.read(storageServiceProvider);
    await storage.resetAchievements();

    state = Achievement.all;
  }
}