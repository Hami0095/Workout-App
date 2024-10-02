import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_tracker_flutter/models/exercise.dart';
import 'package:health_tracker_flutter/widgets/exercise_card.dart';
import 'package:health_tracker_flutter/providers/exercise_provider.dart'; // Import your provider

class ExerciseScreen extends ConsumerWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(selectedExercisesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: exercises.isEmpty
          ? const Center(child: Text('No selected exercises'))
          : ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return ExerciseCard(
                  exercise: exercise,
                  onSelected: (isSelected) {
                    if (isSelected) {
                      ref
                          .read(selectedExercisesProvider.notifier)
                          .addSelectedExercise(exercise);
                    } else {
                      ref
                          .read(selectedExercisesProvider.notifier)
                          .removeSelectedExercise(exercise);
                    }
                  },
                );
              },
            ),
    );
  }
}
