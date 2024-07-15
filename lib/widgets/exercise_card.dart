import 'package:flutter/material.dart';
import 'package:health_tracker_flutter/models/exercise.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;

  const ExerciseCard({Key? key, required this.exercise}) : super(key: key);

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.exercise.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Force: ${widget.exercise.force}'),
            Text('Level: ${widget.exercise.level}'),
            Text('Mechanic: ${widget.exercise.mechanic}'),
            Text('Equipment: ${widget.exercise.equipment}'),
            Text(
                'Primary Muscles: ${widget.exercise.primaryMuscles.join(', ')}'),
            Text(
                'Secondary Muscles: ${widget.exercise.secondaryMuscles.join(', ')}'),
            ...widget.exercise.instructions
                .map((instruction) => Text(instruction)),
            const SizedBox(height: 10),
            GestureDetector(
                onTap: () {
                  setState(() {
                    currentImageIndex =
                        (currentImageIndex + 1) % widget.exercise.images.length;
                  });
                },
                child: Image.asset(
                  'assets/${widget.exercise.images[currentImageIndex]}',
                  height: 200, // Adjust height as needed
                  fit: BoxFit.cover,
                )),
          ],
        ),
      ),
    );
  }
}
