class Meal {
  final String name;
  final int calories;
  final String description;
  final List<String> ingredients;
  final String mealTime;

  const Meal({
    required this.name,
    required this.calories,
    required this.description,
    required this.ingredients,
    required this.mealTime,
  });
}

class DietDay {
  final int dayNumber;
  final List<Meal> standardMeals;
  final List<Meal> vegetarianMeals;

  const DietDay({
    required this.dayNumber,
    required this.standardMeals,
    required this.vegetarianMeals,
  });

  int totalCalories(bool isVegetarian) {
    final meals = isVegetarian ? vegetarianMeals : standardMeals;
    return meals.fold<int>(0, (sum, m) => sum + m.calories);
  }
}
