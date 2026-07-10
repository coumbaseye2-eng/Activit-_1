import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modele/note.dart';
import '../modele/user.dart';
import '../modele/redactor.dart';

class DatabaseManager {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes_app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            photo_path TEXT,
            theme TEXT NOT NULL DEFAULT 'clair',
            langue TEXT NOT NULL DEFAULT 'fr'
          )
        ''');
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            contenu TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
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
        throw Exception('Cette adresse email est déjà utilisée par un autre rédacteur.');
      }
      rethrow;
    }
  }

  Future<List<Redactor>> getAllRedacteurs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('redacteurs', orderBy: 'nom ASC');
    return List.generate(maps.length, (i) => Redactor.fromMap(maps[i]));
  }

  Future<int> updateRedacteur(Redactor redacteur) async {
    if (redacteur.id == null) {
      throw ArgumentError('Impossible de modifier un rédacteur sans id.');
    }
    final db = await database;
    final Map<String, dynamic> data = redacteur.toMap();
    data.remove('id');
    return await db.update(
      'redacteurs',
      data,
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  Future<int> deleteRedacteur(int id) async {
    final db = await database;
    return await db.delete(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> insertUser(User user) async {
    try {
      final db = await database;
      return await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('Ce nom d\'utilisateur existe déjà.');
      }
      rethrow;
    }
  }

  Future<User?> getUserByCredentials(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<int> updateUser(User user) async {
    if (user.id == null) {
      throw ArgumentError('Impossible de modifier un utilisateur sans id.');
    }
    final db = await database;
    final Map<String, dynamic> data = user.toMap();
    data.remove('id');
    return await db.update(
      'users',
      data,
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('notes', orderBy: 'updated_at DESC');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<int> updateNote(Note note) async {
    if (note.id == null) {
      throw ArgumentError('Impossible de modifier une note sans id.');
    }
    final db = await database;
    final Map<String, dynamic> data = note.toMap();
    data.remove('id');
    return await db.update(
      'notes',
      data,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}