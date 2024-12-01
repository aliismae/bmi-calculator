import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(BMICalculatorApp());
}

class BMICalculatorApp extends StatefulWidget {
  @override
  _BMICalculatorAppState createState() => _BMICalculatorAppState();
}

class _BMICalculatorAppState extends State<BMICalculatorApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: BMICalculator(toggleTheme: toggleTheme),
    );
  }
}

class BMICalculator extends StatefulWidget {
  final VoidCallback toggleTheme;

  BMICalculator({required this.toggleTheme});

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  double height = 170;
  double weight = 70;
  int age = 25;
  String selectedGender = 'Male';
  double? bmi;
  String resultText = "Your BMI will appear here";

  void calculateBMI() async {
    setState(() {
      bmi = weight / pow(height / 100, 2);
      if (bmi! < 18.5) {
        resultText = "Your BMI: ${bmi!.toStringAsFixed(1)} - Underweight";
      } else if (bmi! >= 18.5 && bmi! < 24.9) {
        resultText = "Your BMI: ${bmi!.toStringAsFixed(1)} - Normal weight";
      } else if (bmi! >= 25 && bmi! < 29.9) {
        resultText = "Your BMI: ${bmi!.toStringAsFixed(1)} - Overweight";
      } else {
        resultText = "Your BMI: ${bmi!.toStringAsFixed(1)} - Obesity";
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Gender',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text('Male'),
                  selected: selectedGender == 'Male',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedGender = 'Male';
                    });
                  },
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text('Female'),
                  selected: selectedGender == 'Female',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedGender = 'Female';
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Height (cm)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Slider(
              value: height,
              min: 100,
              max: 220,
              divisions: 120,
              label: height.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  height = value;
                });
              },
            ),
            Text(
              '${height.toStringAsFixed(1)} cm',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
            SizedBox(height: 20),
            Text(
              'Weight (kg)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Slider(
              value: weight,
              min: 30,
              max: 150,
              divisions: 120,
              label: weight.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  weight = value;
                });
              },
            ),
            Text(
              '${weight.toStringAsFixed(1)} kg',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
            SizedBox(height: 20),
            Text(
              'Age',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Slider(
              value: age.toDouble(),
              min: 10,
              max: 100,
              divisions: 90,
              label: age.toString(),
              onChanged: (value) {
                setState(() {
                  age = value.toInt();
                });
              },
            ),
            Text(
              '$age years',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: calculateBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Calculate BMI',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Text(
              resultText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
