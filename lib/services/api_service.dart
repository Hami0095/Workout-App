import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:health_tracker_flutter/models/exercise.dart';

class ApiService {
  final String baseUrl = 'http://192.168.100.90:8000/api/exercises/';

  Future<List<Exercise>> fetchExercises() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((exercise) => Exercise.fromJson(exercise)).toList();
      } else {
        throw Exception(
            'Failed to load exercises: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load exercises: $e');
    }
  }
}
