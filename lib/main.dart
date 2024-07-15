import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/workout_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WorkoutProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Planner',
      theme: ThemeData(
        // primaryColorDark: const Color(0xFF1E1E2F), // Dark navy blue
        primaryColorLight: const Color.fromARGB(255, 0, 236, 0),
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          // ignore: deprecated_member_use
          headline1: GoogleFonts.righteous(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 236, 0),
          ),
          headlineLarge: GoogleFonts.righteous(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          // ignore: deprecated_member_use
          bodyText1: GoogleFonts.righteous(fontSize: 16, color: Colors.white),
          // ignore: deprecated_member_use
          bodyText2: GoogleFonts.righteous(fontSize: 14, color: Colors.white),
        ),
        dividerColor: const Color.fromARGB(255, 0, 236, 0), // Bright yellow
        appBarTheme: AppBarTheme(
          color: Colors.black,
          titleTextStyle: GoogleFonts.righteous(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color.fromARGB(255, 0, 236, 0), // Bright yellow
          textTheme: ButtonTextTheme.primary,
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 0, 236, 0), // Bright yellow
        ),
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            iconColor: MaterialStatePropertyAll(
              Color.fromARGB(255, 0, 236, 0), // Bright yellow
            ),
          ),
        ),
        dialogBackgroundColor:
            const Color.fromARGB(255, 253, 253, 253), // Bright green
        cardColor: Color.fromARGB(255, 39, 53, 54),
      ),
      home: HomeScreen(),
    );
  }
}
