import 'package:bounce_and_collect/presentation/screens/about_screen.dart';
import 'package:bounce_and_collect/presentation/screens/achievements_screen.dart';
import 'package:bounce_and_collect/presentation/screens/game_screen.dart';
import 'package:bounce_and_collect/presentation/screens/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/about',
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'game',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: GameScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/achievements',
                name: 'achievements',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AchievementsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/about',
                name: 'about',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AboutScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});