import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../theme/app_theme.dart';
import '../../data/storage_service.dart';
import '../../utils/constants.dart';
import 'diet_detail_screen.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final _storage = StorageService();

  @override
  Widget build(BuildContext context) {
    final completedDays = _storage.getCompletedDietDays();
    final completedCount = completedDays.length;
    final percent = completedCount / AppConstants.totalDays;

    String motivationText;
    if (percent < 0.25) {
      motivationText = 'Great start! Keep building healthy habits.';
    } else if (percent < 0.5) {
      motivationText = 'You\'re making progress! Stay consistent.';
    } else if (percent < 0.75) {
      motivationText = 'Over halfway there! You\'re doing amazing.';
    } else {
      motivationText = 'Almost done! You\'re a nutrition champion!';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '30-Day Diet Planner',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.restaurant, color: AppColors.accent),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  LinearPercentIndicator(
                    lineHeight: 12,
                    percent: percent.clamp(0.0, 1.0),
                    backgroundColor: AppColors.surface,
                    progressColor: AppColors.accent,
                    barRadius: const Radius.circular(6),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$completedCount / ${AppConstants.totalDays} Days Completed',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    motivationText,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Select a Day',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            // Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: AppConstants.totalDays,
              itemBuilder: (context, index) {
                final day = index + 1;
                final isCompleted = completedDays.contains(day);

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DietDetailScreen(dayNumber: day),
                      ),
                    );
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.success : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: isCompleted
                          ? null
                          : Border.all(
                              color: AppColors.primary.withValues(alpha: 0.4)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '$day',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color:
                                isCompleted ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        if (isCompleted)
                          const Positioned(
                            top: 4,
                            right: 4,
                            child: Icon(Icons.check, color: Colors.white, size: 14),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
