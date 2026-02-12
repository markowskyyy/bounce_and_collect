import 'package:bounce_and_collect/core/consts/design.dart';
import 'package:bounce_and_collect/domain/entities/game_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_updateGame);
    _animationController.repeat();
  }

  void _updateGame() {
    final size = MediaQuery.of(context).size;
    ref.read(gameProvider.notifier).moveBall(size.width, size.height);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameProvider);
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        ref.read(gameProvider.notifier).movePlatform(details.delta.dx, size.width);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Text(
                '${state.score}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Positioned(
              left: size.width * state.ball.x - 15,
              top: size.height * state.ball.y - 15,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: size.width * state.platformX,
              bottom: 50,
              child: Container(
                width: size.width * 0.2,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.platform,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            if (state.isGameOver) _buildGameOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverlay() {
    final state = ref.watch(gameProvider);

    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Счет: ${state.score}',
                style: const TextStyle(fontSize: 24, color: Colors.white70),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => ref.read(gameProvider.notifier).restart(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.platform,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Играть снова', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}