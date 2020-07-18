import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:unroutine/model/sequence_model.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'sequence.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE sequences(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, startEdge TEXT, transitions TEXT, savedOn INTEGER, audioUrl TEXT, apiId INTEGER)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 3) {
          db.execute(
            "ALTER TABLE sequences ADD COLUMN audioUrl TEXT DEFAULT NULL",
          );
          db.execute(
            "ALTER TABLE sequences ADD COLUMN apiId INTEGER DEFAULT NULL",
          );
        }
      },
      version: 3,
    );
  }

  Future<void> insertSequence(SequenceModel sequence) async {
    final Database db = await database;
    await db.insert('sequences', sequence.toDatabaseMap());
  }

  Future<List<SequenceModel>> sequences() async {
    final Database db = await database;
    final List<Map<String, dynamic>> results = await db.query('sequences');
    final List<Map<String, dynamic>> maps = results
        .map((result) => {
              'name': result['name'],
              'startEdge': jsonDecode(result['startEdge']),
              'transitions': jsonDecode(result['transitions']),
              'savedOn': result['savedOn'],
            })
        .toList();

    return List.generate(maps.length, (i) {
      return SequenceModel.fromJson(maps[i]);
    });
  }
}
