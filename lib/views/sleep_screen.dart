import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewmodels/sleep_viewmodel.dart';
import '../models/sleep_model.dart';
import '../theme/glass_widgets.dart';
import '../services/localization_service.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});
  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  static const _indigo = Color(0xFF7B5EA7);

  static const List<Map<String, dynamic>> _importance = [
    {'icon': Icons.psychology, 'title': 'Memory & Learning', 'desc': 'Sleep consolidates memories and helps your brain process new information and skills.', 'color': Color(0xFF7B5EA7)},
    {'icon': Icons.shield, 'title': 'Immune System Boost', 'desc': 'During sleep your body produces cytokines — proteins that fight infection and disease.', 'color': Color(0xFF43AA8B)},
    {'icon': Icons.monitor_weight, 'title': 'Weight Management', 'desc': 'Lack of sleep disrupts hunger hormones (ghrelin & leptin), leading to overeating.', 'color': Color(0xFFFF8C42)},
    {'icon': Icons.sentiment_very_satisfied, 'title': 'Mood & Mental Health', 'desc': 'Poor sleep is strongly linked to depression, anxiety, and irritability.', 'color': Color(0xFFFFBE0B)},
    {'icon': Icons.favorite, 'title': 'Heart Health', 'desc': 'Consistent poor sleep raises blood pressure and increases risk of cardiovascular disease.', 'color': Color(0xFFFF6B6B)},
  ];

  static const List<Map<String, dynamic>> _cycles = [
    {'phase': 'Light Sleep', 'duration': '~30 min', 'desc': 'Stage 1-2: Transition. Heart rate slows, muscles relax. Easy to wake up.', 'color': Color(0xFF4CC9F0)},
    {'phase': 'Deep Sleep', 'duration': '~90 min', 'desc': 'Stage 3: Body repairs tissues, builds bone & muscle. Essential for physical recovery.', 'color': Color(0xFF7B5EA7)},
    {'phase': 'REM Sleep', 'duration': '~90 min', 'desc': 'Rapid Eye Movement: Brain is active, dreams occur. Critical for memory and emotions.', 'color': Color(0xFFFF6B6B)},
  ];

  static const List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  List<double> _getWeeklyData(List<SleepModel> logs) {
    final now = DateTime.now();
    final weekday = now.weekday; // 1=Mon, 7=Sun
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: weekday - 1 - i));
      final dayLogs = logs.where((s) => s.date.day == day.day && s.date.month == day.month && s.date.year == day.year);
      return dayLogs.isEmpty ? 0.0 : dayLogs.map((s) => s.hours).reduce((a, b) => a + b);
    });
  }

  Color _barColor(double hours) {
    if (hours == 0) return Colors.grey.withAlpha(60);
    if (hours < 6) return Colors.red.withAlpha(180);
    if (hours <= 9) return _indigo.withAlpha(200);
    return Colors.blue.withAlpha(180);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SleepViewModel>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: isDark ? [const Color(0xFF0D0018), const Color(0xFF0B101E)] : [const Color(0xFFF5F0FF), const Color(0xFFEDE7F6)],
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<List<SleepModel>>(
            stream: vm.sleepStream,
            builder: (context, snapshot) {
              final logs = snapshot.data ?? [];
              final weekData = _getWeeklyData(logs);

              return CustomScrollView(slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF7B5EA7), Color(0xFF4A0E8F)]), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.bedtime, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Sleep'.tr(context), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        Text('Rest is not laziness — it\'s recovery 🌙', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                      ]),
                    ]),
                  ),
                ),

                // Weekly bar chart
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: GlassContainer(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('📅 ${'This Week\'s Sleep'.tr(context)}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(children: [
                          _Legend(color: _indigo, label: '7–9 hrs (Optimal)'),
                          const SizedBox(width: 14),
                          _Legend(color: Colors.red, label: '<6 hrs (Poor)'),
                        ]),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 180,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 12,
                              barGroups: List.generate(7, (i) => BarChartGroupData(
                                x: i,
                                barRods: [BarChartRodData(
                                  toY: weekData[i],
                                  color: _barColor(weekData[i]),
                                  width: 22,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                )],
                              )),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(
                                show: true,
                                getDrawingHorizontalLine: (v) => FlLine(color: Colors.grey.withAlpha(30), strokeWidth: 1),
                                drawVerticalLine: false,
                                horizontalInterval: 3,
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 28,
                                  getTitlesWidget: (v, _) => Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(_days[v.toInt()], style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                                  ),
                                )),
                                leftTitles: AxisTitles(sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 28,
                                  getTitlesWidget: (v, _) => Text('${v.toInt()}h', style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                                  interval: 3,
                                )),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem('${rod.toY.toStringAsFixed(1)}h', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Recommended line note
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: _indigo.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                          child: Row(children: [
                            Icon(Icons.info_outline, size: 14, color: _indigo),
                            const SizedBox(width: 6),
                            Text('Recommended: 7–9 hours per night', style: TextStyle(fontSize: 11, color: _indigo, fontWeight: FontWeight.w600)),
                          ]),
                        ),
                      ]),
                    ),
                  ),
                ),

                // Why Sleep is Crucial
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
                    child: Text('🌟 ${'Why Sleep is Crucial'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final item = _importance[i];
                      final color = item['color'] as Color;
                      return GlassContainer(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withAlpha(35), shape: BoxShape.circle), child: Icon(item['icon'] as IconData, color: color, size: 20)),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(item['title'] as String, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(item['desc'] as String, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, height: 1.5)),
                          ])),
                        ]),
                      );
                    },
                    childCount: _importance.length,
                  )),
                ),

                // Sleep Cycles
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 14),
                    child: Text('🔄 ${'Sleep Cycle Stages'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  sliver: SliverList(delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final c = _cycles[i];
                      final color = c['color'] as Color;
                      return GlassContainer(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        child: Row(children: [
                          Container(width: 4, height: 60, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(c['phase'] as String, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(8)),
                                  child: Text(c['duration'] as String, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold))),
                            ]),
                            const SizedBox(height: 6),
                            Text(c['desc'] as String, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, height: 1.4)),
                          ])),
                        ]),
                      );
                    },
                    childCount: _cycles.length,
                  )),
                ),

                // Sleep Log
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
                    child: Text('📝 ${'Sleep Log'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ),
                if (logs.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                      child: GlassContainer(
                        child: Column(children: [
                          const Icon(Icons.bedtime, size: 44, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text('No sleep logged yet.', style: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)),
                          Text('Tap + to log your sleep hours.', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                        ]),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                    sliver: SliverList(delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        final s = logs[i];
                        return GlassContainer(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          child: Row(children: [
                            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF7B5EA7), Color(0xFF4A0E8F)]), shape: BoxShape.circle), child: const Icon(Icons.bedtime, color: Colors.white, size: 20)),
                            const SizedBox(width: 14),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('${s.hours} hours slept', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                              Text('Quality: ${'⭐' * s.quality} (${s.quality}/5)', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                            ])),
                            Text('${s.date.day}/${s.date.month}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                          ]),
                        );
                      },
                      childCount: logs.length,
                    )),
                  ),
              ]);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addSleepDialog(context, Provider.of<SleepViewModel>(context, listen: false)),
        backgroundColor: _indigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Log Sleep'.tr(context), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _addSleepDialog(BuildContext context, SleepViewModel vm) {
    final hoursCtrl = TextEditingController();
    int quality = 3;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (ctx, setSt) => AlertDialog(
        title: Text('Log Your Sleep'.tr(context)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: hoursCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Hours Slept', prefixIcon: Icon(Icons.timer))),
          const SizedBox(height: 16),
          Text('Quality: ${'⭐' * quality}', style: const TextStyle(fontWeight: FontWeight.w600)),
          Slider(value: quality.toDouble(), min: 1, max: 5, divisions: 4, activeColor: _indigo,
              onChanged: (v) => setSt(() => quality = v.toInt())),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _indigo, foregroundColor: Colors.white),
            onPressed: () {
              final hrs = double.tryParse(hoursCtrl.text) ?? 0;
              if (hrs > 0) vm.addSleepEntry(SleepModel(id: '', hours: hrs, quality: quality, date: DateTime.now()));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      )),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
    const SizedBox(width: 4),
    Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
  ]);
}
