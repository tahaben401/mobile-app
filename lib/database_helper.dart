import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import './models/event.dart';
import './models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static int _currentVersion = 2;  // Changed from 1 to 2

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: _currentVersion,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Create events table with correct field name
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        description TEXT,
        userId INTEGER NOT NULL
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      try {
        await _migrateToNewSchema(db);
      } catch (e) {
        print('Migration error: $e');
      }
    }
  }

  Future<void> _migrateToNewSchema(Database db) async {
    try {
      await db.execute('''
        ALTER TABLE events ADD COLUMN description TEXT
      ''');
    } catch (e) {
      print('Migration error: $e');
    }
  }

  // User operations
  Future<int> createUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
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
    );
    return result.map((map) => Event.fromMap(map)).toList();
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}