import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class BMIGauge extends StatelessWidget {
  final double bmi;

  const BMIGauge({super.key, required this.bmi});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final position = _getPosition(bmi, width);

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 185,
                            child: Container(
                              height: 14,
                              color: Colors.blue.shade400,
                            ),
                          ),
                          Expanded(
                            flex: 65,
                            child: Container(
                              height: 14,
                              color: AppColors.success,
                            ),
                          ),
                          Expanded(
                            flex: 50,
                            child: Container(
                              height: 14,
                              color: Colors.orange,
                            ),
                          ),
                          Expanded(
                            flex: 200,
                            child: Container(
                              height: 14,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: position - 10,
                    child: Column(
                      children: [
                        Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.textPrimary,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('< 18.5', style: GoogleFonts.poppins(fontSize: 10, color: Colors.blue.shade400)),
            Text('18.5–24.9', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.success)),
            Text('25–29.9', style: GoogleFonts.poppins(fontSize: 10, color: Colors.orange)),
            Text('≥ 30', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Underweight', style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textSecondary)),
            Text('Normal', style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textSecondary)),
            Text('Overweight', style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textSecondary)),
            Text('Obese', style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }

  double _getPosition(double bmi, double totalWidth) {
    double clampedBmi = bmi.clamp(10, 50);
    double ratio = (clampedBmi - 10) / 40;
    return ratio * totalWidth;
  }
}
