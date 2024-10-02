import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_tracker_flutter/models/exercise.dart';
import 'package:health_tracker_flutter/services/exercise_database.dart';

// Provider for the database
final exerciseDatabaseProvider = Provider<ExerciseDatabase>((ref) {
  return ExerciseDatabase();
});

// Provider for selected exercises state management
final selectedExercisesProvider =
    StateNotifierProvider<ExerciseNotifier, List<Exercise>>((ref) {
  return ExerciseNotifier(ref);
});

class ExerciseNotifier extends StateNotifier<List<Exercise>> {
  final Ref _ref;

  ExerciseNotifier(this._ref) : super([]);

  Future<void> loadExercises() async {
    final db = _ref.read(exerciseDatabaseProvider);
    final exercises = await db.getSelectedExercises();
    state = exercises;
  }

  Future<void> addSelectedExercise(Exercise exercise) async {
    final db = _ref.read(exerciseDatabaseProvider);
    await db.insertSelectedExercise(exercise);
    state = [...state, exercise];
  }

  Future<void> removeSelectedExercise(Exercise exercise) async {
    final db = _ref.read(exerciseDatabaseProvider);
    await db.deleteSelectedExercise(exercise.id);
    state = state.where((ex) => ex.id != exercise.id).toList();
  }
}
