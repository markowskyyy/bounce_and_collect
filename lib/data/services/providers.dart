import 'package:bounce_and_collect/domain/achievements_notifier.dart';
import 'package:bounce_and_collect/domain/entities/achievement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage_service.dart';

/// Провайдер для StorageService
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Провайдер для достижений (StateNotifier)
final achievementsProvider = StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  return AchievementsNotifier(ref.read(storageServiceProvider));
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