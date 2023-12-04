import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'grade.dart';

class GradesModel {
  late Database _database;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'grades_database.db'),
      onCreate: (db, version) => db.execute(
          "CREATE TABLE grades(id INTEGER PRIMARY KEY, sid TEXT, grade TEXT)"),
      version: 1,
    );
  }

  Future<List<Grade>> getAllGrades() async {
    final List<Map<String, dynamic>> maps = await _database.query('grades');
    return List.generate(maps.length, (i) => Grade.fromMap(maps[i]));
  }

  Future<int> insertGrade(Grade grade) async =>
      await _database.insert('grades', grade.toMap());

  Future<void> updateGrade(Grade grade) async {
    await _database.update(
      'grades',
      grade.toMap(),
      where: "id = ?",
      whereArgs: [grade.id],
    );
  }

  Future<void> deleteGradeById(int id) async {
    await _database.delete(
      'grades',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
