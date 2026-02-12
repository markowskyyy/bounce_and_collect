import 'package:bounce_and_collect/core/consts/design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.platform,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Игра'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Достижения'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'О нас'),
        ],
      ),
    );
  }
}