import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';
import '../theme/glass_widgets.dart';
import '../services/localization_service.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  String _gender = 'Male';
  String _goal = 'Stay Healthy';
  String _language = 'English';
  bool _editing = false;

  static const List<String> _genders = ['Male', 'Female', 'Other'];
  static const List<String> _goals = ['Stay Healthy', 'Lose Weight', 'Gain Muscle', 'Improve Endurance', 'Reduce Stress'];
  static const List<String> _languages = ['English', 'Telugu', 'Hindi'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  void _loadProfile() {
    final vm = Provider.of<ProfileViewModel>(context, listen: false);
    _nameCtrl.text = vm.name;
    _ageCtrl.text = vm.age;
    _heightCtrl.text = vm.height;
    _weightCtrl.text = vm.weight;
    setState(() {
      _gender = vm.gender;
      _goal = vm.goal;
      _language = vm.language;
    });
  }

  Future<void> _pickImage(ProfileViewModel vm) async {
    final picker = ImagePicker();
    final ctx = context;
    final result = await showModalBottomSheet<XFile?>(
      context: ctx,
      builder: (sheetCtx) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Camera'),
            onTap: () async {
              final img = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
              if (sheetCtx.mounted) Navigator.pop(sheetCtx, img);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Photo Library'),
            onTap: () async {
              final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
              if (sheetCtx.mounted) Navigator.pop(sheetCtx, img);
            },
          ),
          ListTile(leading: const Icon(Icons.cancel), title: const Text('Cancel'), onTap: () => Navigator.pop(sheetCtx)),
        ]),
      ),
    );
    if (result != null) await vm.updateImagePath(result.path);
  }

  Future<void> _saveProfile(ProfileViewModel vm) async {
    await vm.saveProfile(
      name: _nameCtrl.text.trim(),
      age: _ageCtrl.text.trim(),
      height: _heightCtrl.text.trim(),
      weight: _weightCtrl.text.trim(),
      gender: _gender,
      goal: _goal,
      language: _language,
    );
    if (!mounted) return;
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Profile saved!'), backgroundColor: Color(0xFF2EC4B6), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileVm = Provider.of<ProfileViewModel>(context);
    final authVm = Provider.of<AuthViewModel>(context);
    final themeVm = Provider.of<ThemeViewModel>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const teal = Color(0xFF2EC4B6);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: isDark ? [const Color(0xFF001A18), const Color(0xFF0B101E)] : [const Color(0xFFE0F5F5), const Color(0xFFF0FFFE)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(slivers: [
            // Header with avatar
            SliverToBoxAdapter(
              child: Stack(children: [
                Container(height: 160,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF2EC4B6), Color(0xFF0077B6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('My Profile'.tr(context), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('Manage your health info'.tr(context), style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
                    ]),
                    Row(children: [
                      IconButton(
                        onPressed: () {
                          if (_editing) {
                            _saveProfile(profileVm);
                          } else {
                            setState(() => _editing = true);
                          }
                        },
                        icon: Icon(_editing ? Icons.check_circle : Icons.edit, color: Colors.white, size: 28),
                        tooltip: _editing ? 'Save' : 'Edit Profile',
                      ),
                    ]),
                  ]),
                ),
                Positioned(bottom: 0, left: 0, right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => _pickImage(profileVm),
                      child: Stack(children: [
                        Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 10)],
                          ),
                          child: ClipOval(
                            child: profileVm.imagePath != null
                                ? Image.file(File(profileVm.imagePath!), fit: BoxFit.cover)
                                : Container(
                                    color: teal.withAlpha(60),
                                    child: Icon(Icons.person, size: 50, color: teal),
                                  ),
                          ),
                        ),
                        Positioned(bottom: 0, right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: teal, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ]),
            ),

            // Name display
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Center(child: Column(children: [
                  Text(profileVm.name.isEmpty ? 'Your Name' : profileVm.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  if (profileVm.goal.isNotEmpty) Text('🎯 ${profileVm.goal}', style: theme.textTheme.bodySmall?.copyWith(color: teal, fontWeight: FontWeight.w600)),
                ])),
              ),
            ),

            // Profile Details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('👤 ${'Personal Details'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  GlassContainer(
                    child: Column(children: [
                      _editing
                          ? TextField(controller: _nameCtrl, decoration: InputDecoration(labelText: 'Name'.tr(context), prefixIcon: const Icon(Icons.person)))
                          : _InfoRow(Icons.person, 'Name'.tr(context), profileVm.name.isEmpty ? 'Not set' : profileVm.name),
                      const Divider(height: 20),
                      _editing
                          ? TextField(controller: _ageCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Age'.tr(context), prefixIcon: const Icon(Icons.cake)))
                          : _InfoRow(Icons.cake, 'Age'.tr(context), profileVm.age.isEmpty ? 'Not set' : '${profileVm.age} years'),
                      const Divider(height: 20),
                      _editing
                          ? TextField(controller: _heightCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Height'.tr(context), prefixIcon: const Icon(Icons.height)))
                          : _InfoRow(Icons.height, 'Height'.tr(context), profileVm.height.isEmpty ? 'Not set' : '${profileVm.height} cm'),
                      const Divider(height: 20),
                      _editing
                          ? TextField(controller: _weightCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Weight'.tr(context), prefixIcon: const Icon(Icons.monitor_weight)))
                          : _InfoRow(Icons.monitor_weight_outlined, 'Weight'.tr(context), profileVm.weight.isEmpty ? 'Not set' : '${profileVm.weight} kg'),
                      const Divider(height: 20),
                      _editing
                          ? DropdownButtonFormField<String>(
                              initialValue: _gender, decoration: InputDecoration(labelText: 'Gender'.tr(context), prefixIcon: const Icon(Icons.wc)),
                              items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                              onChanged: (v) => setState(() => _gender = v!),
                            )
                          : _InfoRow(Icons.wc, 'Gender'.tr(context), profileVm.gender),
                      const Divider(height: 20),
                      _editing
                          ? DropdownButtonFormField<String>(
                              initialValue: _language, decoration: InputDecoration(labelText: 'Language Preference'.tr(context), prefixIcon: const Icon(Icons.language)),
                              items: _languages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                              onChanged: (v) => setState(() => _language = v!),
                            )
                          : _InfoRow(Icons.language, 'Language Preference'.tr(context), profileVm.language),
                    ]),
                  ),
                ]),
              ),
            ),

            // Fitness Goal
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('🎯 ${'Fitness Goal'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  _editing
                      ? GlassContainer(child: DropdownButtonFormField<String>(
                          initialValue: _goal, decoration: const InputDecoration(labelText: 'My Goal', prefixIcon: Icon(Icons.flag)),
                          items: _goals.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                          onChanged: (v) => setState(() => _goal = v!),
                        ))
                      : Wrap(spacing: 8, runSpacing: 8, children: _goals.map((g) {
                          final selected = g == profileVm.goal;
                          return GestureDetector(
                            onTap: _editing ? () => setState(() => _goal = g) : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected ? teal.withAlpha(40) : Colors.grey.withAlpha(20),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: selected ? teal : Colors.grey.withAlpha(60), width: selected ? 2 : 1),
                              ),
                              child: Text(g, style: TextStyle(fontSize: 12, color: selected ? teal : Colors.grey, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
                            ),
                          );
                        }).toList()),
                ]),
              ),
            ),

            // Preferences
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('⚙️ ${'Preferences'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Column(children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Dark Mode'.tr(context), style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(themeVm.isDarkMode ? 'Enabled' : 'Disabled', style: const TextStyle(fontSize: 12)),
                        secondary: Icon(themeVm.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny_rounded, color: themeVm.isDarkMode ? Colors.amber : Colors.orange),
                        value: themeVm.isDarkMode,
                        activeTrackColor: teal,
                        onChanged: (_) => themeVm.toggleTheme(),
                      ),
                    ]),
                  ),
                ]),
              ),
            ),

            // Logout
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 60),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('🔒 ${'Account'.tr(context)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  if (authVm.currentUser != null)
                    GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Row(children: [
                        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blueGrey.withAlpha(30), shape: BoxShape.circle), child: const Icon(Icons.email_outlined, color: Colors.blueGrey, size: 20)),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Logged in as', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          Text(authVm.currentUser!.email ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ])),
                      ]),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      icon: const Icon(Icons.logout),
                      label: Text('Logout'.tr(context), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      onPressed: () async {
                        await authVm.logout();
                        if (!mounted) return;
                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AuthScreen()), (r) => false);
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(children: [
      Icon(icon, size: 20, color: Colors.grey),
      const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11)),
        Text(value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      ]),
    ]);
  }
}
