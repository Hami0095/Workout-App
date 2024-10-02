import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/exercise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseDatabaseProvider = Provider<ExerciseDatabase>((ref) {
  return ExerciseDatabase();
});

class ExerciseDatabase {
  Database? _database;

  // Initialize database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Insert selected exercise
  Future<void> insertSelectedExercise(Exercise exercise) async {
    final db = await database;
    await db.insert(
      'selected_exercises',
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all selected exercises
  Future<List<Exercise>> getSelectedExercises() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('selected_exercises');

    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }

  // Delete a selected exercise
  Future<void> deleteSelectedExercise(String id) async {
    final db = await database;
    await db.delete(
      'selected_exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'exercise.db');

    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE exercises (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  // Insert exercise
  Future<void> insertExercise(Exercise exercise) async {
    final db = await database;
    await db.insert(
      'exercises',
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all exercises
  Future<List<Exercise>> getExercises() async {
    final db = await database;
    final result = await db.query('exercises');
    return List.generate(result.length, (i) {
      return Exercise.fromMap(result[i]);
    });
  }

  // Delete an exercise by ID
  Future<void> deleteExercise(int id) async {
    final db = await database;
    await db.delete('exercises', where: 'id = ?', whereArgs: [id]);
  }
}
