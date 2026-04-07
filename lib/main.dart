import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'services/notification_service.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/dashboard_viewmodel.dart';
import 'viewmodels/workout_viewmodel.dart';
import 'viewmodels/meal_viewmodel.dart';
import 'viewmodels/water_viewmodel.dart';
import 'viewmodels/sleep_viewmodel.dart';
import 'viewmodels/theme_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';

import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => WorkoutViewModel()),
        ChangeNotifierProvider(create: (_) => MealViewModel()),
        ChangeNotifierProvider(create: (_) => WaterViewModel()),
        ChangeNotifierProvider(create: (_) => SleepViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: const HealthWellnessProApp(),
    ),
  );
}

class HealthWellnessProApp extends StatelessWidget {
  const HealthWellnessProApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVm = Provider.of<ThemeViewModel>(context);

    return MaterialApp(
      title: 'Health & Wellness Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeVm.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
