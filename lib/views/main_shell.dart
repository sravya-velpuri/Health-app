import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'workout_screen.dart';
import 'meal_screen.dart';
import 'water_screen.dart';
import 'sleep_screen.dart';
import 'profile_screen.dart';
import '../services/localization_service.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    WorkoutScreen(),
    MealScreen(),
    WaterScreen(),
    SleepScreen(),
    ProfileScreen(),
  ];

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.fitness_center_outlined, selectedIcon: Icons.fitness_center, label: 'Workouts'),
    _NavItem(icon: Icons.restaurant_outlined, selectedIcon: Icons.restaurant, label: 'Meals'),
    _NavItem(icon: Icons.water_drop_outlined, selectedIcon: Icons.water_drop, label: 'Hydration'),
    _NavItem(icon: Icons.bedtime_outlined, selectedIcon: Icons.bedtime, label: 'Sleep'),
    _NavItem(icon: Icons.person_outline, selectedIcon: Icons.person, label: 'Profile'),
  ];

  static const List<Color> _navColors = [
    Color(0xFF4ECDC4),
    Colors.orange,
    Color(0xFF56CFE1),
    Color(0xFF4CC9F0),
    Color(0xFF7B5EA7),
    Color(0xFF2EC4B6),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1426) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = _selectedIndex == index;
                final color = _navColors[index];

                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 16 : 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withAlpha(30) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item.selectedIcon : item.icon,
                          color: isSelected ? color : Colors.grey,
                          size: 22,
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          Text(
                            item.label.tr(context),
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
