import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'auth_screen.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.0, 0.6)),
    );
    _animController.forward();
    _checkAuth();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _checkAuth() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (authViewModel.currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B101E),
              Color(0xFF1A1F35),
              Color(0xFF0D2137),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4ECDC4), Color(0xFF00FF87)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4ECDC4).withAlpha(80),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      size: 72,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Health & Wellness',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Text(
                    'Pro',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4ECDC4),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your journey to a healthier life',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white54,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 60),
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Color(0xFF4ECDC4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
