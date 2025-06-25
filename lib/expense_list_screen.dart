import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database/sqflitedb.dart';
import 'models/expense.dart';
import 'theme/app_theme.dart';
import 'theme/app_styles.dart';
import 'theme/app_icons.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<Expense> _expenses = [];
  bool _isLoading = true;
  String _error = '';
  final SqlDb _db = SqlDb();

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final expenses = await _db.getExpenses();
      if (mounted) {
        setState(() {
          _expenses = expenses;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'حدث خطأ أثناء تحميل المصروفات';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteExpense(Expense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا المصروف؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _db.deleteExpense(expense.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف المصروف بنجاح'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          _loadExpenses();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('حدث خطأ أثناء حذف المصروف: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المصروفات'),
        centerTitle: true,
      ),
      body: Container(
        decoration: AppStyles.gradientDecoration(),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _error.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _error,
                          style: const TextStyle(color: AppTheme.errorColor),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadExpenses,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  )
                : _expenses.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد مصروفات',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadExpenses,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _expenses.length,
                          itemBuilder: (context, index) {
                            final expense = _expenses[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppIcons.getCategoryColor(
                                            expense.category)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child:
                                      AppIcons.categoryIcon(expense.category),
                                ),
                                title: Text(
                                  expense.description,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      expense.category,
                                      style: const TextStyle(
                                        color: AppTheme.secondaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('yyyy/MM/dd')
                                          .format(expense.date),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${expense.amount.toStringAsFixed(2)} د.ل',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: AppTheme.errorColor,
                                      ),
                                      onPressed: () => _deleteExpense(expense),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}
