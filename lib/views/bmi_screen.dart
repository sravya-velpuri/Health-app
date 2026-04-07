import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/glass_widgets.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});
  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> with SingleTickerProviderStateMixin {
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  double? _bmi;
  String _category = '';
  Color _categoryColor = Colors.green;
  late AnimationController _resultCtrl;
  late Animation<double> _resultAnim;

  List<Map<String, dynamic>> _history = [];

  static const String _historyKey = 'bmi_history';

  static const List<Map<String, dynamic>> _categories = [
    {'range': '< 18.5', 'label': 'Underweight', 'color': Color(0xFF4CC9F0), 'tip': 'Consider increasing calorie intake with nutrient-dense foods. Consult a doctor.'},
    {'range': '18.5 – 24.9', 'label': 'Normal Weight', 'color': Color(0xFF43AA8B), 'tip': 'Great work! Maintain your healthy lifestyle with balanced meals and regular exercise.'},
    {'range': '25 – 29.9', 'label': 'Overweight', 'color': Color(0xFFE9C46A), 'tip': 'Focus on reducing processed foods, increasing activity, and managing portion sizes.'},
    {'range': '≥ 30', 'label': 'Obese', 'color': Color(0xFFFF6B6B), 'tip': 'Speak with a healthcare provider for a personalized plan. Small steps make big changes!'},
  ];

  @override
  void initState() {
    super.initState();
    _resultCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _resultAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _resultCtrl, curve: Curves.elasticOut));
    _loadHistory();
  }

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _resultCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    setState(() {
      _history = raw.map((s) {
        final parts = s.split('|');
        return {'bmi': double.tryParse(parts[0]) ?? 0.0, 'cat': parts.length > 1 ? parts[1] : ''};
      }).toList();
    });
  }

  Future<void> _saveHistory(double bmi, String cat) async {
    final prefs = await SharedPreferences.getInstance();
    final entry = '${bmi.toStringAsFixed(1)}|$cat';
    final existing = prefs.getStringList(_historyKey) ?? [];
    existing.insert(0, entry);
    if (existing.length > 5) existing.removeLast();
    await prefs.setStringList(_historyKey, existing);
    setState(() {
      _history = existing.map((s) {
        final parts = s.split('|');
        return {'bmi': double.tryParse(parts[0]) ?? 0.0, 'cat': parts.length > 1 ? parts[1] : ''};
      }).toList();
    });
  }

  void _calculateBMI() {
    final h = double.tryParse(_heightCtrl.text);
    final w = double.tryParse(_weightCtrl.text);
    if (h != null && w != null && h > 0) {
      final hm = h / 100;
      final bmi = w / (hm * hm);
      String cat;
      Color color;
      if (bmi < 18.5) { cat = 'Underweight'; color = const Color(0xFF4CC9F0); }
      else if (bmi < 25) { cat = 'Normal Weight'; color = const Color(0xFF43AA8B); }
      else if (bmi < 30) { cat = 'Overweight'; color = const Color(0xFFE9C46A); }
      else { cat = 'Obese'; color = const Color(0xFFFF6B6B); }
      setState(() { _bmi = bmi; _category = cat; _categoryColor = color; });
      _resultCtrl.forward(from: 0);
      _saveHistory(bmi, cat);
    }
  }

  String _getTip() {
    for (final c in _categories) {
      if (c['label'] == _category) return c['tip'] as String;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: isDark ? [const Color(0xFF1A0028), const Color(0xFF0B101E)] : [const Color(0xFFF3E5F5), const Color(0xFFEDE7F6)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // What is BMI?
            GlassContainer(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Text('📏', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Text('What is BMI?', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 10),
                Text(
                  'Body Mass Index (BMI) is a measurement of body fat based on height and weight. While not a perfect indicator of health, it provides a useful screening tool for weight categories that may lead to health problems.',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, height: 1.6),
                ),
              ]),
            ),
            const SizedBox(height: 20),

            // BMI Scale
            Text('📊 BMI Categories', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            Row(children: _categories.map((c) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: (c['color'] as Color).withAlpha(40), borderRadius: BorderRadius.circular(10), border: Border.all(color: c['color'] as Color, width: 1.5)),
                  child: Column(children: [
                    Text(c['range'] as String, style: TextStyle(fontSize: 9, color: c['color'] as Color, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(c['label'] as String, style: TextStyle(fontSize: 8, color: c['color'] as Color), textAlign: TextAlign.center),
                  ]),
                ),
              ),
            )).toList()),
            const SizedBox(height: 24),

            // Calculator
            Text('🧮 Calculate Your BMI', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            GlassContainer(
              child: Column(children: [
                TextField(controller: _heightCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Height (cm)', prefixIcon: Icon(Icons.height), hintText: 'e.g. 175')),
                const SizedBox(height: 14),
                TextField(controller: _weightCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Weight (kg)', prefixIcon: Icon(Icons.monitor_weight), hintText: 'e.g. 70')),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B5EA7), foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _calculateBMI,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate BMI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ]),
            ),

            // Result
            if (_bmi != null) ...[
              const SizedBox(height: 24),
              ScaleTransition(
                scale: _resultAnim,
                child: GlassContainer(
                  child: Column(children: [
                    Text('Your Result', style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 10),
                    Text(_bmi!.toStringAsFixed(1), style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: _categoryColor)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(color: _categoryColor.withAlpha(30), borderRadius: BorderRadius.circular(20)),
                      child: Text(_category, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _categoryColor)),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: _categoryColor.withAlpha(15), borderRadius: BorderRadius.circular(12), border: Border.all(color: _categoryColor.withAlpha(60))),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(Icons.lightbulb_outline, size: 18, color: _categoryColor),
                        const SizedBox(width: 10),
                        Expanded(child: Text('💡 ${_getTip()}', style: theme.textTheme.bodySmall?.copyWith(height: 1.5))),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    // Visual scale
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: ((_bmi! - 10) / 30).clamp(0.0, 1.0),
                        minHeight: 12,
                        backgroundColor: Colors.grey.withAlpha(30),
                        valueColor: AlwaysStoppedAnimation<Color>(_categoryColor),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('10', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 10)),
                      Text('Optimal: 18.5–24.9', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 10)),
                      Text('40', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 10)),
                    ]),
                  ]),
                ),
              ),
            ],

            // History
            if (_history.isNotEmpty) ...[
              const SizedBox(height: 28),
              Text('🕐 Recent History', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              ..._history.map((h) {
                final Color hColor;
                final bmiVal = h['bmi'] as double;
                if (bmiVal < 18.5) { hColor = const Color(0xFF4CC9F0); }
                else if (bmiVal < 25) { hColor = const Color(0xFF43AA8B); }
                else if (bmiVal < 30) { hColor = const Color(0xFFE9C46A); }
                else { hColor = const Color(0xFFFF6B6B); }
                return GlassContainer(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: hColor.withAlpha(30), shape: BoxShape.circle),
                        child: Icon(Icons.monitor_weight_outlined, color: hColor, size: 20)),
                    const SizedBox(width: 14),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('BMI: ${bmiVal.toStringAsFixed(1)}', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Text(h['cat'] as String, style: TextStyle(fontSize: 12, color: hColor, fontWeight: FontWeight.w600)),
                    ]),
                  ]),
                );
              }),
            ],
            const SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }
}
