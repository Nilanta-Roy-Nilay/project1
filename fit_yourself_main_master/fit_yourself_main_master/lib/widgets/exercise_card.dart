import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';

class ExerciseCard extends StatelessWidget {
  final String name;
  final String emoji;
  final int? savedDuration;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.name,
    required this.emoji,
    this.savedDuration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDuration = savedDuration != null && savedDuration! > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: hasDuration ? AppColors.success : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasDuration
                          ? 'Duration: ${Helpers.formatDuration(savedDuration!)}'
                          : 'Tap to set duration',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: hasDuration
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
