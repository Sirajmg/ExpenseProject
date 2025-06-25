import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer' as developer;
import '../models/expense.dart';

class SqlDb {
  static Database? _db;
  static final SqlDb _instance = SqlDb._internal();
  factory SqlDb() => _instance;
  SqlDb._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'expenses.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldversion, int newversion) async {
    developer.log("onUpgrade =====================================");
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        description TEXT,
        isAlert INTEGER NOT NULL DEFAULT 0
      )
    ''');
    developer.log("onCreate =====================================");
  }

  Future<int> insertExpense(Expense expense) async {
    Database db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
  }

  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
  }

  Future<double> getTotalExpenses() async {
    Database db = await database;
    final result = await db.rawQuery('SELECT SUM(amount) as total FROM expenses');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<double> getTotalExpensesByDateRange(DateTime start, DateTime end) async {
    Database db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE date BETWEEN ? AND ?',
      [start.toIso8601String(), end.toIso8601String()],
    );
    return result.first['total'] as double? ?? 0.0;
  }

  Future<Map<String, double>> getExpensesByCategory() async {
    Database db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT category, SUM(amount) as total FROM expenses GROUP BY category',
    );
    return Map.fromEntries(
      result.map((e) => MapEntry(e['category'] as String, e['total'] as double)),
    );
  }

  Future<int> updateExpense(Expense expense) async {
    Database db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    Database db = await database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> removeDatabase() async {
    String path = join(await getDatabasesPath(), 'expenses.db');
    await databaseFactory.deleteDatabase(path);
  }

  Future<void> close() async {
    Database db = await database;
    await db.close();
  }
}
