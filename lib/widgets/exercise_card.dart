import 'package:flutter/material.dart';
import 'package:health_tracker_flutter/models/exercise.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final Function(bool isSelected) onSelected;

  const ExerciseCard({
    Key? key,
    required this.exercise,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(exercise.name),
        subtitle: Text(exercise.category),
        trailing: Checkbox(
          value: false, // Update this based on if the exercise is selected
          onChanged: (isSelected) {
            onSelected(isSelected ?? false);
          },
        ),
      ),
    );
  }
}
