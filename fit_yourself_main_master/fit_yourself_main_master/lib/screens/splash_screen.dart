import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.card,
              AppColors.accent,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Fit Yourself by Exercise',
                  textStyle: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  speed: const Duration(milliseconds: 80),
                ),
              ],
              isRepeatingAnimation: false,
              totalRepeatCount: 1,
            ),
            const SizedBox(height: 30),
            const Icon(
              Icons.fitness_center,
              size: 60,
              color: AppColors.primary,
            )
                .animate(onPlay: (c) => c.repeat())
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.15, 1.15),
                  duration: 800.ms,
                )
                .then()
                .scale(
                  begin: const Offset(1.15, 1.15),
                  end: const Offset(1.0, 1.0),
                  duration: 800.ms,
                ),
            const SizedBox(height: 24),
            Text(
              'Your 30-Day Transformation Starts Here',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
              ),
            )
                .animate()
                .fadeIn(delay: 1000.ms, duration: 800.ms)
                .slideY(begin: 0.3, end: 0),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                'Loading...',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white38,
                ),
              ).animate(onPlay: (c) => c.repeat()).fadeIn(duration: 600.ms).then().fadeOut(duration: 600.ms),
            ),
          ],
        ),
      ),
    );
  }
}
