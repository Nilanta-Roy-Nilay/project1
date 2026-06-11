class FoodItem {
  final String name;
  final double caloriesPerServing;
  final String servingSize;

  const FoodItem({
    required this.name,
    required this.caloriesPerServing,
    required this.servingSize,
  });
}

class FoodDatabase {
  static const List<FoodItem> foods = [
    // Grains & Carbs
    FoodItem(name: 'White Rice', caloriesPerServing: 200, servingSize: '1 cup cooked'),
    FoodItem(name: 'Brown Rice', caloriesPerServing: 215, servingSize: '1 cup cooked'),
    FoodItem(name: 'Bread', caloriesPerServing: 80, servingSize: '1 slice'),
    FoodItem(name: 'Pasta', caloriesPerServing: 220, servingSize: '1 cup cooked'),
    FoodItem(name: 'Oatmeal', caloriesPerServing: 150, servingSize: '1 cup cooked'),
    FoodItem(name: 'Quinoa', caloriesPerServing: 222, servingSize: '1 cup cooked'),
    
    // Proteins
    FoodItem(name: 'Chicken Breast', caloriesPerServing: 165, servingSize: '100g'),
    FoodItem(name: 'Salmon', caloriesPerServing: 206, servingSize: '100g'),
    FoodItem(name: 'Tuna', caloriesPerServing: 132, servingSize: '100g'),
    FoodItem(name: 'Egg', caloriesPerServing: 78, servingSize: '1 large'),
    FoodItem(name: 'Beef', caloriesPerServing: 250, servingSize: '100g'),
    FoodItem(name: 'Tofu', caloriesPerServing: 76, servingSize: '100g'),
    FoodItem(name: 'Greek Yogurt', caloriesPerServing: 100, servingSize: '1 cup'),
    
    // Vegetables
    FoodItem(name: 'Broccoli', caloriesPerServing: 55, servingSize: '1 cup'),
    FoodItem(name: 'Spinach', caloriesPerServing: 7, servingSize: '1 cup raw'),
    FoodItem(name: 'Carrot', caloriesPerServing: 25, servingSize: '1 medium'),
    FoodItem(name: 'Tomato', caloriesPerServing: 22, servingSize: '1 medium'),
    FoodItem(name: 'Cucumber', caloriesPerServing: 16, servingSize: '1 cup'),
    FoodItem(name: 'Bell Pepper', caloriesPerServing: 30, servingSize: '1 medium'),
    
    // Fruits
    FoodItem(name: 'Apple', caloriesPerServing: 95, servingSize: '1 medium'),
    FoodItem(name: 'Banana', caloriesPerServing: 105, servingSize: '1 medium'),
    FoodItem(name: 'Orange', caloriesPerServing: 62, servingSize: '1 medium'),
    FoodItem(name: 'Strawberries', caloriesPerServing: 49, servingSize: '1 cup'),
    FoodItem(name: 'Grapes', caloriesPerServing: 104, servingSize: '1 cup'),
    FoodItem(name: 'Mango', caloriesPerServing: 99, servingSize: '1 cup'),
    
    // Nuts & Seeds
    FoodItem(name: 'Almonds', caloriesPerServing: 164, servingSize: '1 oz (28g)'),
    FoodItem(name: 'Peanuts', caloriesPerServing: 161, servingSize: '1 oz (28g)'),
    FoodItem(name: 'Cashews', caloriesPerServing: 157, servingSize: '1 oz (28g)'),
    FoodItem(name: 'Walnuts', caloriesPerServing: 185, servingSize: '1 oz (28g)'),
    
    // Dairy
    FoodItem(name: 'Milk', caloriesPerServing: 149, servingSize: '1 cup'),
    FoodItem(name: 'Cheese', caloriesPerServing: 113, servingSize: '1 oz (28g)'),
    FoodItem(name: 'Butter', caloriesPerServing: 102, servingSize: '1 tbsp'),
    
    // Beverages
    FoodItem(name: 'Coffee (black)', caloriesPerServing: 2, servingSize: '1 cup'),
    FoodItem(name: 'Tea (unsweetened)', caloriesPerServing: 2, servingSize: '1 cup'),
    FoodItem(name: 'Orange Juice', caloriesPerServing: 112, servingSize: '1 cup'),
    
    // Fast Food / Snacks
    FoodItem(name: 'Pizza', caloriesPerServing: 285, servingSize: '1 slice'),
    FoodItem(name: 'Burger', caloriesPerServing: 354, servingSize: '1 medium'),
    FoodItem(name: 'French Fries', caloriesPerServing: 365, servingSize: 'medium serving'),
    FoodItem(name: 'Chocolate Bar', caloriesPerServing: 235, servingSize: '1 bar (45g)'),
    FoodItem(name: 'Potato Chips', caloriesPerServing: 152, servingSize: '1 oz (28g)'),
  ];

  static List<FoodItem> searchFoods(String query) {
    if (query.isEmpty) return foods;
    
    final lowerQuery = query.toLowerCase();
    return foods.where((food) => 
      food.name.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  static FoodItem? getFoodByName(String name) {
    try {
      return foods.firstWhere(
        (food) => food.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
