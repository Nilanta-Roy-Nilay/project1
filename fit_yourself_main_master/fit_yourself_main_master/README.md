# Fit Yourself by Exercise

A comprehensive 30-Day Fitness & Diet Tracker built with Flutter. This mobile application provides a complete workout program with 210 exercises, 240 meal plans, progress tracking, BMI/BMR calculators, and weight monitoring — all stored locally on the device with zero internet requirement.

## Features

### Workout Program (30 Days)
- **210 unique exercises** across 30 structured workout days
- 7 exercises per day with varied difficulty (Beginner to Advanced)
- Each exercise includes detailed instructions and an animated countdown timer
- Duration selection (preset or custom) per exercise
- Day completion tracking with visual progress indicators
- Rest & mobility days (Day 14, Day 21)
- Special challenge days: HIIT (Day 28), Endurance (Day 29), Final Test (Day 30)

### Diet Planner (30 Days)
- **240 unique meals** — 30 days x 2 diet types x 4 meals/day
- **Standard** and **Vegetarian** meal plans for every day
- 4 meals per day: Breakfast, Snack, Lunch, Dinner
- Each meal includes calories, description, and ingredient list
- Daily calorie totals (1400-1600 cal range)
- International cuisine variety (American, Indian, Thai, Mediterranean, etc.)

### Reports & Analytics
- **Calendar View**: Visual overview of completed workout and diet days
- **Weight Tracker**: Chart-based weight history with add/delete entries
- **BMI Calculator**: Interactive calculator with visual gauge and category display
- **BMR Calculator**: Mifflin-St Jeor formula with activity level TDEE and macro split
- **Share Progress**: Copy progress summary to clipboard

### Additional Features
- Dark theme with consistent color palette
- Animated splash screen with typewriter effect
- 50+ motivational quotes
- Streak counter for consecutive workout days
- Hive local storage (no internet required)
- Google Fonts (Poppins) throughout

## Tech Stack

- **Framework**: Flutter 3.41.2 (Dart 3.11.0)
- **Local Storage**: Hive (fast, lightweight NoSQL database)
- **Charts**: fl_chart
- **Animations**: flutter_animate, animated_text_kit
- **UI**: google_fonts, percent_indicator, table_calendar

## Project Structure

```
lib/
├── main.dart                          # App entry point, Hive initialization
├── app.dart                           # MaterialApp configuration
├── theme/
│   └── app_theme.dart                 # Colors, dark theme, text styles
├── models/
│   ├── exercise.dart                  # Exercise data model
│   ├── workout_day.dart               # WorkoutDay data model
│   └── diet_day.dart                  # Meal and DietDay data models
├── data/
│   ├── exercise_data.dart             # 210 exercises across 30 days
│   ├── diet_data.dart                 # 240 meals across 30 days
│   └── storage_service.dart           # Hive CRUD operations singleton
├── screens/
│   ├── splash_screen.dart             # Animated splash screen
│   ├── main_navigation.dart           # Bottom nav with 3 tabs
│   ├── workout/
│   │   ├── workout_list_screen.dart   # 30-day workout list
│   │   ├── day_exercises_screen.dart  # 7 exercises for a day
│   │   └── exercise_detail_screen.dart # Exercise detail with timer
│   ├── recipe/
│   │   ├── recipe_screen.dart         # 30-day diet grid
│   │   └── diet_detail_screen.dart    # Meals for a day
│   └── reports/
│       └── reports_screen.dart        # Calendar, Weight, BMI, BMR tabs
├── widgets/
│   ├── gradient_background.dart       # Reusable gradient container
│   ├── custom_card.dart               # Styled card widget
│   ├── day_card.dart                  # Workout day list item
│   ├── exercise_card.dart             # Exercise list item
│   ├── diet_meal_card.dart            # Expandable meal card
│   ├── bmi_gauge.dart                 # BMI visual gauge
│   └── weight_chart.dart              # Weight history line chart
└── utils/
    ├── constants.dart                 # App constants, motivational quotes
    └── helpers.dart                   # BMI/BMR calculations, formatting
```

## Installation

### Prerequisites
- Flutter SDK 3.x or later
- Android SDK (via Android Studio or command-line tools)
- Git

### Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd fit_yourself
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run on a device/emulator**
   ```bash
   flutter run
   ```

4. **Build release APK**
   ```bash
   flutter build apk --release
   ```
   The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

5. **Build split APKs (smaller)**
   ```bash
   flutter build apk --split-per-abi
   ```
   This creates architecture-specific APKs (~16-20MB each instead of ~53MB).

### Install on Android Device
1. Enable "Install from Unknown Sources" in phone settings
2. Transfer the APK to your phone
3. Open the APK file to install

## Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Primary Orange | #FF6B35 | Buttons, accents, selected states |
| Deep Blue | #004E89 | Secondary elements |
| Teal | #2EC4B6 | Accent, diet-related elements |
| Dark Navy | #1A1A2E | Background |
| Dark Blue-Grey | #16213E | Surface, cards |
| Medium Dark Blue | #0F3460 | Card backgrounds |
| Green | #00C853 | Success, completed states |
| White | #FFFFFF | Primary text |
| Light Grey | #B0BEC5 | Secondary text |
| Red | #FF5252 | Error, reset actions |

## BMI Formula
```
BMI = weight(kg) / height(m)^2
```
Categories: Underweight (<18.5), Normal (18.5-24.9), Overweight (25-29.9), Obese (>=30)

## BMR Formula (Mifflin-St Jeor)
```
Male:   BMR = (10 x weight_kg) + (6.25 x height_cm) - (5 x age) + 5
Female: BMR = (10 x weight_kg) + (6.25 x height_cm) - (5 x age) - 161
```

Activity Multipliers: Sedentary (x1.2), Light (x1.375), Moderate (x1.55), Active (x1.725), Very Active (x1.9)

## License

This project is for educational purposes.
