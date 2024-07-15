import 'package:flutter/material.dart';
import 'package:health_tracker_flutter/models/exercise.dart';

class WorkoutProvider with ChangeNotifier {
  final List<WorkoutDay> _workoutDays = [
    WorkoutDay(name: 'Leg Day', exercises: []),
    WorkoutDay(name: 'Back Day', exercises: []),
    WorkoutDay(name: 'Shoulder Day', exercises: []),
    WorkoutDay(name: 'Abs Day', exercises: []),
    WorkoutDay(name: 'Chest Day', exercises: []),
    WorkoutDay(name: 'Arms Day', exercises: []),
  ];

  List<Exercise> _allExercises = [];

  List<WorkoutDay> get workoutDays => _workoutDays;

  List<Exercise> get allExercises => _allExercises;

  Future<void> loadAllExercises() async {
    _allExercises = await Exercise.loadAllExercises();
    print("EXERCISES LOADED");
    notifyListeners();
  }

  void addExerciseToDay(String dayName, Exercise exercise) {
    final day = _workoutDays.firstWhere((d) => d.name == dayName);
    if (!day.exercises.contains(exercise)) {
      day.exercises.add(exercise);
      notifyListeners();
    }
  }

  void removeExercise(String dayName, Exercise exercise) {
    final day = _workoutDays.firstWhere((element) => element.name == dayName);
    if (day.exercises.contains(exercise)) {
      day.exercises.remove(exercise);
      notifyListeners();
    }
  }
}

class WorkoutDay {
  final String name;
  final List<Exercise> exercises;

  WorkoutDay({required this.name, required this.exercises});
}
