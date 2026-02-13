import 'package:bounce_and_collect/data/services/storage_service.dart';
import 'package:bounce_and_collect/domain/entities/achievement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AchievementsNotifier extends StateNotifier<List<Achievement>> {
  final StorageService _storage;

  AchievementsNotifier(this._storage) : super(Achievement.all) {
    _loadAchievements();
  }

  // ============ ЗАГРУЗКА ============
  Future<void> _loadAchievements() async {
    print('========== ЗАГРУЗКА ДОСТИЖЕНИЙ ==========');

    final savedData = await _storage.loadAchievements();
    final gamesPlayed = await _storage.loadGamesPlayed();

    final updated = state.map((template) {
      if (template.id == 'games_5') {
        return template.copyWith(
          currentValue: gamesPlayed,
          isUnlocked: gamesPlayed >= template.targetValue,
        );
      }

      final savedValue = savedData[template.id] ?? 0;
      return template.copyWith(
        currentValue: savedValue,
        isUnlocked: savedValue >= template.targetValue,
      );
    }).toList();

    state = updated;
    print('📊 state обновлен: ${state.map((a) => '${a.id}: ${a.currentValue}/${a.targetValue}')}');
    print('==========================================');
  }

  // ============ ОБНОВЛЕНИЕ ОЧКОВ ============
  Future<void> updateScoreProgress(int score) async {
    print('🏆 updateScoreProgress: score=$score');

    final newState = state.map((a) {
      print('a $a');
      if (a.id == 'score_10' || a.id == 'score_50' || a.id == 'score_100') {
        final updated = a.addProgress(score);
        _storage.updateAchievement(a.id, updated.currentValue);
        print('  ✅ Сохраняем ${a.id} = ${updated.currentValue}');
        return updated;
      }
      return a;
    }).toList();

    state = newState;
  }

  // ============ ОБНОВЛЕНИЕ ИГР ============
  Future<void> incrementGamesPlayed() async {
    final gamesPlayed = await _storage.incrementGamesPlayed();

    final newState = state.map((a) {
      if (a.id == 'games_5') {
        final isUnlocked = gamesPlayed >= a.targetValue;
        return a.copyWith(
          currentValue: gamesPlayed,
          isUnlocked: isUnlocked,
        );
      }
      return a;
    }).toList();

    state = newState;
  }

  // ============ СБРОС ============
  Future<void> resetAll() async {
    await _storage.resetAchievements();
    state = Achievement.all;
    await _loadAchievements();
  }
}