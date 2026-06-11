# Fit Yourself by Exercise — Complete Development Guide

**A Comprehensive Flutter App Development Tutorial**
**Version 1.0 | February 2026**

---

## Table of Contents

1. Introduction
2. Project Setup & Dependencies
3. App Architecture Overview
4. Theme & Styling
5. Data Models
6. Local Storage with Hive
7. App Entry Point (main.dart)
8. Splash Screen
9. Main Navigation
10. Workout List Screen
11. Day Exercises Screen
12. Exercise Detail Screen with Timer
13. Recipe Screen
14. Diet Detail Screen
15. Reports Screen (4 Tabs)
16. Custom Widgets
17. Utility Functions
18. Exercise Data Structure
19. Diet Data Structure
20. Android Configuration
21. Building & Deployment
22. Key Flutter Concepts
23. Troubleshooting

---

## 1. Introduction

### 1.1 What is "Fit Yourself by Exercise"?

Fit Yourself by Exercise is a **30-day fitness and diet tracking application** built with Flutter. It provides:

- **210 unique exercises** spread across 30 structured workout days
- **240 unique meal plans** (Standard and Vegetarian options for each day)
- **Progress tracking** with visual indicators
- **BMI and BMR calculators** with interactive UI
- **Weight tracking** with charts
- **Motivational quotes** and streak counting

The app stores all data **locally on the device** using Hive — no internet connection or server is needed.

### 1.2 Target Audience

This guide is written for university students and beginner Flutter developers who want to understand how a real-world mobile application is built from scratch.

### 1.3 Tech Stack

| Technology | Purpose |
|-----------|---------|
| Flutter 3.41.2 | Cross-platform UI framework |
| Dart 3.11.0 | Programming language |
| Hive | Local NoSQL database |
| fl_chart | Chart widgets |
| flutter_animate | Animation library |
| animated_text_kit | Text animations |
| google_fonts | Custom fonts (Poppins) |
| percent_indicator | Circular and linear progress bars |
| table_calendar | Calendar widget |
| intl | Date formatting |
| path_provider | File system paths |
| shared_preferences | Simple key-value storage |

---

## 2. Project Setup & Dependencies

### 2.1 Creating the Project

```bash
flutter create fit_yourself --org com.fityourself --project-name fit_yourself
```

- `--org com.fityourself`: Sets the organization identifier (used in Android package name)
- `--project-name fit_yourself`: Sets the project name

### 2.2 pubspec.yaml Explained

The `pubspec.yaml` file is the **configuration file** for every Flutter/Dart project. It defines the project name, version, SDK constraints, and dependencies.

```yaml
name: fit_yourself
description: "Fit Yourself by Exercise - 30 Day Fitness & Diet Tracker"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.11.0
```

**Key fields:**
- `name`: The Dart package name (must be lowercase with underscores)
- `publish_to: 'none'`: Prevents accidental publishing to pub.dev
- `version: 1.0.0+1`: `1.0.0` is the display version, `+1` is the build number
- `sdk: ^3.11.0`: Requires Dart SDK version 3.11.0 or higher

**Dependencies explained:**

| Package | Version | What It Does |
|---------|---------|-------------|
| `hive` | ^2.2.3 | Fast, lightweight NoSQL database for local storage |
| `hive_flutter` | ^1.1.0 | Flutter-specific Hive adapters and initialization |
| `table_calendar` | ^3.0.9 | Highly customizable calendar widget |
| `fl_chart` | ^0.66.0 | Beautiful charts (line, bar, pie) |
| `google_fonts` | ^6.1.0 | Use any Google Font without downloading font files |
| `animated_text_kit` | ^4.2.2 | Pre-built text animations (typewriter, fade, etc.) |
| `percent_indicator` | ^4.2.3 | Circular and linear progress indicators |
| `intl` | ^0.19.0 | Internationalization and date formatting |
| `path_provider` | ^2.1.1 | Find commonly used file paths on the device |
| `flutter_animate` | ^4.3.0 | Declarative animation library with chaining |
| `shared_preferences` | ^2.2.2 | Simple persistent key-value storage |

### 2.3 Project Folder Structure

```
lib/
├── main.dart              ← App entry point
├── app.dart               ← MaterialApp configuration
├── theme/                 ← Visual styling
├── models/                ← Data classes
├── data/                  ← Data sources and storage
├── screens/               ← Full-page UI screens
├── widgets/               ← Reusable UI components
└── utils/                 ← Helper functions and constants
```

**Why this structure?**
- **Separation of concerns**: Each folder has a single responsibility
- **Scalability**: Easy to add new screens or features
- **Readability**: A new developer can quickly find any file

---

## 3. App Architecture Overview

### 3.1 Navigation Flow

```
SplashScreen (3 seconds)
    │
    ▼
MainNavigation (BottomNavigationBar)
    ├── Tab 0: WorkoutListScreen
    │       └── DayExercisesScreen
    │               └── ExerciseDetailScreen
    ├── Tab 1: RecipeScreen
    │       └── DietDetailScreen
    └── Tab 2: ReportsScreen
            ├── Calendar Tab
            ├── Weight Tab
            ├── BMI Tab
            └── BMR Tab
```

### 3.2 Data Flow

```
User Action → Screen (setState) → StorageService → Hive Box
                                                      │
Hive Box → StorageService → Screen reads data → UI updates
```

All data is stored in **Hive boxes** (like tables in a database):
- `workoutBox` — completed days and exercise durations
- `dietBox` — completed diet days and selected diet types
- `weightBox` — weight history entries
- `settingsBox` — user profile (height, weight, age, gender)

### 3.3 Singleton Pattern

The `StorageService` uses the **Singleton pattern** — only one instance exists throughout the app:

```dart
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();
}
```

**How it works:**
1. `_instance` is a private static field initialized once
2. The `factory` constructor always returns the same `_instance`
3. `_internal()` is a private named constructor that can only be called internally

**Why Singleton?** We want exactly one object managing all storage operations. Creating multiple instances could lead to race conditions or inconsistent data.

---

## 4. Theme & Styling

### 4.1 Color Palette

```dart
class AppColors {
  static const Color primary = Color(0xFFFF6B35);      // Vibrant orange
  static const Color secondary = Color(0xFF004E89);     // Deep blue
  static const Color accent = Color(0xFF2EC4B6);        // Teal
  static const Color background = Color(0xFF1A1A2E);    // Dark navy
  static const Color surface = Color(0xFF16213E);       // Dark blue-grey
  static const Color card = Color(0xFF0F3460);          // Medium dark blue
  static const Color success = Color(0xFF00C853);       // Green
  static const Color textPrimary = Color(0xFFFFFFFF);   // White
  static const Color textSecondary = Color(0xFFB0BEC5); // Light grey
  static const Color error = Color(0xFFFF5252);         // Red
}
```

**Design Rationale:**
- **Dark theme** reduces eye strain during workouts
- **Orange primary** conveys energy and motivation
- **Teal accent** provides contrast for diet/nutrition elements
- **Green success** gives clear positive feedback for completed items

### 4.2 ThemeData Configuration

```dart
static ThemeData get darkTheme {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      // ...
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ),
    // ...
  );
}
```

**Key concepts:**
- `ThemeData` is Flutter's way of defining global visual properties
- `ColorScheme.dark()` provides a dark color palette base
- `GoogleFonts.poppinsTextTheme()` replaces the default font with Poppins across the entire app
- Each widget theme (AppBar, Card, Button, etc.) can be customized individually

---

## 5. Data Models

### 5.1 Exercise Model

```dart
class Exercise {
  final String name;
  final String description;
  final List<String> instructions;
  final String targetMuscle;
  final String difficulty;
  final int defaultDuration;
  final String emoji;

  const Exercise({
    required this.name,
    required this.description,
    required this.instructions,
    required this.targetMuscle,
    required this.difficulty,
    required this.defaultDuration,
    required this.emoji,
  });
}
```

**Why `const` constructor?**
The `const` keyword allows Dart to create compile-time constants. Since exercise data never changes at runtime, using `const` means:
- Objects are created once at compile time, not at runtime
- Memory is shared — identical const objects point to the same memory
- Better performance in lists with hundreds of items

**Why `final` fields?**
`final` means the field can only be set once (in the constructor). This makes the class **immutable** — once created, an Exercise cannot be modified. Immutability prevents bugs caused by accidental mutations.

### 5.2 WorkoutDay Model

```dart
class WorkoutDay {
  final int dayNumber;
  final String title;
  final String subtitle;
  final List<Exercise> exercises;
  final bool isRestDay;

  const WorkoutDay({
    required this.dayNumber,
    required this.title,
    required this.subtitle,
    required this.exercises,
    this.isRestDay = false,
  });

  int get estimatedMinutes => (exercises.fold<int>(
          0, (sum, e) => sum + e.defaultDuration) / 60).ceil();
}
```

**Computed property `estimatedMinutes`:**
- Uses a **getter** (`get`) instead of storing the value
- `fold<int>()` iterates through exercises, summing all `defaultDuration` values
- Divides by 60 to convert seconds to minutes
- `.ceil()` rounds up (350 seconds = 5.83 minutes = 6 minutes)

### 5.3 Meal and DietDay Models

```dart
class Meal {
  final String name;
  final int calories;
  final String description;
  final List<String> ingredients;
  final String mealTime;   // "Breakfast", "Snack", "Lunch", "Dinner"

  const Meal({...});
}

class DietDay {
  final int dayNumber;
  final List<Meal> standardMeals;
  final List<Meal> vegetarianMeals;

  const DietDay({...});

  int totalCalories(bool isVegetarian) {
    final meals = isVegetarian ? vegetarianMeals : standardMeals;
    return meals.fold<int>(0, (sum, m) => sum + m.calories);
  }
}
```

The `totalCalories` method demonstrates the **strategy pattern** — the same calculation works for both diet types, selected by a boolean flag.

---

## 6. Local Storage with Hive

### 6.1 Why Hive?

| Feature | Hive | SharedPreferences | SQLite |
|---------|------|-------------------|--------|
| Speed | Very fast | Fast for simple data | Moderate |
| Data types | Any (with adapters) | Primitives only | SQL tables |
| Setup complexity | Low | Very low | High |
| Query capability | Basic key-value | Basic key-value | Full SQL |
| Best for | Medium complexity | Simple settings | Complex relational data |

Hive was chosen because our data is **structured but not relational** — we need more than simple key-value pairs, but we don't need SQL joins or complex queries.

### 6.2 Hive Initialization

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('workoutBox');
  await Hive.openBox('dietBox');
  await Hive.openBox('weightBox');
  await Hive.openBox('settingsBox');
  runApp(const FitYourselfApp());
}
```

**Line-by-line explanation:**
1. `WidgetsFlutterBinding.ensureInitialized()` — Required before any async operations in `main()`
2. `Hive.initFlutter()` — Initializes Hive with the app's documents directory
3. `Hive.openBox('workoutBox')` — Opens (or creates) a named storage box
4. Each box is like a separate "table" that persists across app restarts

### 6.3 StorageService — Workout Methods

```dart
Future<void> markWorkoutDayComplete(int day) async {
  final completed = getCompletedWorkoutDays();
  if (!completed.contains(day)) {
    completed.add(day);
    await _workoutBox.put('completedDays', jsonEncode(completed));
  }
  await _workoutBox.put('completedDate_$day', DateTime.now().toIso8601String());
}
```

**How it works:**
1. Gets the current list of completed days
2. Adds the new day if not already present
3. Stores the list as a JSON-encoded string
4. Also stores the completion date for future reference

**Why JSON encoding?** Hive stores primitive types natively (String, int, bool), but for `List<int>` or `Map`, we encode to JSON string. This avoids needing custom Hive adapters.

```dart
Future<void> saveExerciseDuration(int day, String exerciseName, int seconds) async {
  final durations = getExerciseDurations(day);
  durations[exerciseName] = seconds;
  await _workoutBox.put('durations_$day', jsonEncode(durations));
}
```

**Key pattern:** Each day's durations are stored with a dynamic key `durations_$day` (e.g., `durations_1`, `durations_2`). This avoids loading all 30 days' data when you only need one day.

### 6.4 Streak Calculation

```dart
int getWorkoutStreak() {
  final completed = getCompletedWorkoutDays()..sort();
  if (completed.isEmpty) return 0;
  int streak = 1;
  int maxStreak = 1;
  for (int i = 1; i < completed.length; i++) {
    if (completed[i] == completed[i - 1] + 1) {
      streak++;
      if (streak > maxStreak) maxStreak = streak;
    } else {
      streak = 1;
    }
  }
  return maxStreak;
}
```

**Algorithm:**
1. Sort completed day numbers
2. Walk through the sorted list
3. If the current day is exactly 1 more than the previous → streak continues
4. Otherwise → streak resets to 1
5. Track the maximum streak seen

---

## 7. App Entry Point (main.dart)

```dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('workoutBox');
  await Hive.openBox('dietBox');
  await Hive.openBox('weightBox');
  await Hive.openBox('settingsBox');
  runApp(const FitYourselfApp());
}
```

**Why `async main()`?**
Normally `main()` is synchronous. But Hive initialization requires `await` (it needs to find the app's file directory). The `async` keyword lets us use `await` inside `main()`.

**Why `WidgetsFlutterBinding.ensureInitialized()`?**
Flutter's engine needs to be ready before we call platform-specific code (like accessing the file system). This method ensures the binding between Dart code and the native platform is established.

---

## 8. Splash Screen

```dart
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainNavigation(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }
```

**Key concepts:**

1. **`Future.delayed`**: Waits 3 seconds then executes the callback
2. **`mounted` check**: Ensures the widget is still in the tree (prevents errors if user navigates away)
3. **`pushReplacement`**: Replaces the splash screen in the navigation stack (so pressing "back" doesn't return to splash)
4. **`PageRouteBuilder`**: Creates a custom page transition (fade instead of the default slide)

**AnimatedTextKit usage:**
```dart
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
```

This creates a **typewriter effect** where each character appears one at a time (80ms between characters).

**flutter_animate for pulsing icon:**
```dart
const Icon(Icons.fitness_center, size: 60, color: AppColors.primary)
    .animate(onPlay: (c) => c.repeat())
    .scale(begin: Offset(1.0, 1.0), end: Offset(1.15, 1.15), duration: 800.ms)
    .then()
    .scale(begin: Offset(1.15, 1.15), end: Offset(1.0, 1.0), duration: 800.ms),
```

This creates a **breathing/pulsing effect**: scale up 15%, then scale back down, repeating forever.

---

## 9. Main Navigation

```dart
class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    WorkoutListScreen(),
    RecipeScreen(),
    ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Exercise'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Recipe'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Reports'),
        ],
      ),
    );
  }
}
```

**Why `IndexedStack` instead of switching widgets?**
`IndexedStack` keeps **all three screens alive in memory** but only shows one at a time. This means:
- Scroll position is preserved when switching tabs
- No rebuilding when returning to a tab
- State is maintained across tab switches

**`setState(() => _currentIndex = index)`**: When the user taps a tab, we update `_currentIndex` and call `setState()` to trigger a rebuild. The `IndexedStack` then shows the screen at the new index.

---

## 10. Workout List Screen

### 10.1 Progress Card

```dart
Container(
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primary, AppColors.secondary],
    ),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Row(
    children: [
      CircularPercentIndicator(
        radius: 40,
        lineWidth: 6,
        percent: percent.clamp(0.0, 1.0),
        center: Text('${(percent * 100).toInt()}%'),
        progressColor: Colors.white,
        backgroundColor: Colors.white24,
      ),
      // ... text info
    ],
  ),
),
```

**`.clamp(0.0, 1.0)`**: Ensures the percentage never goes below 0 or above 1, preventing rendering errors in the indicator.

### 10.2 ListView inside SingleChildScrollView

```dart
ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: _allDays.length,
  itemBuilder: (context, index) { ... },
)
```

**Why this pattern?**
- `shrinkWrap: true` — Makes the ListView only take as much space as its children need
- `NeverScrollableScrollPhysics()` — Disables the ListView's own scrolling
- The outer `SingleChildScrollView` handles all scrolling

This is necessary when you have a progress card + header text + list all in one scrollable view.

### 10.3 Staggered Animation

```dart
.animate()
.fadeIn(delay: (50 * index).ms, duration: 300.ms)
.slideX(begin: 0.2, end: 0)
```

Each card gets a **50ms delay multiplied by its index**. So card 0 appears immediately, card 1 at 50ms, card 2 at 100ms, etc. This creates a **cascade/waterfall effect**.

---

## 11. Day Exercises Screen

### 11.1 "Complete Day" Button Logic

```dart
final allHaveDuration =
    day.exercises.every((e) => (durations[e.name] ?? 0) > 0);

ElevatedButton(
  onPressed: allHaveDuration ? () async {
    await _storage.markWorkoutDayComplete(widget.dayNumber);
    // show success dialog
  } : null,  // null = button is disabled
)
```

**`every()` method**: Returns `true` only if **all** items in the list satisfy the condition. The button remains disabled until every exercise has a saved duration > 0.

**`onPressed: null`**: In Flutter, setting `onPressed` to `null` automatically disables the button and applies the disabled styling.

---

## 12. Exercise Detail Screen with Timer

### 12.1 Timer Implementation

```dart
import 'dart:async';

Timer? _timer;
int _timerSeconds = 0;
bool _timerRunning = false;

void _startTimer() {
  if (_timerRunning) return;
  setState(() => _timerRunning = true);
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_timerSeconds <= 0) {
      timer.cancel();
      setState(() => _timerRunning = false);
      HapticFeedback.heavyImpact();
      _saveAndNotify();
      return;
    }
    setState(() => _timerSeconds--);
  });
}
```

**How `Timer.periodic` works:**
1. Creates a timer that fires **every 1 second**
2. Each tick decrements `_timerSeconds` and calls `setState()` to update the UI
3. When it reaches 0, the timer cancels itself, triggers haptic feedback, and auto-saves

**`HapticFeedback.heavyImpact()`**: Makes the phone vibrate when the timer completes — physical feedback the user can feel.

### 12.2 ChoiceChip for Duration Selection

```dart
Wrap(
  spacing: 8,
  children: [15, 30, 45, 60, 90, 120].map((seconds) {
    return ChoiceChip(
      label: Text('${seconds}s'),
      selected: _selectedDuration == seconds,
      onSelected: (selected) {
        setState(() {
          _selectedDuration = seconds;
          _timerSeconds = seconds;
        });
      },
    );
  }).toList(),
),
```

**`ChoiceChip`**: A Material Design chip that acts like a radio button. Only one can be selected at a time. `Wrap` widget automatically wraps chips to the next line if they don't fit.

### 12.3 Custom Duration Input with Validation

```dart
final val = int.tryParse(_customController.text);
if (val != null && val >= 5 && val <= 300) {
  // valid — use the value
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Enter a value between 5 and 300')),
  );
}
```

**`int.tryParse()`**: Unlike `int.parse()` which throws an exception on invalid input, `tryParse()` returns `null`. This is safer for user input validation.

---

## 13. Recipe Screen

### 13.1 GridView for 30 Days

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 5,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 1,  // Square cells
  ),
  itemCount: 30,
  itemBuilder: (context, index) {
    final day = index + 1;
    final isCompleted = completedDays.contains(day);
    return Container(
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.success : AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Text('$day')),
    );
  },
)
```

**`SliverGridDelegateWithFixedCrossAxisCount`**: Creates a grid with exactly 5 columns. `childAspectRatio: 1` makes each cell a perfect square.

---

## 14. Diet Detail Screen

### 14.1 Diet Type Selector

```dart
bool _isVegetarian = false;

// In initState:
final savedType = _storage.getDietType(widget.dayNumber);
if (savedType != null) {
  _isVegetarian = savedType == 'Vegetarian';
}
```

If the user previously completed this day and chose Vegetarian, it remembers that selection.

### 14.2 ExpansionTile for Meal Cards

```dart
ExpansionTile(
  leading: Text(emoji, style: const TextStyle(fontSize: 28)),
  title: Text(meal.name),
  subtitle: Row(children: [
    Text(meal.mealTime),
    Container(child: Text('${meal.calories} cal')),
  ]),
  children: [
    Text(meal.description),
    Wrap(children: meal.ingredients.map((i) => Chip(label: Text(i))).toList()),
  ],
),
```

**`ExpansionTile`**: A Material widget that can expand to show additional content. The user taps to see the meal description and ingredients. This saves screen space while keeping all info accessible.

---

## 15. Reports Screen

### 15.1 Tab Structure

```dart
class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
```

**`SingleTickerProviderStateMixin`**: Provides a `Ticker` for animation. `TabController` needs this to animate tab transitions. The `vsync: this` parameter synchronizes the animation with the screen's refresh rate.

### 15.2 BMI Calculation

```dart
static double calculateBMI(double weightKg, double heightCm) {
  final heightM = heightCm / 100;
  return weightKg / (heightM * heightM);
}

static String getBMICategory(double bmi) {
  if (bmi < 18.5) return 'Underweight';
  if (bmi < 25) return 'Normal Weight';
  if (bmi < 30) return 'Overweight';
  return 'Obese';
}
```

**BMI Formula**: `weight(kg) / height(m)^2`

### 15.3 BMR Calculation (Mifflin-St Jeor)

```dart
static double calculateBMR({
  required double weightKg,
  required double heightCm,
  required int age,
  required bool isMale,
}) {
  if (isMale) {
    return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
  }
  return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
}
```

**BMR** = Basal Metabolic Rate (calories burned at rest)
- Male formula adds +5
- Female formula subtracts -161
- The difference accounts for physiological differences in body composition

**TDEE** = BMR x Activity Multiplier:
- Sedentary (x1.2), Light (x1.375), Moderate (x1.55), Active (x1.725), Very Active (x1.9)

### 15.4 Macro Split Calculation

```dart
static Map<String, double> calculateMacros(double tdee) {
  final proteinCalories = tdee * 0.30;  // 30% from protein
  final carbCalories = tdee * 0.45;      // 45% from carbs
  final fatCalories = tdee * 0.25;       // 25% from fat
  return {
    'protein': proteinCalories / 4,  // 4 calories per gram of protein
    'carbs': carbCalories / 4,        // 4 calories per gram of carbs
    'fat': fatCalories / 9,           // 9 calories per gram of fat
  };
}
```

### 15.5 Weight Chart with fl_chart

```dart
LineChartBarData(
  spots: spots,            // List<FlSpot> — x,y coordinates
  isCurved: true,          // Smooth curve instead of straight lines
  curveSmoothness: 0.3,   // How smooth the curve is
  color: AppColors.primary,
  barWidth: 3,
  dotData: FlDotData(show: true),
  belowBarData: BarAreaData(
    show: true,
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primary.withValues(alpha: 0.3),
        AppColors.primary.withValues(alpha: 0.0),
      ],
    ),
  ),
),
```

This creates a smooth curved line chart with:
- Dots on each data point
- A gradient fill below the line (orange fading to transparent)
- Touch tooltips showing exact values

---

## 16. Custom Widgets

### 16.1 BMI Gauge Widget

The BMI gauge is a horizontal colored bar with four zones and a pointer:

```dart
Row(
  children: [
    Expanded(flex: 185, child: Container(color: Colors.blue)),     // < 18.5
    Expanded(flex: 65,  child: Container(color: AppColors.success)), // 18.5–24.9
    Expanded(flex: 50,  child: Container(color: Colors.orange)),    // 25–29.9
    Expanded(flex: 200, child: Container(color: AppColors.error)),  // >= 30
  ],
)
```

The `flex` values are proportional to the BMI range widths. The pointer position is calculated:
```dart
double _getPosition(double bmi, double totalWidth) {
  double clampedBmi = bmi.clamp(10, 50);
  double ratio = (clampedBmi - 10) / 40;
  return ratio * totalWidth;
}
```

### 16.2 Reusable Card Widgets

The `DayCard`, `ExerciseCard`, and `DietMealCard` follow a common pattern:
1. Accept data through constructor parameters
2. Apply consistent styling from the theme
3. Handle tap events via callbacks (`onTap: VoidCallback`)
4. Use conditional rendering based on state (completed vs. not completed)

---

## 17. Utility Functions

### 17.1 Duration Formatting

```dart
static String formatDuration(int seconds) {
  if (seconds < 60) return '${seconds}s';
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  if (remainingSeconds == 0) return '${minutes}m';
  return '${minutes}m ${remainingSeconds}s';
}
```

`~/` is Dart's **integer division** operator (rounds down). `%` is the **modulo** operator (gives remainder).

### 17.2 Progress Sharing

```dart
static Future<void> copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}
```

Uses Flutter's `Clipboard` API to copy text to the system clipboard. The user can then paste it in any messaging app.

---

## 18. Exercise Data Structure

### 18.1 Organization

The `exercise_data.dart` file contains a single class `ExerciseData` with a static method `getAllDays()` that returns a list of 30 `WorkoutDay` objects, each containing 7 `Exercise` objects.

**Example of one day:**
```dart
WorkoutDay(
  dayNumber: 1,
  title: 'Day 1 - Full Body Basics',
  subtitle: 'Start your journey with fundamental moves',
  exercises: [
    Exercise(
      name: 'Jumping Jacks',
      description: 'A classic full-body warm-up that raises your heart rate...',
      instructions: [
        'Stand upright with feet together and arms at sides.',
        'Jump feet apart while raising arms overhead.',
        'Jump back to starting position.',
        'Maintain a steady rhythm throughout.',
      ],
      targetMuscle: 'Cardio',
      difficulty: 'Beginner',
      defaultDuration: 45,
      emoji: '🔥',
    ),
    // ... 6 more exercises
  ],
),
```

### 18.2 Day Types

| Day(s) | Type | Description |
|--------|------|-------------|
| 1-13 | Progressive | Gradually increasing difficulty |
| 14 | Rest & Stretch | 7 stretching exercises |
| 15-20 | Advanced | More complex movements |
| 21 | Rest & Mobility | Yoga-inspired mobility work |
| 22-27 | Peak Training | Highest difficulty exercises |
| 28 | HIIT Circuit | Maximum intensity intervals |
| 29 | Endurance | Maximum-hold isometric exercises |
| 30 | Final Test | Timed max-rep challenges |

---

## 19. Diet Data Structure

### 19.1 Organization

Each day provides **two complete meal plans** (Standard and Vegetarian) with 4 meals each:

```dart
DietDay(
  dayNumber: 1,
  standardMeals: [
    Meal(name: 'Scrambled Eggs & Toast', calories: 350,
         description: 'Fluffy scrambled eggs on whole grain toast...',
         ingredients: ['Eggs', 'Whole grain bread', 'Butter', 'Salt & pepper'],
         mealTime: 'Breakfast'),
    // Snack, Lunch, Dinner
  ],
  vegetarianMeals: [
    Meal(name: 'Oatmeal & Banana', calories: 320,
         description: 'Warm oatmeal topped with sliced banana...',
         ingredients: ['Oats', 'Banana', 'Honey', 'Cinnamon'],
         mealTime: 'Breakfast'),
    // Snack, Lunch, Dinner
  ],
),
```

Each day totals approximately **1400-1600 calories** across all 4 meals.

---

## 20. Android Configuration

### 20.1 AndroidManifest.xml

```xml
<application android:label="Fit Yourself" ...>
```

The `android:label` sets the app name shown on the home screen and in the app drawer.

### 20.2 build.gradle.kts

```kotlin
defaultConfig {
    applicationId = "com.fityourself.fit_yourself"
    minSdk = flutter.minSdkVersion    // Minimum Android version (API 21 = Android 5.0)
    targetSdk = flutter.targetSdkVersion  // Target Android version
}
```

- **minSdk**: The oldest Android version supported (API 21 = 97%+ of devices)
- **targetSdk**: The newest Android version you've tested against
- **compileSdk**: The Android SDK version used to compile the app

---

## 21. Building & Deployment

### 21.1 Analyze Code

```bash
flutter analyze
```

Checks for:
- Type errors
- Unused imports
- Style violations
- Potential bugs

### 21.2 Build Release APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk` (~53MB)

### 21.3 Build Split APKs

```bash
flutter build apk --split-per-abi
```

Creates three smaller APKs:
- `app-armeabi-v7a-release.apk` (~16MB) — Older 32-bit ARM phones
- `app-arm64-v8a-release.apk` (~19MB) — Modern 64-bit ARM phones (most common)
- `app-x86_64-release.apk` (~20MB) — Intel/AMD-based devices and emulators

---

## 22. Key Flutter Concepts Used

### 22.1 StatelessWidget vs StatefulWidget

- **StatelessWidget**: No mutable state. Build output depends only on constructor parameters. Used for: `GradientBackground`, `DayCard`, `ExerciseCard`
- **StatefulWidget**: Has mutable state via `setState()`. Build output can change over time. Used for: all screens, anything with user interaction

### 22.2 Widget Lifecycle

```
createState() → initState() → build() → [setState() → build()]* → dispose()
```

- `initState()`: Called once when the widget is inserted into the tree. Initialize controllers, load data.
- `build()`: Called every time state changes. Must return a Widget. Should be pure (no side effects).
- `dispose()`: Called when widget is removed from the tree. Cancel timers, dispose controllers.

### 22.3 Navigation

```dart
// Push a new screen on top
Navigator.push(context, MaterialPageRoute(builder: (_) => NewScreen()));

// Push and replace current screen
Navigator.pushReplacement(context, route);

// Go back to previous screen
Navigator.pop(context);
```

### 22.4 async/await

```dart
Future<void> _saveAndNotify() async {
  await _storage.saveExerciseDuration(day, name, seconds);  // Wait for save
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(...);  // Then show feedback
    Navigator.pop(context);  // Then go back
  }
}
```

`async/await` makes asynchronous code read like synchronous code. The `await` keyword pauses execution until the `Future` completes.

---

## 23. Troubleshooting

### Common Issues

| Issue | Cause | Fix |
|-------|-------|-----|
| "Hive not initialized" | Called Hive before `initFlutter()` | Ensure `await Hive.initFlutter()` in `main()` |
| "BuildContext across async gaps" | Using context after await | Check `mounted` before using context |
| "Android SDK not found" | ANDROID_HOME not set | Set the environment variable in your shell profile |
| "Dependency conflicts" | Incompatible package versions | Run `flutter pub outdated` and resolve conflicts |
| "Gradle build failed" | JDK version mismatch | Ensure Java 17 is installed and configured |
| White screen on launch | Exception in main() | Check debug console for errors |
| Data not persisting | Box not opened | Verify all Hive boxes are opened in main() |

### Useful Commands

```bash
flutter doctor -v          # Detailed system health check
flutter clean              # Delete build cache (fixes many issues)
flutter pub get            # Install dependencies
flutter pub outdated       # Check for newer package versions
flutter analyze            # Static code analysis
flutter run --verbose      # Run with detailed logging
```

---

**End of Documentation**

*This guide was created as part of the Fit Yourself by Exercise project. It covers all major aspects of the application from architecture to deployment, with code examples from every file in the project.*
