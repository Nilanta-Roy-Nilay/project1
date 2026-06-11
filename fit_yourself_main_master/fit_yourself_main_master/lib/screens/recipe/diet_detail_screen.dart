import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../data/diet_data.dart';
import '../../data/storage_service.dart';
import '../../widgets/diet_meal_card.dart';

class DietDetailScreen extends StatefulWidget {
  final int dayNumber;

  const DietDetailScreen({super.key, required this.dayNumber});

  @override
  State<DietDetailScreen> createState() => _DietDetailScreenState();
}

class _DietDetailScreenState extends State<DietDetailScreen> {
  final _storage = StorageService();
  bool _isVegetarian = false;

  @override
  void initState() {
    super.initState();
    final savedType = _storage.getDietType(widget.dayNumber);
    if (savedType != null) {
      _isVegetarian = savedType == 'Vegetarian';
    }
  }

  @override
  Widget build(BuildContext context) {
    final allDays = DietData.getAllDays();
    final day = allDays.firstWhere((d) => d.dayNumber == widget.dayNumber);
    final meals = _isVegetarian ? day.vegetarianMeals : day.standardMeals;
    final totalCalories = day.totalCalories(_isVegetarian);
    final isCompleted = _storage.isDietDayComplete(widget.dayNumber);

    const mealEmojis = ['🌅', '🍎', '☀️', '🌙'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Day ${widget.dayNumber} - Diet Plan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Diet Type Selector
          Text(
            'Choose Your Diet Plan',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isVegetarian = false),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: !_isVegetarian
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: !_isVegetarian
                            ? AppColors.primary
                            : AppColors.surface,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text('🍗', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 6),
                        Text(
                          'Standard',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Includes meat, fish, eggs',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isVegetarian = true),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isVegetarian
                          ? AppColors.accent.withValues(alpha: 0.15)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            _isVegetarian ? AppColors.accent : AppColors.surface,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text('🥗', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 6),
                        Text(
                          'Vegetarian',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Plant-based meals',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Meal Cards
          ...meals.asMap().entries.map((entry) {
            final idx = entry.key;
            final meal = entry.value;
            return DietMealCard(
              meal: meal,
              emoji: idx < mealEmojis.length ? mealEmojis[idx] : '🍽️',
            );
          }),

          // Total Calories
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.accent.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Total: $totalCalories calories',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Finish Button
          if (!isCompleted)
            ElevatedButton(
              onPressed: () async {
                final dietType = _isVegetarian ? 'Vegetarian' : 'Standard';
                await _storage.markDietDayComplete(
                    widget.dayNumber, dietType);
                if (mounted) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: AppColors.card,
                      title: Text(
                        'Day ${widget.dayNumber} Diet Complete!',
                        style: GoogleFonts.poppins(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        'Great job following your $dietType diet plan today!',
                        style:
                            GoogleFonts.poppins(color: AppColors.textSecondary),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('Done',
                              style: GoogleFonts.poppins(
                                  color: AppColors.primary)),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
              ),
              child: Text(
                'Finish Day ${widget.dayNumber}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text(
                    'Day ${widget.dayNumber} Diet Completed!',
                    style: GoogleFonts.poppins(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
