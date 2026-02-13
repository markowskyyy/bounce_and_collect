import 'package:bounce_and_collect/data/services/providers.dart';
import 'package:bounce_and_collect/data/services/storage_service.dart';
import 'package:bounce_and_collect/domain/entities/game_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier(ref);
});

class GameNotifier extends StateNotifier<GameState> {
  final Ref _ref;

  GameNotifier(this._ref) : super(GameState.initial());

  StorageService get _storage => _ref.read(storageServiceProvider);

  void moveBall(double screenWidth, double screenHeight) {
    if (state.isGameOver) return;

    var ball = state.ball.move();

    if (ball.x <= 0.03) {
      ball = ball.copyWith(x: 0.03, speedX: -ball.speedX);
    } else if (ball.x >= 0.97) {
      ball = ball.copyWith(x: 0.97, speedX: -ball.speedX);
    }

    if (ball.y <= 0.03) {
      ball = ball.copyWith(y: 0.03, speedY: -ball.speedY);
    }

    final platformWidth = screenWidth * 0.2 / screenWidth;
    if (ball.hitPlatform(state.platformX, platformWidth)) {
      ball = ball.copyWith(speedY: -ball.speedY.abs());
      state = state.addScore();
    }

    if (ball.y >= 1.0) {
      state = state.gameOver();
      _saveGameResults();
    } else {
      state = state.copyWith(ball: ball);
    }
  }

  void movePlatform(double deltaX, double screenWidth) {
    final newX = state.platformX + (deltaX / screenWidth);
    final clampedX = newX.clamp(0.0, 0.8);
    state = state.copyWith(platformX: clampedX);
  }

  void restart() {
    state = GameState.initial();
  }

  Future<void> _saveGameResults() async {
    await _storage.updateHighScore(state.score);
    await _storage.addTotalScore(state.score);

    final achievements = _ref.read(achievementsProvider.notifier);
    await achievements.updateScoreProgress(state.score);
    await achievements.incrementGamesPlayed();

    _ref.refresh(gamesPlayedProvider);
    _ref.refresh(highScoreProvider);
  }
}