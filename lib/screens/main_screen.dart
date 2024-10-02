import 'package:flutter/material.dart';
import 'package:health_tracker_flutter/screens/chat_bot_screen.dart';
import 'package:health_tracker_flutter/screens/settings_screen.dart';
import 'home_screen.dart'; // Import your existing HomeScreen
// Assuming you will create ChatBotScreen and SettingsScreen similarly.

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Track the currently selected tab
  final PageController _pageController =
      PageController(); // For swipe navigation

  // Define the screens here
  final List<Widget> _screens = [
    HomeScreen(), // Your existing HomeScreen
    ChatScreen(), // You will create this screen
    SettingsScreen(), // You will create this screen
  ];

  // Handle the bottom navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'ChatBot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
