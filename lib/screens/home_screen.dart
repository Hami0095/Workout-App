import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:health_tracker_flutter/providers/workout_provider.dart';
import 'package:health_tracker_flutter/screens/workout_day_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    await provider.loadAllExercises();
  }

  @override
  Widget build(BuildContext context) {
    final workoutDays = context.watch<WorkoutProvider>().workoutDays;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout Planner',
          style: GoogleFonts.lobster(
            textStyle: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            repeatPattern: QuiltedGridRepeatPattern.inverted,
            pattern: const [
              QuiltedGridTile(2, 2),
              QuiltedGridTile(2, 2),
              QuiltedGridTile(2, 4),
              QuiltedGridTile(1, 2),
              QuiltedGridTile(1, 2),
              QuiltedGridTile(1, 4),
            ],
          ),
          itemCount: workoutDays.length,
          itemBuilder: (context, index) {
            final day = workoutDays[index];
            final imageName = _getImageName(day.name);

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutDayScreen(day: day),
                ),
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/$imageName',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        // borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          day.name,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getImageName(String dayName) {
    switch (dayName.toLowerCase()) {
      case 'shoulder day':
        return 'shoulder day.jfif';
      case 'arms day':
        return 'arms day.jfif';
      case 'back day':
        return 'back day.jfif';
      case 'chest day':
        return 'chest day.jfif';
      case 'leg day':
        return 'leg day.jfif';
      case 'abs day':
        return 'abs day.jpg';
      default:
        return 'default.jpg';
    }
  }
}
