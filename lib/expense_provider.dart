import 'package:flutter/foundation.dart';
import 'models/expense.dart';
import 'database/database_helper.dart';

class ExpenseProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _error;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadExpenses() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final expenses = await _dbHelper.getExpenses();
      _expenses = expenses;
      if (_expenses.isEmpty) {
        _error = 'لا توجد مصاريف مسجلة.';
      }
    } catch (e) {
      _error = 'فشل في تحميل المصاريف: ${e.toString()}';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense(Expense expense) async {
    _error = null;
    try {
      await _dbHelper.insertExpense(expense);
      await loadExpenses(); // إعادة تحميل جميع المصاريف بعد الإضافة
    } catch (e) {
      _error = 'فشل في إضافة المصروف: ${e.toString()}';
      debugPrint(_error);
      rethrow;
    }
  }

  Future<void> updateExpense(Expense expense) async {
    _error = null;
    try {
      await _dbHelper.updateExpense(expense);
      await loadExpenses(); // إعادة تحميل جميع المصاريف بعد التحديث
    } catch (e) {
      _error = 'فشل في تحديث المصروف: ${e.toString()}';
      debugPrint(_error);
      rethrow;
    }
  }

  Future<void> deleteExpense(int id) async {
    _error = null;
    try {
      await _dbHelper.deleteExpense(id);
      await loadExpenses(); // إعادة تحميل جميع المصاريف بعد الحذف
    } catch (e) {
      _error = 'فشل في حذف المصروف: ${e.toString()}';
      debugPrint(_error);
      rethrow;
    }
  }

  Future<List<Expense>> getExpensesByDateRange(
      DateTime start, DateTime end) async {
    try {
      final expenses = await _dbHelper.getExpensesByDateRange(start, end);
      return expenses;
    } catch (e) {
      _error = 'فشل في الحصول على المصاريف حسب النطاق الزمني: ${e.toString()}';
      debugPrint(_error);
      return [];
    }
  }

  Future<double> getTotalExpensesByDateRange(
      DateTime start, DateTime end) async {
    try {
      return await _dbHelper.getTotalExpenses(start, end);
    } catch (e) {
      _error = 'فشل في الحصول على إجمالي المصاريف: ${e.toString()}';
      debugPrint(_error);
      return 0.0;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
