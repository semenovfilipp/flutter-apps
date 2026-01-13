import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE tasks (
        id $idType,
        title $textType,
        description TEXT,
        isCompleted $intType,
        priority $intType,
        createdAt $textType,
        completedAt TEXT
      )
    ''');
  }

  Future<Task> createTask(Task task) async {
    final db = await database;
    final id = await db.insert('tasks', task.toMap());
    return task.copyWith(id: id);
  }

  Future<Task?> readTask(int id) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      columns: [
        'id',
        'title',
        'description',
        'isCompleted',
        'priority',
        'createdAt',
        'completedAt'
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Task>> readAllTasks() async {
    final db = await database;
    const orderBy = 'createdAt DESC';
    final result = await db.query('tasks', orderBy: orderBy);
    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<List<Task>> readActiveTasks() async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [0],
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<List<Task>> readCompletedTasks() async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [1],
      orderBy: 'completedAt DESC',
    );
    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, int>> getStatistics() async {
    final db = await database;

    final totalResult = await db.rawQuery('SELECT COUNT(*) as count FROM tasks');
    final total = Sqflite.firstIntValue(totalResult) ?? 0;

    final completedResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE isCompleted = 1'
    );
    final completed = Sqflite.firstIntValue(completedResult) ?? 0;

    final activeResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE isCompleted = 0'
    );
    final active = Sqflite.firstIntValue(activeResult) ?? 0;

    final highPriorityResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE priority = 2 AND isCompleted = 0'
    );
    final highPriority = Sqflite.firstIntValue(highPriorityResult) ?? 0;

    return {
      'total': total,
      'completed': completed,
      'active': active,
      'highPriority': highPriority,
    };
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
