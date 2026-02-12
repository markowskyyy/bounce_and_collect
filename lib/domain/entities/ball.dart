class Ball {
  final double x, y, speedX, speedY;

  const Ball({required this.x, required this.y, required this.speedX, required this.speedY});

  factory Ball.initial() => const Ball(x: 0.5, y: 0.2, speedX: 0.012, speedY: 0.012);

  Ball copyWith({double? x, double? y, double? speedX, double? speedY}) => Ball(
      x: x ?? this.x, y: y ?? this.y, speedX: speedX ?? this.speedX, speedY: speedY ?? this.speedY
  );

  Ball move() => Ball(x: x + speedX, y: y + speedY, speedX: speedX, speedY: speedY);
  Ball reverseX() => Ball(x: x, y: y, speedX: -speedX, speedY: speedY);
  Ball reverseY() => Ball(x: x, y: y, speedX: speedX, speedY: -speedY);

  bool hitPlatform(double platformX, double width) {
    final ballHeight = 0.03;
    return y >= (0.84 - ballHeight) && y <= (0.86 - ballHeight) && x + 0.03 >= platformX && x - 0.03 <= platformX + width;
  }

  bool isGameOver() => y >= 1.0;
}