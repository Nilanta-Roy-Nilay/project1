import 'package:fitness/core/food_database.dart';
import 'package:fitness/models/food_intake_model.dart';
import 'package:fitness/services/firestore_service.dart';
import 'package:fitness/services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodInputScreen extends StatefulWidget {
  const FoodInputScreen({super.key});

  @override
  State<FoodInputScreen> createState() => _FoodInputScreenState();
}

class _FoodInputScreenState extends State<FoodInputScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '1');
  FoodItem? _selectedFood;
  List<FoodItem> _searchResults = [];
  bool _isLoading = false;
  bool _isSearchingAI = false;

  @override
  void initState() {
    super.initState();
    _searchResults = FoodDatabase.foods.take(10).toList();
  }

  void _searchFoods(String query) {
    if (query.isEmpty) {
      if (mounted) setState(() => _searchResults = FoodDatabase.foods.take(10).toList());
      return;
    }
    setState(() {
      _searchResults = FoodDatabase.searchFoods(query).take(10).toList();
    });
  }

  Future<void> _searchAI(String query) async {
    if (query.trim().isEmpty) return;
    
    setState(() => _isSearchingAI = true);
    
    final gemini = Provider.of<GeminiService>(context, listen: false);
    final calories = await gemini.getCaloriesForFood(query);
    
    if (mounted) {
      setState(() {
        _isSearchingAI = false;
        if (calories != null && calories > 0) {
          // Add custom AI item to results
          final customItem = FoodItem(
            name: query.trim(),
            caloriesPerServing: calories,
            servingSize: '1 serving',
          );
          _searchResults = [customItem, ..._searchResults];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not estimate calories. Please try another term by avoiding special characters.')),
          );
        }
      });
    }
  }

  void _selectFood(FoodItem food) {
    setState(() {
      _selectedFood = food;
      _searchController.text = food.name;
      _searchResults = [];
    });
  }

  double get _calculatedCalories {
    if (_selectedFood == null) return 0;
    final quantity = double.tryParse(_quantityController.text) ?? 1;
    return _selectedFood!.caloriesPerServing * quantity;
  }

  void _logFood() async {
    if (_selectedFood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a food item')),
      );
      return;
    }

    final quantity = double.tryParse(_quantityController.text);
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final foodIntake = FoodIntake(
          id: const Uuid().v4(),
          userId: user.uid,
          foodName: _selectedFood!.name,
          calories: _selectedFood!.caloriesPerServing,
          quantity: quantity,
          timestamp: DateTime.now(),
        );

        await Provider.of<FirestoreService>(context, listen: false).logFood(foodIntake);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logged ${foodIntake.totalCalories.toStringAsFixed(0)} calories')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Food'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Food',
                hintText: 'Type food name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isSearchingAI)
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.auto_awesome, color: Colors.purpleAccent),
                        tooltip: 'Estimate via AI',
                        onPressed: () => _searchAI(_searchController.text),
                      ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _selectedFood = null;
                            _searchResults = FoodDatabase.foods.take(10).toList();
                          });
                        },
                      ),
                  ],
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: _searchFoods,
              onSubmitted: (_) => _searchAI(_searchController.text),
            ),
            
            // Search Results
            if (_searchResults.isNotEmpty && _selectedFood == null) ...[
              const SizedBox(height: 12),
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length + 1, // Add 1 for the AI suggestion tile
                  itemBuilder: (context, index) {
                    if (index == _searchResults.length) {
                      return ListTile(
                        leading: const Icon(Icons.auto_awesome, color: Colors.purpleAccent),
                        title: const Text('Don\'t see it? Ask AI to estimate'),
                        onTap: () => _searchAI(_searchController.text),
                      );
                    }
                    final food = _searchResults[index];
                    return ListTile(
                      title: Text(food.name),
                      subtitle: Text('${food.caloriesPerServing.toStringAsFixed(0)} cal per ${food.servingSize}'),
                      onTap: () => _selectFood(food),
                    );
                  },
                ),
              ),
            ],

            // Selected Food Info
            if (_selectedFood != null) ...[
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedFood!.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_selectedFood!.caloriesPerServing.toStringAsFixed(0)} calories per ${_selectedFood!.servingSize}',
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Quantity Input
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity (servings)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
              ),
              
              const SizedBox(height: 24),
              
              // Calorie Display
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Calories',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _calculatedCalories.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'kcal',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Log Button
              ElevatedButton(
                onPressed: _isLoading ? null : _logFood,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('LOG FOOD', style: TextStyle(fontSize: 16)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
