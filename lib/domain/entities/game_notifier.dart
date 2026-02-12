import 'package:bounce_and_collect/data/services/providers.dart';
import 'package:bounce_and_collect/data/services/storage_service.dart';
import 'package:bounce_and_collect/domain/entities/game_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Провайдер для доступа к GameNotifier
final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier(ref.read(storageServiceProvider));
});

class GameNotifier extends StateNotifier<GameState> {
  final StorageService _storage;

  GameNotifier(this._storage) : super(GameState.initial());

  // ============ ДВИЖЕНИЕ МЯЧА ============
  void moveBall(double screenWidth, double screenHeight) {
    if (state.isGameOver) return;

    // 1. Двигаем мяч
    var ball = state.ball.move();

    // 2. Отскок от стен
    if (ball.x <= 0.03) {
      ball = ball.copyWith(x: 0.03, speedX: -ball.speedX);
    } else if (ball.x >= 0.97) {
      ball = ball.copyWith(x: 0.97, speedX: -ball.speedX);
    }

    if (ball.y <= 0.03) {
      ball = ball.copyWith(y: 0.03, speedY: -ball.speedY);
    }

    // 3. Отскок от платформы
    final platformWidth = screenWidth * 0.2 / screenWidth; // относительная ширина
    if (ball.hitPlatform(state.platformX, platformWidth)) {
      ball = ball.copyWith(speedY: -ball.speedY.abs()); // всегда вверх
      state = state.addScore();
    }

    // 4. Проверка проигрыша
    if (ball.y >= 1.0) {
      state = state.gameOver();
      _saveGameResults();
    } else {
      state = state.copyWith(ball: ball);
    }
  }

  // ============ ДВИЖЕНИЕ ПЛАТФОРМЫ ============
  void movePlatform(double deltaX, double screenWidth) {
    final newX = state.platformX + (deltaX / screenWidth);
    final clampedX = newX.clamp(0.0, 0.8); // не выходим за края
    state = state.copyWith(platformX: clampedX);
  }

  // ============ РЕСТАРТ ============
  void restart() {
    state = GameState.initial();
  }

  // ============ СОХРАНЕНИЕ РЕЗУЛЬТАТОВ ============
  Future<void> _saveGameResults() async {
    // Сохраняем рекорд
    await _storage.updateHighScore(state.score);

    // Увеличиваем счетчик игр
    await _storage.incrementGamesPlayed();

    // Сохраняем общий счет
    await _storage.addTotalScore(state.score);
  }

  // ============ ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ============
  void resetGame() {
    state = GameState.initial();
  }
}