// models/exercise.dart
import 'dart:convert';
import 'package:flutter/services.dart';

class Exercise {
  final String id;
  final String name;
  final String? force;
  final String level;
  final String? mechanic;
  final String? equipment;
  final List<String?> primaryMuscles;
  final List<String?> secondaryMuscles;
  final List<String> instructions;
  final String? category;
  final List<String> images;

  Exercise({
    required this.id,
    required this.name,
    required this.force,
    required this.level,
    required this.mechanic,
    required this.equipment,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.instructions,
    required this.category,
    required this.images,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      force: json['force'],
      level: json['level'],
      mechanic: json['mechanic'],
      equipment: json['equipment'],
      primaryMuscles: List<String>.from(json['primaryMuscles']),
      secondaryMuscles: List<String>.from(json['secondaryMuscles']),
      instructions: List<String>.from(json['instructions']),
      category: json['category'],
      images: List<String>.from(json['images']),
    );
  }

  static Future<List<Exercise>> loadAllExercises() async {
    final String response =
        await rootBundle.loadString('assets/exercises.json');
    final List<dynamic> data = await json.decode(response);
    return data.map((json) => Exercise.fromJson(json)).toList();
  }
}
