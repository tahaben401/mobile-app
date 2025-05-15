import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import './models/event.dart';
import './models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const int _currentVersion = 7;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('eventsG.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: _currentVersion,
      onCreate: _createDB,
      //onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // Create events table
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        description TEXT NOT NULL,
        userId INTEGER NOT NULL
      )
    ''');
  }

  // Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //
  //     // Migration from version 1 to 2
  //     await db.execute('ALTER TABLE events ADD COLUMN dateTime TEXT');
  //
  //   // Add more version migrations here as needed
  // }

  // User operations
  Future<int> createUser(User user) async {
    final db = await instance.database;
    try {
      return await db.insert('users', user.toMap());
    } catch (e) {
      if (e is DatabaseException && e.isUniqueConstraintError()) {
        throw Exception('Email already exists');
      }
      rethrow;
    }
  }

  Future<User?> getUser(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  // Event operations
  Future<int> addEvent(Event event) async {
    final db = await instance.database;
    return await db.insert('events', event.toMap());
  }

  Future<List<Event>> getEvents(int userId) async {
    final db = await instance.database;
    final result = await db.query(
      'events',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'dateTime ASC',
    );
    return result.map((map) => Event.fromMap(map)).toList();
  }

  Future<int> updateEvent(Event event) async {
    final db = await instance.database;
    return await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEvent(int id) async {
    final db = await instance.database;
    return await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}