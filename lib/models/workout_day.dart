// models/workout_day.dart
import 'package:flutter/foundation.dart';
import 'exercise.dart';

class WorkoutDay with ChangeNotifier {
  final String name;
  List<Exercise> exercises;

  WorkoutDay({required this.name, this.exercises = const []});

  void addExercise(Exercise exercise) {
    exercises.add(exercise);
    notifyListeners();
  }

  void removeExercise(Exercise exercise) {
    exercises.remove(exercise);
    notifyListeners();
  }
}
