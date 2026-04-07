import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/workout_viewmodel.dart';
import '../models/workout_model.dart';
import '../theme/glass_widgets.dart';
import '../services/localization_service.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});
  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static final List<Map<String, dynamic>> _exercises = [
    {
      'name': 'Push-Ups', 'muscles': 'Chest · Shoulders · Triceps',
      'duration': '3 × 15 reps', 'calories': '~8 cal/min',
      'icon': Icons.fitness_center, 'color': Colors.orange,
      'description': 'A fundamental upper-body exercise. Start in a plank, lower your chest to the floor and push back up with control.',
      'benefits': ['Builds chest strength', 'Tones arms & shoulders', 'Improves core stability', 'No equipment needed'],
      'steps': ['Start in plank position', 'Lower body toward floor', 'Push back up explosively', 'Keep core tight throughout'],
    },
    {
      'name': 'Squats', 'muscles': 'Quads · Glutes · Hamstrings',
      'duration': '3 × 20 reps', 'calories': '~6 cal/min',
      'icon': Icons.accessibility_new, 'color': Color(0xFF4CC9F0),
      'description': 'Stand feet shoulder-width apart. Lower hips until thighs are parallel to floor, then drive back up.',
      'benefits': ['Strengthens legs', 'Builds glutes', 'Improves balance', 'Fat burning powerhouse'],
      'steps': ['Stand feet shoulder-width', 'Push hips back & down', 'Lower until parallel', 'Drive through heels up'],
    },
    {
      'name': 'Plank', 'muscles': 'Core · Abs · Shoulders',
      'duration': '3 × 60 seconds', 'calories': '~5 cal/min',
      'icon': Icons.straighten, 'color': Color(0xFF43AA8B),
      'description': 'Hold a push-up position with forearms on floor. Keep a straight line from head to heels with core braced.',
      'benefits': ['Strengthens core', 'Improves posture', 'Reduces back pain', 'Burns calories at rest'],
      'steps': ['Place forearms on floor', 'Extend legs straight back', 'Align head to heels', 'Hold steady and breathe'],
    },
    {
      'name': 'Jumping Jacks', 'muscles': 'Full Body · Cardio',
      'duration': '3 × 45 seconds', 'calories': '~10 cal/min',
      'icon': Icons.directions_run, 'color': Colors.amber,
      'description': 'Jump feet out wide while raising arms overhead, then return to start. Keep a steady, controlled rhythm.',
      'benefits': ['Boosts heart rate', 'Burns calories fast', 'Improves coordination', 'Great warm-up exercise'],
      'steps': ['Stand with feet together', 'Jump feet out wide', 'Raise arms overhead', 'Return to start position'],
    },
    {
      'name': 'Lunges', 'muscles': 'Quads · Glutes · Calves',
      'duration': '3 × 12 per leg', 'calories': '~7 cal/min',
      'icon': Icons.transfer_within_a_station, 'color': Color(0xFF7B5EA7),
      'description': 'Step forward, lower your back knee toward the floor until front thigh is parallel, then return.',
      'benefits': ['Builds leg strength', 'Improves balance', 'Activates glutes', 'Corrects muscle imbalances'],
      'steps': ['Stand tall, feet together', 'Step forward one leg', 'Lower back knee down', 'Push back to start position'],
    },
    {
      'name': 'Burpees', 'muscles': 'Full Body · Cardio',
      'duration': '3 × 10 reps', 'calories': '~12 cal/min',
      'icon': Icons.flash_on, 'color': Colors.red,
      'description': 'Squat down, kick feet back to plank, do a push-up, jump feet in, then explode upward with arms overhead.',
      'benefits': ['Maximum calorie burn', 'Full body strength', 'Builds explosive power', 'Cardio & strength combined'],
      'steps': ['Stand, drop to squat', 'Kick feet to plank', 'Do a push-up', 'Jump feet in, leap up'],
    },
    {
      'name': 'Mountain Climbers', 'muscles': 'Core · Shoulders · Cardio',
      'duration': '3 × 30 seconds', 'calories': '~11 cal/min',
      'icon': Icons.terrain, 'color': Color(0xFF56CFE1),
      'description': 'In a plank, rapidly alternate driving your knees toward your chest as if climbing a mountain.',
      'benefits': ['Burns belly fat', 'Builds core endurance', 'Improves agility', 'Full body activation'],
      'steps': ['Start in plank position', 'Drive right knee to chest', 'Quickly switch to left leg', 'Maintain flat back throughout'],
    },
    {
      'name': 'High Knees', 'muscles': 'Hips · Core · Cardio',
      'duration': '3 × 40 seconds', 'calories': '~9 cal/min',
      'icon': Icons.directions_walk, 'color': Color(0xFF4ECDC4),
      'description': 'Running in place while driving your knees up to hip height alternately as fast as possible.',
      'benefits': ['Elevates heart rate', 'Strengthens hip flexors', 'Improves running form', 'Burns calories quickly'],
      'steps': ['Stand tall with bent arms', 'Drive right knee up high', 'Quickly switch to left', 'Pump arms in rhythm'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<WorkoutViewModel>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: isDark ? [const Color(0xFF1A0A00), const Color(0xFF0B101E)] : [Colors.orange.withAlpha(20), const Color(0xFFFFFFF0)],
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.orange, Color(0xFFFF6B35)]), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.fitness_center, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Workouts'.tr(context), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Train smart, live strong 💪', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ]),
                ]),
                const SizedBox(height: 16),
                GlassContainer(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    const Text('🏠', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Home Workouts Work!'.tr(context), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text('No gym needed. Build strength, burn calories & boost your mood from home.', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, height: 1.4)),
                    ])),
                  ]),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(color: theme.colorScheme.surface.withAlpha(80), borderRadius: BorderRadius.circular(12)),
                  child: TabBar(
                    controller: _tabController,
                    tabs: [Tab(text: '🏋️  ${'Exercise Library'.tr(context)}'), Tab(text: '📋  ${'My Logs'.tr(context)}')],
                    indicator: BoxDecoration(gradient: const LinearGradient(colors: [Colors.orange, Color(0xFFFF6B35)]), borderRadius: BorderRadius.circular(10)),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    dividerColor: Colors.transparent,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    itemCount: _exercises.length,
                    itemBuilder: (_, i) => _ExerciseCard(exercise: _exercises[i]),
                  ),
                  _MyLogsTab(vm: vm, onAdd: () => _addWorkoutDialog(context, vm)),
                ],
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addWorkoutDialog(context, vm),
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Log Workout'.tr(context), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _addWorkoutDialog(BuildContext context, WorkoutViewModel vm) {
    final titleCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    final caloriesCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Your Workout'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Workout Name', prefixIcon: Icon(Icons.fitness_center))),
          const SizedBox(height: 12),
          TextField(controller: durationCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Duration (mins)', prefixIcon: Icon(Icons.timer))),
          const SizedBox(height: 12),
          TextField(controller: caloriesCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Calories Burned', prefixIcon: Icon(Icons.local_fire_department))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                vm.addWorkout(WorkoutModel(id: '', title: titleCtrl.text, category: 'General',
                    durationMinutes: int.tryParse(durationCtrl.text) ?? 0,
                    caloriesBurned: int.tryParse(caloriesCtrl.text) ?? 0, date: DateTime.now()));
              }
              Navigator.pop(context);
            },
            child: const Text('Log'),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatefulWidget {
  final Map<String, dynamic> exercise;
  const _ExerciseCard({required this.exercise});
  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _pulse;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.88, end: 1.08).animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final e = widget.exercise;
    final color = e['color'] as Color;
    final benefits = e['benefits'] as List<String>;
    final steps = e['steps'] as List<String>;

    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Row(children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) => Transform.scale(
              scale: _expanded ? 1.0 : _pulse.value,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color.withAlpha(180), color], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: color.withAlpha(80), blurRadius: 12, spreadRadius: 2)],
                ),
                child: Icon(e['icon'] as IconData, color: Colors.white, size: 26),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e['name'] as String, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(e['muscles'] as String, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
            const SizedBox(height: 6),
            Row(children: [
              _Chip(label: e['duration'] as String, icon: Icons.repeat, color: color),
              const SizedBox(width: 6),
              _Chip(label: e['calories'] as String, icon: Icons.local_fire_department, color: Colors.redAccent),
            ]),
          ])),
          IconButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            icon: AnimatedRotation(turns: _expanded ? 0.5 : 0, duration: const Duration(milliseconds: 250), child: Icon(Icons.expand_more, color: color)),
          ),
        ]),
        if (_expanded) ...[
          const Divider(height: 20),
          Text(e['description'] as String, style: theme.textTheme.bodySmall?.copyWith(height: 1.5, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerLeft, child: Text('How to do it:', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold))),
          const SizedBox(height: 6),
          ...List.generate(steps.length, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 20, height: 20, alignment: Alignment.center, decoration: BoxDecoration(color: color.withAlpha(40), shape: BoxShape.circle),
                  child: Text('${i + 1}', style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold))),
              const SizedBox(width: 8),
              Expanded(child: Text(steps[i], style: theme.textTheme.bodySmall?.copyWith(height: 1.4))),
            ]),
          )),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerLeft, child: Text('Benefits:', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold))),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: benefits.map((b) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withAlpha(60))),
            child: Text('✓ $b', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
          )).toList()),
        ],
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _Chip({required this.label, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(8)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 11, color: color), const SizedBox(width: 3),
      Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _MyLogsTab extends StatelessWidget {
  final WorkoutViewModel vm;
  final VoidCallback onAdd;
  const _MyLogsTab({required this.vm, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<List<WorkoutModel>>(
      stream: vm.workoutStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        final workouts = snapshot.data ?? [];
        if (workouts.isEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.fitness_center, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No workouts logged yet.', style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey)),
            const SizedBox(height: 8),
            Text('Tap the + button to log your first workout!', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
          ]));
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
          itemCount: workouts.length,
          itemBuilder: (_, i) {
            final w = workouts[i];
            return GlassContainer(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.orange.withAlpha(40), shape: BoxShape.circle), child: const Icon(Icons.fitness_center, color: Colors.orange)),
                title: Text(w.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${w.durationMinutes} mins · ${w.caloriesBurned} kcal burned'),
                trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => vm.deleteWorkout(w.id)),
              ),
            );
          },
        );
      },
    );
  }
}
