import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/water_viewmodel.dart';
import '../models/water_model.dart';
import '../theme/glass_widgets.dart';
import '../services/notification_service.dart';
import '../services/localization_service.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});
  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> with SingleTickerProviderStateMixin {
  late AnimationController _waveCtrl;
  late Animation<double> _waveAnim;
  int _goalMl = 2500;

  static const List<Map<String, dynamic>> _benefits = [
    {'icon': Icons.thermostat, 'title': 'Regulates Body Temperature', 'desc': 'Water helps regulate your temperature through sweating and respiration, keeping you cool.', 'color': Color(0xFFFF6B6B)},
    {'icon': Icons.restaurant_menu, 'title': 'Aids Digestion', 'desc': 'Water breaks down food so nutrients can be absorbed. Prevents constipation naturally.', 'color': Color(0xFF43AA8B)},
    {'icon': Icons.cleaning_services, 'title': 'Flushes Out Toxins', 'desc': 'Kidneys use water to filter waste. Adequate hydration prevents kidney stones.', 'color': Color(0xFF4CC9F0)},
    {'icon': Icons.sports_handball, 'title': 'Lubricates Joints', 'desc': 'Cartilage contains about 80% water. Staying hydrated keeps joints flexible and pain-free.', 'color': Color(0xFF7B5EA7)},
    {'icon': Icons.bolt, 'title': 'Boosts Energy & Brain', 'desc': 'Even mild dehydration causes fatigue and brain fog. Water keeps you sharp and alert.', 'color': Color(0xFFE9C46A)},
    {'icon': Icons.face_retouching_natural, 'title': 'Improves Skin Health', 'desc': 'Hydrated skin looks plumper, more radiant, and less prone to wrinkles and breakouts.', 'color': Color(0xFFFF8C42)},
    {'icon': Icons.favorite, 'title': 'Supports Heart Health', 'desc': 'Proper hydration keeps blood viscosity low and helps maintain healthy blood pressure.', 'color': Color(0xFFFF6B6B)},
  ];

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _waveAnim = Tween<double>(begin: -5, end: 5).animate(CurvedAnimation(parent: _waveCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendReminder(BuildContext context) async {
    await NotificationService().showWaterReminderNotification();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('💧 Water reminder sent!'), backgroundColor: Color(0xFF4CC9F0), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<WaterViewModel>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: isDark ? [const Color(0xFF001A2C), const Color(0xFF0B101E)] : [const Color(0xFFE0F7FA), const Color(0xFFF0FBFF)],
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<List<WaterModel>>(
            stream: vm.waterHistoryStream,
            builder: (context, snapshot) {
              final history = snapshot.data ?? [];
              final now = DateTime.now();
              int totalToday = 0;
              for (var w in history) {
                if (w.date.day == now.day && w.date.month == now.month && w.date.year == now.year) totalToday += w.amountMl;
              }
              final progress = (totalToday / _goalMl).clamp(0.0, 1.0);

              return CustomScrollView(slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF4CC9F0), Color(0xFF0077B6)]), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.water_drop, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Hydration'.tr(context), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        Text('Stay hydrated, stay healthy 💧', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                      ]),
                    ]),
                  ),
                ),

                // Water progress gauge
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: GlassContainer(
                      child: Column(children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text("Today's Intake".tr(context), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          TextButton.icon(
                            onPressed: () => _showGoalDialog(context),
                            icon: const Icon(Icons.tune, size: 16),
                            label: Text('Goal: ${_goalMl}ml'),
                            style: TextButton.styleFrom(foregroundColor: const Color(0xFF4CC9F0)),
                          ),
                        ]),
                        const SizedBox(height: 20),
                        // Animated gauge
                        Stack(alignment: Alignment.center, children: [
                          SizedBox(
                            width: 160, height: 160,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 14,
                              backgroundColor: const Color(0xFF4CC9F0).withAlpha(40),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress >= 1.0 ? Colors.green : const Color(0xFF4CC9F0),
                              ),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _waveAnim,
                            builder: (context, child) => Transform.translate(
                              offset: Offset(0, _waveAnim.value),
                              child: Column(mainAxisSize: MainAxisSize.min, children: [
                                Text('💧', style: const TextStyle(fontSize: 28)),
                                Text('${totalToday}ml', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF4CC9F0))),
                                Text('of ${_goalMl}ml', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                              ]),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 16),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress, minHeight: 8,
                            backgroundColor: const Color(0xFF4CC9F0).withAlpha(30),
                            valueColor: AlwaysStoppedAnimation<Color>(progress >= 1.0 ? Colors.green : const Color(0xFF4CC9F0)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          progress >= 1.0 ? '🎉 Daily goal achieved!' : '${(progress * 100).toInt()}% of daily goal',
                          style: TextStyle(fontSize: 13, color: progress >= 1.0 ? Colors.green : Colors.grey, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 20),
                        // Add water buttons
                        Row(children: [
                          Expanded(child: _AddWaterBtn(label: '+150ml', ml: 150, vm: vm)),
                          const SizedBox(width: 8),
                          Expanded(child: _AddWaterBtn(label: '+250ml', ml: 250, vm: vm)),
                          const SizedBox(width: 8),
                          Expanded(child: _AddWaterBtn(label: '+500ml', ml: 500, vm: vm)),
                        ]),
                        const SizedBox(height: 12),
                        // Reminder button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _sendReminder(context),
                            icon: const Icon(Icons.notifications_active_outlined, size: 18),
                            label: const Text('Send Water Reminder'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF4CC9F0),
                              side: const BorderSide(color: Color(0xFF4CC9F0)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),

                // Benefits section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
                    child: Text('🌊 ${'How Water Helps Your Body'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        final b = _benefits[i];
                        final color = b['color'] as Color;
                        return GlassContainer(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: color.withAlpha(35), shape: BoxShape.circle),
                              child: Icon(b['icon'] as IconData, color: color, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(b['title'] as String, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(b['desc'] as String, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, height: 1.5)),
                            ])),
                          ]),
                        );
                      },
                      childCount: _benefits.length,
                    ),
                  ),
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }

  void _showGoalDialog(BuildContext context) {
    final ctrl = TextEditingController(text: _goalMl.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Set Daily Goal'.tr(context)),
        content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Goal (ml)', prefixIcon: Icon(Icons.water_drop))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { setState(() => _goalMl = int.tryParse(ctrl.text) ?? 2500); Navigator.pop(context); },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _AddWaterBtn extends StatelessWidget {
  final String label;
  final int ml;
  final WaterViewModel vm;
  const _AddWaterBtn({required this.label, required this.ml, required this.vm});
  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: () => vm.addWater(ml),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4CC9F0).withAlpha(40),
      foregroundColor: const Color(0xFF4CC9F0),
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
  );
}
