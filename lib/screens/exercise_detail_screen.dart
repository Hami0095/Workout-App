import 'package:flutter/material.dart';
import 'package:health_tracker_flutter/models/exercise.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  int currentImageIndex = 0;

  void _swapImage() {
    setState(() {
      currentImageIndex =
          (currentImageIndex + 1) % widget.exercise.images.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: deprecated_member_use
        title: Text(
          widget.exercise.name,
          style: Theme.of(context).textTheme.headline1,
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image that swaps on tap
            GestureDetector(
              onTap: _swapImage,
              child: SizedBox(
                height: 300, // Set a fixed height for the image
                child: Image.asset(
                    "assets/${widget.exercise.images[currentImageIndex]}"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.exercise.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 0, 236, 0),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: Text(
                'Level: ${widget.exercise.level} ${_getLevelIcon(widget.exercise.level)}',
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Instructions:', style: TextStyle(fontSize: 18)),
            ),
            for (var instruction in widget.exercise.instructions)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(instruction),
              ),
          ],
        ),
      ),
    );
  }

  String _getLevelIcon(String level) {
    switch (level) {
      case 'beginner':
        return '⭐';
      case 'intermediate':
        return '🔥';
      case 'expert':
        return '💪';
      default:
        return '';
    }
  }
}
