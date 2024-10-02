import 'dart:async'; // Import for Timer

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_tracker_flutter/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalDataScreenState createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightFeetController = TextEditingController();
  final TextEditingController _heightInchesController = TextEditingController();
  final TextEditingController _intakeController = TextEditingController();
  String _gymLevel = 'Beginner'; // Default gym level
  double? _bmi;
  String _bmiCategory = '';

  void _showBmiDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your BMI'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your BMI: ${_bmi!.toStringAsFixed(2)}',
                style: GoogleFonts.righteous(color: Colors.black),
              ),
              Text(
                'BMI Category: $_bmiCategory',
                style: GoogleFonts.righteous(color: Colors.black),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MainScreen(), // Navigate to MainScreen
                ));
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );

    // Close the dialog automatically after 1 second
    Timer(const Duration(seconds: 1), () {
      Navigator.of(context).pop(); // Close dialog
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MainScreen(), // Navigate to MainScreen
      ));
    });
  }

  void _calculateBMI() {
    final weight = double.tryParse(_weightController.text);
    final feet = int.tryParse(_heightFeetController.text);
    final inches = int.tryParse(_heightInchesController.text);

    if (weight != null && feet != null && inches != null) {
      final heightInMeters = (feet * 0.3048) + (inches * 0.0254);
      setState(() {
        _bmi = weight / (heightInMeters * heightInMeters);
        _bmiCategory = _getBMICategory(_bmi!);
      });
    }
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 24.9) return 'Normal weight';
    if (bmi < 29.9) return 'Overweight';
    return 'Obesity';
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setDouble(
        'weight', double.tryParse(_weightController.text) ?? 0);
    await prefs.setString('gym_level', _gymLevel);
    await prefs.setDouble('bmi', _bmi ?? 0);
    await prefs.setDouble(
        'daily_intake', double.tryParse(_intakeController.text) ?? 0);
    Navigator.pop(context); // Navigate back after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Data')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputCard(
              label: 'Name',
              controller: _nameController,
              hintText: 'Enter your name',
              color: const Color.fromARGB(255, 60, 87, 255),
            ),
            const SizedBox(height: 16), // Increased space between cards
            _buildInputCard(
              label: 'Weight (Kg)',
              controller: _weightController,
              hintText: 'Enter your weight',
              isNumeric: true,
              color: const Color.fromARGB(255, 255, 158, 0),
            ),
            const SizedBox(height: 16), // Increased space between cards
            Row(
              children: [
                Expanded(
                  child: _buildInputCard(
                    label: 'Height (Feet)',
                    controller: _heightFeetController,
                    hintText: 'Feet',
                    isNumeric: true,
                    color: const Color.fromARGB(255, 0, 189, 255),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInputCard(
                    label: 'Height (Inches)',
                    controller: _heightInchesController,
                    hintText: 'Inches',
                    isNumeric: true,
                    color: const Color.fromARGB(255, 255, 61, 0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Increased space between cards
            _buildInputCard(
              label: 'Daily Intake (Kilo Calories)',
              controller: _intakeController,
              hintText: 'Enter your daily intake',
              isNumeric: true,
              color: const Color.fromARGB(255, 0, 255, 126),
            ),
            const SizedBox(height: 16), // Increased space between cards
            _buildGymLevelDropdown(),
            const SizedBox(height: 16),
            _buildSubmitButton(), // Updated button with cone effect
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool isNumeric = false,
    required Color color,
  }) {
    return ClipPath(
      clipper: SquareShapeClipper(), // Updated clipper for less corny design
      child: Container(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(5), // Less rounded corners
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType:
                    isNumeric ? TextInputType.number : TextInputType.text,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGymLevelDropdown() {
    return ClipPath(
      clipper: SquareShapeClipper(), // Updated clipper for less corny design
      child: Container(
        color: const Color.fromARGB(255, 195, 0, 255),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Expanded(
                child: Text('Gym Level:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              DropdownButton<String>(
                value: _gymLevel,
                items: <String>['Beginner', 'Novice', 'Intermediate', 'Expert']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.righteous(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _gymLevel = newValue!;
                  });
                },
                underline: const SizedBox(), // Remove underline
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Cone shape on the left side
        Positioned(
          left: 0,
          child: ClipPath(
            clipper: ConeShapeClipper(), // Custom clipper for cone effect
            child: Container(
              color: const Color.fromARGB(255, 255, 100, 0), // Color for cone
              height: 60, // Match the button height
              width: 30, // Width of the cone
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _calculateBMI(); // Calculate BMI
            _saveData(); // Save user data

            // Show BMI dialog after calculating and saving data
            if (_bmi != null) {
              _showBmiDialog(); // Call the dialog function
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color.fromARGB(255, 255, 255, 255), // Button color
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
                topLeft: Radius.circular(0),
                bottomLeft: Radius.circular(0),
              ), // Sharp left side
            ),
            minimumSize: const Size(200, 60), // Size for the button
          ),
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

class SquareShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRect(Rect.fromLTRB(0, 0, size.width, size.height)); // Square shape
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ConeShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(0, 0);
    path.close(); // Create a triangle
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
