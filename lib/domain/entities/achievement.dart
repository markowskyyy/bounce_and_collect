class Achievement {
  final String id, title, description, icon;
  final int targetValue, currentValue;
  final bool isUnlocked;

  const Achievement({
    required this.id, required this.title, required this.description, required this.icon,
    required this.targetValue, required this.currentValue, required this.isUnlocked
  });

  double get progress => (currentValue / targetValue).clamp(0.0, 1.0);

  Achievement copyWith({int? currentValue, bool? isUnlocked}) => Achievement(
    id: id, title: title, description: description, icon: icon,
    targetValue: targetValue,
    currentValue: currentValue ?? this.currentValue,
    isUnlocked: isUnlocked ?? this.isUnlocked,
  );

  Achievement addProgress(int amount) {
    if (isUnlocked) return this;
    final newValue = currentValue + amount;
    return copyWith(
      currentValue: newValue,
      isUnlocked: newValue >= targetValue,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'currentValue': currentValue, 'isUnlocked': isUnlocked
  };

  factory Achievement.fromJson(Map<String, dynamic> json, Achievement template) {
    return template.copyWith(
      currentValue: json['currentValue'] ?? 0,
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }

  static List<Achievement> get all => [
    Achievement(id: 'score_10', title: 'Новичок', description: '10 очков', icon: '🌟', targetValue: 10, currentValue: 0, isUnlocked: false),
    Achievement(id: 'score_50', title: 'Профи', description: '50 очков', icon: '💫', targetValue: 50, currentValue: 0, isUnlocked: false),
    Achievement(id: 'score_100', title: 'Мастер', description: '100 очков', icon: '👑', targetValue: 100, currentValue: 0, isUnlocked: false),
    Achievement(id: 'games_5', title: 'Игрок', description: '5 игр', icon: '🎮', targetValue: 5, currentValue: 0, isUnlocked: false),
  ];
}