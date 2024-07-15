import 'package:flutter/material.dart';
import 'package:health_tracker_flutter/constants.dart';
import 'package:health_tracker_flutter/providers/workout_provider.dart';
import 'package:health_tracker_flutter/screens/exercise_detail_screen.dart';
import 'package:provider/provider.dart';

class WorkoutDayScreen extends StatelessWidget {
  final WorkoutDay day;

  const WorkoutDayScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          day.name,
          style: Theme.of(context).textTheme.headline1,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showExerciseDialog(context, provider),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: day.exercises.length,
        itemBuilder: (context, index) {
          final exercise = day.exercises[index];
          return GestureDetector(
            onLongPress: () {
              provider.removeExercise(day.name, day.exercises[index]);
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ExerciseDetailScreen(exercise: exercise),
                ),
              );
            },
            child: ListTile(
              leading: Image.asset("assets/${exercise.images[0]}"),
              title: Text(exercise.name,
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
              subtitle: Text(
                'Level: ${exercise.level}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        },
      ),
    );
  }

  void showExerciseDialog(BuildContext context, WorkoutProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        final exercises = provider.allExercises.where((exercise) {
          // Get the primary muscles for the current day
          final primaryMuscles = muscleGroups[day.name] ?? [];
          return exercise.primaryMuscles
              .any((muscle) => primaryMuscles.contains(muscle));
        }).toList();

        return AlertDialog(
          title: const Text('Select Exercises'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading:
                          Image.asset("assets/${exercises[index].images[0]}"),
                      title: Text(exercises[index].name),
                      subtitle: Text(exercises[index].level),
                      onTap: () {
                        provider.addExerciseToDay(day.name, exercises[index]);
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
