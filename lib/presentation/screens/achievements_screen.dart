import 'package:bounce_and_collect/core/consts/design.dart';
import 'package:bounce_and_collect/data/services/providers.dart';
import 'package:bounce_and_collect/domain/entities/achievement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsFutureProvider);
    final gamesPlayedAsync = ref.watch(gamesPlayedProvider);
    final highScoreAsync = ref.watch(highScoreProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Достижения'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: achievementsAsync.when(
        data: (achievements) {
          final unlockedCount = achievements.where((a) => a.isUnlocked).length;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: AppColors.card,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      '🏆',
                      highScoreAsync.value?.toString() ?? '0',
                      'Рекорд',
                    ),
                    _buildStatCard(
                      '🎮',
                      gamesPlayedAsync.value?.toString() ?? '0',
                      'Игр',
                    ),
                    _buildStatCard(
                      '⭐',
                      '$unlockedCount/${achievements.length}',
                      'Получено',
                    ),
                  ],
                ),
              ),

              // Список достижений
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    final a = achievements[index];
                    return _buildAchievementCard(a);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Ошибка загрузки')),
      ),
    );
  }

  Widget _buildStatCard(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white70)),
      ],
    );
  }

  Widget _buildAchievementCard(Achievement a) {
    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Иконка
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: a.isUnlocked ? AppColors.platform : Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(a.icon, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),

            // Информация
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          a.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: a.isUnlocked ? AppColors.platform : Colors.white,
                          ),
                        ),
                      ),
                      if (a.isUnlocked)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Получено',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    a.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  if (!a.isUnlocked) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: a.progress,
                              backgroundColor: Colors.grey.shade800,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.platform),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${a.currentValue}/${a.targetValue}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}