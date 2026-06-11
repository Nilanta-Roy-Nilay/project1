import 'package:flutter/material.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  double _height = 170;
  double _weight = 70; 
  double? _bmi;

  void _calculateBMI() {
    setState(() {
      _bmi = _weight / ((_height / 100) * (_height / 100));
    });
  }

  String get _bmiCategory {
    if (_bmi == null) return '';
    if (_bmi! < 18.5) return 'Underweight';
    if (_bmi! < 24.9) return 'Normal Weight';
    if (_bmi! < 29.9) return 'Overweight';
    return 'Obese';
  }

  Color get _bmiColor {
    if (_bmi == null) return Colors.white;
    if (_bmi! < 18.5) return Colors.blue;
    if (_bmi! < 24.9) return Colors.green;
    if (_bmi! < 29.9) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Height (cm)', style: TextStyle(fontSize: 18)),
                    Slider(
                      value: _height,
                      min: 100,
                      max: 220,
                      onChanged: (val) => setState(() => _height = val),
                    ),
                    Text('${_height.round()} cm', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Weight (kg)', style: TextStyle(fontSize: 18)),
                    Slider(
                      value: _weight,
                      min: 40,
                      max: 150,
                      divisions: 110,
                      onChanged: (val) => setState(() => _weight = val),
                    ),
                    Text('${_weight.round()} kg', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _calculateBMI,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: const Text('CALCULATE BMI'),
            ),
            const SizedBox(height: 32),
            if (_bmi != null) ...[
              const Text('Your BMI', style: TextStyle(fontSize: 20, color: Colors.grey)),
              Text(
                _bmi!.toStringAsFixed(1),
                style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: _bmiColor),
              ),
              Text(
                _bmiCategory,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _bmiColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
