import 'package:flutter/material.dart';

class AppColors {
  // Основные
  static const Color background = Color(0xFF0A0E21);
  static const Color surface = Color(0xFF1D1E33);
  static const Color primary = Color(0xFF4FC3F7);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color card = Color(0xFF1D1E33);

  // Состояния
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);

  // Текст
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textDisabled = Colors.white38;

  // Игровые объекты
  static const Color ball = Colors.white;              // Мяч
  static const Color platform = primary;               // Платформа
}

// ============ ТЕКСТ ============
class AppTextStyles {
  // Заголовки
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Игровой счет
  static const TextStyle gameScore = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 2,
    shadows: [
      Shadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 2),
      ),
    ],
  );

  static const TextStyle gameOver = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.error,
    letterSpacing: 1,
  );

  // Обычный текст
  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textDisabled,
  );

  // Достижения
  static const TextStyle achievementTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle achievementProgress = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  // Кнопки
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
}

// ============ ТЕМА ============
class AppTheme {
  static ThemeData get dark {
    return ThemeData.dark().copyWith(
      // Основные цвета
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.title,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),

      // Карточки
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
      ),

      // Кнопки
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textDisabled,
        selectedLabelStyle: AppTextStyles.bodySmall,
        unselectedLabelStyle: AppTextStyles.bodySmall,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: Colors.white24,
        thickness: 1,
        space: 1,
      ),
    );
  }
}

class AppSizes {
  // Отступы
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Скругления
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusCircle = 999.0;

  // Игровые объекты
  static const double ballSize = 30.0;
  static const double platformHeight = 10.0;
  static const double platformWidthRelative = 0.2; // 20% от ширины экрана

  // BottomNavigationBar
  static const double bottomNavHeight = 60.0;
}

// ============ ТЕНИ ============
class AppShadows {
  static List<BoxShadow> get small => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get medium => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get large => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get gameOverlay => [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 20,
      spreadRadius: 5,
    ),
  ];
}

class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
}

// ============ ИКОНКИ ============
class AppIcons {
  // Навигация
  static const IconData game = Icons.sports_esports;
  static const IconData achievements = Icons.emoji_events;
  static const IconData about = Icons.info;
  static const IconData home = Icons.home;

  // Игра
  static const IconData restart = Icons.refresh;
  static const IconData play = Icons.play_arrow;
  static const IconData pause = Icons.pause;

  // Достижения
  static const IconData locked = Icons.lock;
  static const IconData unlocked = Icons.check_circle;
  static const IconData progress = Icons.trending_up;

  // Общие
  static const IconData settings = Icons.settings;
  static const IconData share = Icons.share;
  static const IconData close = Icons.close;
}