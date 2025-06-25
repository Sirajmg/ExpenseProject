import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [
        start.toIso8601String(),
        end.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> getExpensesByCategory(DateTime start, DateTime end) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT category, SUM(amount) as total
      FROM expenses
      WHERE date BETWEEN ? AND ?
      GROUP BY category
      ORDER BY total DESC
    ''', [
      start.toIso8601String(),
      end.toIso8601String(),
    ]);
  }

  Future<double> getTotalExpenses(DateTime start, DateTime end) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM expenses
      WHERE date BETWEEN ? AND ?
    ''', [
      start.toIso8601String(),
      end.toIso8601String(),
    ]);

    return result.first['total'] as double? ?? 0.0;
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
} 