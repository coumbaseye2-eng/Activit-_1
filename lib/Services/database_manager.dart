import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modele/redactor.dart';

class DatabaseManager {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'redactors_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE redacteurs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            prenom TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {},
    );
  }

  Future<int> insertRedacteur(Redactor redacteur) async {
    try {
      final db = await database;
      return await db.insert(
        'redacteurs',
        redacteur.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('Un rédacteur avec cet email existe déjà.');
      }
      rethrow;
    }
  }

  Future<List<Redactor>> getAllRedacteurs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('redacteurs', orderBy: 'nom ASC');
    return List.generate(maps.length, (i) => Redactor.fromMap(maps[i]));
  }

  Future<Redactor?> getRedacteurById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Redactor.fromMap(maps.first);
  }

  Future<int> updateRedacteur(Redactor redacteur) async {
    if (redacteur.id == null) {
      throw ArgumentError('Impossible de modifier un rédacteur sans id.');
    }
    try {
      final db = await database;
      final Map<String, dynamic> data = redacteur.toMap();
      data.remove('id');

      return await db.update(
        'redacteurs',
        data,
        where: 'id = ?',
        whereArgs: [redacteur.id],
      );
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('Un rédacteur avec cet email existe déjà.');
      }
      rethrow;
    }
  }

  Future<int> deleteRedacteur(int id) async {
    final db = await database;
    return await db.delete(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}