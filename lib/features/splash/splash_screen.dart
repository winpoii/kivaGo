import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/services/auth_service.dart';
import '../../core/widgets/app_scaffold.dart';
import '../walkthrough/walkthrough_page.dart';
import '../quiz/quiz_intro_page.dart';

/// Splash screen with kivaGo branding
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _authService = AuthService();
  static const String _splashImageUrl =
      'https://plus.unsplash.com/premium_photo-1679830513873-5f9163fcc04a?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=627';

  @override
  void initState() {
    super.initState();

    // Animation setup
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for animation and auth check
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    try {
      final user = _authService.currentUser;

      if (user != null) {
        // User is logged in, check if quiz is completed
        final hasCompletedQuiz = await _authService.hasUserCompletedQuiz();
        if (mounted) {
          if (hasCompletedQuiz) {
            // User has completed quiz, go to main app
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AppScaffold(key: appScaffoldKey)),
            );
          } else {
            // User hasn't completed quiz, go to quiz intro
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const QuizIntroPage()),
            );
          }
        }
      } else {
        // User is not logged in, go to walkthrough
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WalkthroughPage()),
        );
      }
    } catch (e) {
      // On error, go to walkthrough
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WalkthroughPage()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            _splashImageUrl,
            fit: BoxFit.cover,
          ),
          // Gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromRGBO(12, 12, 12, 0.55),
                  Color.fromRGBO(12, 12, 12, 0.2),
                  Color.fromARGB(25, 12, 12, 12),
                ],
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(32, statusBarHeight + 32, 32, 48),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    'kivaGo',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nasıl hissetmek istersin?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.92),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Senin tarzın, senin seyahatin.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.85),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
