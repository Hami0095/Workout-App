import 'package:flutter/material.dart';
import 'package:health_tracker_flutter/models/exercise.dart';
import 'package:health_tracker_flutter/services/api_service.dart';
import 'package:health_tracker_flutter/widgets/exercise_card.dart';

class ExerciseScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: FutureBuilder<List<Exercise>>(
        future: apiService.fetchExercises(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No exercises found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ExerciseCard(exercise: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
