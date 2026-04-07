import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/meal_viewmodel.dart';
import '../models/meal_model.dart';
import '../theme/glass_widgets.dart';
import '../services/localization_service.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({super.key});

  static const List<Map<String, dynamic>> _foods = [
    {'name': 'Salmon', 'emoji': '🐟', 'benefits': 'Rich in omega-3 fatty acids that reduce inflammation and support heart health.', 'color': Color(0xFFFF6B6B), 'nutrients': 'Protein · Omega-3 · Vit D'},
    {'name': 'Spinach', 'emoji': '🥬', 'benefits': 'Packed with iron, magnesium, and vitamins K & A. Boosts energy and bone health.', 'color': Color(0xFF43AA8B), 'nutrients': 'Iron · Vit K · Folate'},
    {'name': 'Avocado', 'emoji': '🥑', 'benefits': 'Heart-healthy monounsaturated fats that lower bad cholesterol and keep you full.', 'color': Color(0xFF4CAF50), 'nutrients': 'Healthy Fats · Potassium · Fiber'},
    {'name': 'Blueberries', 'emoji': '🫐', 'benefits': 'Highest antioxidant content of all common fruits. Protect against aging and cancer.', 'color': Color(0xFF7B5EA7), 'nutrients': 'Antioxidants · Vit C · Fiber'},
    {'name': 'Oats', 'emoji': '🌾', 'benefits': 'Beta-glucan fiber lowers cholesterol and provides sustained energy throughout the day.', 'color': Color(0xFFE9C46A), 'nutrients': 'Fiber · Magnesium · B Vitamins'},
    {'name': 'Almonds', 'emoji': '🫘', 'benefits': 'A handful a day reduces heart disease risk. Great source of vitamin E and healthy fats.', 'color': Color(0xFFD4A574), 'nutrients': 'Vit E · Healthy Fats · Protein'},
    {'name': 'Greek Yogurt', 'emoji': '🥛', 'benefits': 'Probiotic powerhouse that supports gut health, immunity, and muscle recovery.', 'color': Color(0xFF4CC9F0), 'nutrients': 'Probiotics · Calcium · Protein'},
    {'name': 'Eggs', 'emoji': '🥚', 'benefits': 'Complete protein with all essential amino acids. Contain choline for brain health.', 'color': Color(0xFFFFBE0B), 'nutrients': 'Complete Protein · Choline · B12'},
    {'name': 'Sweet Potato', 'emoji': '🍠', 'benefits': 'Rich in beta-carotene (vitamin A), fiber, and antioxidants. Manages blood sugar.', 'color': Color(0xFFFF8C42), 'nutrients': 'Vit A · Fiber · Potassium'},
    {'name': 'Green Tea', 'emoji': '🍵', 'benefits': 'EGCG antioxidants boost brain function, fat burning, and lower risk of chronic diseases.', 'color': Color(0xFF56CFE1), 'nutrients': 'EGCG · L-Theanine · Antioxidants'},
  ];

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MealViewModel>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: isDark ? [const Color(0xFF001A0D), const Color(0xFF0B101E)] : [const Color(0xFFE8FDF0), const Color(0xFFF0FFF8)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF43AA8B), Color(0xFF00B09B)]), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.restaurant, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Nutrition'.tr(context), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Eat well, live better 🥗', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ]),
                ]),
              ),
            ),

            // What is a healthy diet?
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: GlassContainer(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Text('🌿', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Text('What is a Healthy Diet?'.tr(context), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(height: 12),
                    Text(
                      'A healthy diet provides your body with essential nutrients: macronutrients (proteins, fats, carbohydrates) and micronutrients (vitamins, minerals). The goal is balance — not restriction.',
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.6, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 14),
                    ...[
                      ('🌾', 'Complex Carbs', 'Whole grains, legumes, vegetables — fuel for your brain and muscles.'),
                      ('🥩', 'Lean Protein', 'Fish, chicken, eggs, legumes — builds and repairs your body.'),
                      ('🥑', 'Healthy Fats', 'Avocado, nuts, olive oil — vital for hormones and cell function.'),
                      ('🥦', 'Fiber & Micro-nutrients', 'Fruits & veggies — vitamins, minerals, antioxidants, gut health.'),
                    ].map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item.$1, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item.$2, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                          Text(item.$3, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, height: 1.3)),
                        ])),
                      ]),
                    )),
                  ]),
                ),
              ),
            ),

            // Macro guide
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('⚡ ${'Daily Macro Guide'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  Row(children: [
                    _MacroCard(label: 'Protein', pct: '25%', color: const Color(0xFFFF6B6B), icon: Icons.egg_alt),
                    const SizedBox(width: 10),
                    _MacroCard(label: 'Carbs', pct: '50%', color: const Color(0xFFE9C46A), icon: Icons.grain),
                    const SizedBox(width: 10),
                    _MacroCard(label: 'Fats', pct: '25%', color: const Color(0xFF4CC9F0), icon: Icons.water_drop),
                  ]),
                ]),
              ),
            ),

            // Superfoods section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 14),
                child: Text('🦸 ${'Top 10 Superfoods'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _FoodCard(food: _foods[i]),
                  childCount: _foods.length,
                ),
              ),
            ),

            // My Meal Logs
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 14),
                child: Text('📋 ${'My Meal Logs'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder<List<MealModel>>(
                stream: vm.mealStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                  final meals = snapshot.data ?? [];
                  if (meals.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                      child: GlassContainer(
                        child: Column(children: [
                          const Icon(Icons.restaurant, size: 44, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text('No meals logged yet.', style: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text('Tap the + button to log what you\'ve eaten.', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                        ]),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                    itemCount: meals.length,
                    itemBuilder: (_, i) {
                      final m = meals[i];
                      return GlassContainer(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF43AA8B).withAlpha(40), shape: BoxShape.circle), child: const Icon(Icons.restaurant, color: Color(0xFF43AA8B))),
                          title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${m.calories} kcal · P:${m.protein}g C:${m.carbs}g F:${m.fat}g'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addMealDialog(context, Provider.of<MealViewModel>(context, listen: false)),
        backgroundColor: const Color(0xFF43AA8B),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Log Meal'.tr(context), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _addMealDialog(BuildContext context, MealViewModel vm) {
    final nameCtrl = TextEditingController();
    final calCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log a Meal'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Meal Name', prefixIcon: Icon(Icons.restaurant))),
          const SizedBox(height: 12),
          TextField(controller: calCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Calories', prefixIcon: Icon(Icons.local_fire_department))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF43AA8B), foregroundColor: Colors.white),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                vm.addMeal(MealModel(id: '', name: nameCtrl.text, calories: int.tryParse(calCtrl.text) ?? 0, protein: 0, carbs: 0, fat: 0, date: DateTime.now()));
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

class _MacroCard extends StatelessWidget {
  final String label, pct;
  final Color color;
  final IconData icon;
  const _MacroCard({required this.label, required this.pct, required this.color, required this.icon});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: GlassContainer(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(pct, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11)),
        ]),
      ),
    );
  }
}

class _FoodCard extends StatefulWidget {
  final Map<String, dynamic> food;
  const _FoodCard({required this.food});
  @override
  State<_FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<_FoodCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final f = widget.food;
    final color = f['color'] as Color;
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(f['emoji'] as String, style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(f['name'] as String, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(f['nutrients'] as String, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
            ])),
            AnimatedRotation(turns: _expanded ? 0.5 : 0, duration: const Duration(milliseconds: 250), child: Icon(Icons.expand_more, color: color)),
          ]),
        ),
        if (_expanded) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withAlpha(15), borderRadius: BorderRadius.circular(10)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.check_circle, size: 16, color: color),
              const SizedBox(width: 8),
              Expanded(child: Text(f['benefits'] as String, style: theme.textTheme.bodySmall?.copyWith(height: 1.5, color: Colors.grey.shade600))),
            ]),
          ),
        ],
      ]),
    );
  }
}
