import 'ball.dart';

class GameState {
  final Ball ball;
  final double platformX;
  final int score;
  final bool isGameOver;

  const GameState({required this.ball, required this.platformX, required this.score, required this.isGameOver});

  factory GameState.initial() => GameState(
      ball: Ball.initial(), platformX: 0.4, score: 0, isGameOver: false
  );

  GameState copyWith({Ball? ball, double? platformX, int? score, bool? isGameOver}) => GameState(
    ball: ball ?? this.ball,
    platformX: platformX ?? this.platformX,
    score: score ?? this.score,
    isGameOver: isGameOver ?? this.isGameOver,
  );

  GameState addScore() => GameState(
      ball: ball, platformX: platformX, score: score + 1, isGameOver: isGameOver
  );

  GameState restart() => GameState.initial();
  GameState gameOver() => GameState(ball: ball, platformX: platformX, score: score, isGameOver: true);
}