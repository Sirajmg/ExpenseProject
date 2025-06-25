import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database/sqflitedb.dart';
import 'models/expense.dart';
import 'theme/app_theme.dart';
import 'theme/app_styles.dart';
import 'theme/app_icons.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'طعام';
  bool _isLoading = false;
  final SqlDb _db = SqlDb();

  final List<String> _categories = [
    'طعام',
    'مواصلات',
    'تسوق',
    'فواتير',
    'ترفيه',
    'صحة',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final expense = Expense(
        amount: double.parse(_amountController.text),
        description: _descriptionController.text,
        category: _selectedCategory,
        date: _selectedDate,
      );

      await context.read<ExpenseProvider>().addExpense(expense);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ المصروف بنجاح'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء حفظ المصروف: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة مصروف جديد'),
        centerTitle: true,
      ),
      body: Container(
        decoration: AppStyles.gradientDecoration(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _amountController,
                            decoration: AppStyles.inputDecoration(
                              label: 'المبلغ',
                              prefixIcon: Icons.attach_money,
                              suffixText: 'د.ل',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال المبلغ';
                              }
                              if (double.tryParse(value) == null) {
                                return 'الرجاء إدخال رقم صحيح';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: AppStyles.inputDecoration(
                              label: 'الوصف',
                              prefixIcon: Icons.description,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال وصف للمصروف';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: AppStyles.inputDecoration(
                              label: 'الفئة',
                              prefixIcon: Icons.category,
                            ),
                            items: _categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Row(
                                  children: [
                                    AppIcons.categoryIcon(category),
                                    const SizedBox(width: 8),
                                    Text(category),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: AppStyles.inputDecoration(
                                label: 'التاريخ',
                                prefixIcon: Icons.calendar_today,
                              ),
                              child: Text(
                                DateFormat('yyyy/MM/dd').format(_selectedDate),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveExpense,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'إضافة المصروف',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
