import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_tracker_flutter/widgets/fence_button_shape.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _name = '';
  double _weight = 0.0;
  double _bmi = 0.0;
  String _bmiCategory = '';
  int _heightFeet = 0;
  int _heightInches = 0;
  String _currentPlan = 'Testing Mod'; // Example current package

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'No name';
      _weight = prefs.getDouble('weight') ?? 0.0;
      _bmi = prefs.getDouble('bmi') ?? 0.0;
      _heightFeet = (prefs.getDouble('heightFeet') ?? 0).toInt();
      _heightInches = (prefs.getDouble('heightInches') ?? 0).toInt();
      _bmiCategory = _getBMICategory(_bmi);
    });
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 24.9) return 'Normal weight';
    if (bmi < 29.9) return 'Overweight';
    return 'Obesity';
  }

  Future<void> _editUserInfo(String label) async {
    String currentValue = '';
    String title = '';
    String hintText = '';

    // Set current value, title, and hint text based on the label
    switch (label) {
      case 'Name':
        currentValue = _name;
        title = 'Edit Name';
        hintText = 'Enter your name';
        break;
      case 'Height':
        currentValue = '$_heightFeet ft $_heightInches in';
        title = 'Edit Height';
        hintText = 'Enter height as "ft in"';
        break;
      case 'Weight':
        currentValue = _weight.toString();
        title = 'Edit Weight';
        hintText = 'Enter weight in kg';
        break;
      case 'BMI':
        // BMI should not be directly edited; we will inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("BMI cannot be edited directly.")),
        );
        return;
      case 'Status':
        // Status should not be directly edited; we will inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("BMI status cannot be edited directly.")),
        );
        return;
    }

    // Show a dialog to edit the user info
    TextEditingController controller =
        TextEditingController(text: currentValue);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hintText),
            style: TextStyle(color: Colors.black), // Set text color to black
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Get the new value from the text field
                String newValue = controller.text.trim();

                // Update the Shared Preferences and local state based on the label
                final prefs = await SharedPreferences.getInstance();
                switch (label) {
                  case 'Name':
                    prefs.setString('name', newValue);
                    setState(() {
                      _name = newValue; // Update state
                    });
                    break;
                  case 'Height':
                    // Split height input by spaces or check using regex
                    RegExp heightRegExp =
                        RegExp(r'(\d+)\s*ft\s*(\d+)?\s*in|\d+\s*in|\d+');
                    Match? match = heightRegExp.firstMatch(newValue);
                    if (match != null) {
                      int feet = int.parse(match.group(1) ?? '0');
                      int inches = int.parse(match.group(2) ?? '0');
                      prefs.setDouble('heightFeet', feet.toDouble());
                      prefs.setDouble('heightInches', inches.toDouble());
                      setState(() {
                        _heightFeet = feet; // Update state
                        _heightInches = inches; // Update state
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter a valid height.")),
                      );
                    }
                    break;
                  case 'Weight':
                    double weight = double.tryParse(newValue) ?? _weight;
                    prefs.setDouble('weight', weight);
                    setState(() {
                      _weight = weight; // Update state
                    });
                    break;
                }

                // Update BMI and BMI Category
                _bmi = _calculateBMI(_heightFeet, _heightInches, _weight);
                _bmiCategory = _getBMICategory(_bmi);
                prefs.setDouble('bmi', _bmi); // Save updated BMI

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  double _calculateBMI(int feet, int inches, double weight) {
    // Convert height to meters
    double heightInMeters =
        ((feet * 12) + inches) * 0.0254; // 1 inch = 0.0254 meters
    return weight / (heightInMeters * heightInMeters); // BMI formula
  }

  void _showPlanDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Your Plan'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Basic Plan'),
                subtitle: Text('Access exercises only.'),
              ),
              ListTile(
                title: Text('Premium Plan'),
                subtitle: Text(
                  'Talk to trainer + Diet plan + Updated records + No ads.',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              const SizedBox(height: 20),
              _buildUserInfoRow('Name', _name),
              _buildUserInfoRow('Height', '$_heightFeet ft $_heightInches in'),
              _buildUserInfoRow('Weight', '${_weight.toStringAsFixed(1)} kg'),
              _buildUserInfoRow('BMI', _bmi.toStringAsFixed(2)),
              _buildUserInfoRow('Status', _bmiCategory),

              const SizedBox(height: 20),

              // Current package and plan selection button
              Text(
                'Current Package: $_currentPlan',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: _showPlanDialog,
              //   child: const Text('Choose Your Plan'),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _showPlanDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Background color
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.zero, // Remove rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20), // Adjust padding
                    ),
                    child: const Text(
                      'Choose Your Plan',
                      style: TextStyle(
                        color: Colors.black, // Text color
                        fontSize: 18, // Font size
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              _buildAds(),
              const Divider(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.height * 0.055,
        backgroundColor: Colors.yellow,
        child: Image.asset(
          'assets/user_photo.png', // Path to avatar image
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.2,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label: $value',
          style: const TextStyle(fontSize: 18),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            _editUserInfo(label);
          },
        ),
      ],
    );
  }

  Widget _buildAds() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Image.asset("assets/settings.png"),
      ),
    );
  }

  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Made with love by Hami ❤️',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
