import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/theme_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../theme/glass_widgets.dart';
import '../services/localization_service.dart';
import 'bmi_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _tipsCtrl = PageController();
  int _currentTip = 0;

  static const List<Map<String, dynamic>> _tips = [
    {'tip': 'Drink at least 8 glasses of water daily.', 'icon': Icons.water_drop, 'color': Color(0xFF4CC9F0)},
    {'tip': 'Aim for 7–9 hours of quality sleep each night for recovery.', 'icon': Icons.bedtime, 'color': Color(0xFF7B5EA7)},
    {'tip': 'A 30-minute daily walk is one of the best health investments.', 'icon': Icons.directions_walk, 'color': Color(0xFF43AA8B)},
    {'tip': 'Eat a rainbow of fruits and vegetables for essential nutrients.', 'icon': Icons.eco, 'color': Color(0xFF4CAF50)},
    {'tip': 'Strength training 2–3x a week boosts metabolism & bone health.', 'icon': Icons.fitness_center, 'color': Colors.orange},
    {'tip': 'Eat mindfully — slow down and listen to your hunger cues.', 'icon': Icons.restaurant, 'color': Color(0xFF56CFE1)},
    {'tip': 'Limit screen time before bed — blue light disrupts melatonin.', 'icon': Icons.phone_android, 'color': Color(0xFFE9C46A)},
    {'tip': 'Deep breathing for 5 minutes reduces stress significantly.', 'icon': Icons.air, 'color': Color(0xFF4ECDC4)},
  ];

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _emoji() {
    final h = DateTime.now().hour;
    if (h < 12) return '☀️';
    if (h < 17) return '🌤️';
    return '🌙';
  }

  @override
  void initState() {
    super.initState();
    _autoScroll();
  }

  @override
  void dispose() {
    _tipsCtrl.dispose();
    super.dispose();
  }

  void _autoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      final next = (_currentTip + 1) % _tips.length;
      _tipsCtrl.animateToPage(next, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      setState(() => _currentTip = next);
      _autoScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeVm = Provider.of<ThemeViewModel>(context);
    final profileVm = Provider.of<ProfileViewModel>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final name = profileVm.name.isEmpty ? 'User' : profileVm.name;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0B101E), const Color(0xFF0D1B2A)]
                : [const Color(0xFFE8F4FD), const Color(0xFFF0FFF4)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(_emoji(), style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Text('${_greeting().tr(context)},', style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey)),
                      ]),
                      const SizedBox(height: 2),
                      Text(name, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Let's keep you healthy today! 💪".tr(context), style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                    ]),
                    GestureDetector(
                      onTap: themeVm.toggleTheme,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: theme.colorScheme.primary.withAlpha(25), shape: BoxShape.circle),
                        child: Icon(themeVm.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                            color: themeVm.isDarkMode ? Colors.amber : Colors.indigo, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('💡 ${'Daily Health Tips'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 96,
                    child: PageView.builder(
                      controller: _tipsCtrl,
                      itemCount: _tips.length,
                      onPageChanged: (i) => setState(() => _currentTip = i),
                      itemBuilder: (_, index) {
                        final t = _tips[index];
                        final c = t['color'] as Color;
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: GlassContainer(
                            padding: const EdgeInsets.all(14),
                            child: Row(children: [
                              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: c.withAlpha(40), shape: BoxShape.circle),
                                  child: Icon(t['icon'] as IconData, color: c, size: 22)),
                              const SizedBox(width: 14),
                              Expanded(child: Text(t['tip'] as String, style: theme.textTheme.bodySmall?.copyWith(height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis)),
                            ]),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_tips.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _currentTip ? 18 : 6, height: 6,
                      decoration: BoxDecoration(
                        color: i == _currentTip ? theme.colorScheme.primary : Colors.grey.withAlpha(80),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    )),
                  ),
                ]),
              ),
            ),

            // Stats header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
                child: Text('📊 ${'Quick Stats'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid.count(
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.5,
                children: const [
                  _StatCard(title: 'Water Goal', value: '2.5 L/day', icon: Icons.water_drop, color: Color(0xFF4CC9F0), badge: 'Hydration'),
                  _StatCard(title: 'Sleep Goal', value: '7–9 hrs', icon: Icons.bedtime, color: Color(0xFF7B5EA7), badge: 'Recovery'),
                  _StatCard(title: 'Calorie Target', value: '2000 kcal', icon: Icons.local_fire_department, color: Colors.orange, badge: 'Daily'),
                  _StatCard(title: 'Activity Goal', value: '5 days/wk', icon: Icons.calendar_today, color: Color(0xFF43AA8B), badge: 'Fitness'),
                ],
              ),
            ),

            // BMI Quick Access
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('🎯 ${'BMI Calculator'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  GlassContainer(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BmiScreen())),
                    padding: const EdgeInsets.all(18),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF7B5EA7), Color(0xFFB57BEE)]),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.monitor_weight_outlined, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Check Your BMI', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Get personalized tips based on your Body Mass Index.', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey), maxLines: 2),
                      ])),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ]),
                  ),
                ]),
              ),
            ),

            // Quote
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
                child: GlassContainer(
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('✨  ', style: TextStyle(fontSize: 18)),
                      Text('Motivation of the Day'.tr(context), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(height: 14),
                    Text('"Take care of your body.\nIt\'s the only place you have to live."',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic, color: const Color(0xFF4ECDC4), height: 1.6)),
                    const SizedBox(height: 8),
                    Text('— Jim Rohn', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value, badge;
  final IconData icon;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.icon, required this.color, required this.badge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassContainer(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withAlpha(35), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 18)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(6)),
              child: Text(badge, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold))),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(title, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11)),
        ]),
      ]),
    );
  }
}
