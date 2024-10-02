import 'dart:convert';

import 'package:flutter/services.dart';

class Exercise {
  final String id;
  final String name;
  final String force;
  final String level;
  final String mechanic;
  final String equipment;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  final String category;
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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      force: json['force'] ?? '',
      level: json['level'] ?? '',
      mechanic: json['mechanic'] ?? '', // Handle nullable mechanic
      equipment: json['equipment'] ?? '',
      primaryMuscles: List<String>.from(json['primaryMuscles'] ?? []),
      secondaryMuscles: List<String>.from(json['secondaryMuscles'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      category: json['category'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'force': force,
      'level': level,
      'mechanic': mechanic,
      'equipment': equipment,
      'primaryMuscles': jsonEncode(primaryMuscles),
      'secondaryMuscles': jsonEncode(secondaryMuscles),
      'instructions': jsonEncode(instructions),
      'category': category,
      'images': jsonEncode(images),
    };
  }

  static Future<List<Exercise>> loadAllExercises() async {
    // Load the JSON file as a string
    final String response =
        await rootBundle.loadString('assets/exercises.json');

    // Decode the JSON string to a dynamic List
    final List<dynamic> data = json.decode(response);

    // Map the list of dynamic JSON objects into a List of Exercise objects
    return data.map((json) => Exercise.fromJson(json)).toList();
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      force: map['force'],
      level: map['level'],
      mechanic: map['mechanic'],
      equipment: map['equipment'],
      primaryMuscles: List<String>.from(jsonDecode(map['primaryMuscles'])),
      secondaryMuscles: List<String>.from(jsonDecode(map['secondaryMuscles'])),
      instructions: List<String>.from(jsonDecode(map['instructions'])),
      category: map['category'],
      images: List<String>.from(jsonDecode(map['images'])),
    );
  }
}
