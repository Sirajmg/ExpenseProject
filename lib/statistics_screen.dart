import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database/sqflitedb.dart';
import 'theme/app_theme.dart';
import 'theme/app_styles.dart';
import 'theme/app_icons.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final SqlDb _db = SqlDb();
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _isLoading = true;
  String _error = '';
  double _totalExpenses = 0;
  List<Map<String, dynamic>> _expensesByCategory = [];

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final total = await _db.getTotalExpenses();
      final byCategoryMap = await _db.getExpensesByCategory();

      final byCategory = byCategoryMap.entries
          .map((entry) => {'category': entry.key, 'total': entry.value})
          .toList();

      if (mounted) {
        setState(() {
          _totalExpenses = total;
          _expensesByCategory = byCategory;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'حدث خطأ أثناء تحميل الإحصائيات';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _startDate,
        end: _endDate,
      ),
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

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadStatistics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإحصائيات'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => _selectDateRange(context),
          ),
        ],
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
                          onPressed: _loadStatistics,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'إجمالي المصروفات',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${_totalExpenses.toStringAsFixed(2)} د.ل',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'من ${DateFormat('yyyy/MM/dd').format(_startDate)} إلى ${DateFormat('yyyy/MM/dd').format(_endDate)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'المصروفات حسب الفئة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._expensesByCategory.map((category) {
                          final percentage = _totalExpenses > 0
                              ? (category['total'] as double) / _totalExpenses
                              : 0.0;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppIcons.getCategoryColor(
                                                  category['category']
                                                      as String)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: AppIcons.categoryIcon(
                                            category['category'] as String),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              category['category'] as String,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${(category['total'] as double).toStringAsFixed(2)} د.ل',
                                              style: const TextStyle(
                                                color: AppTheme.secondaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${(percentage * 100).toStringAsFixed(1)}%',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: percentage,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppIcons.getCategoryColor(
                                            category['category'] as String),
                                      ),
                                      minHeight: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
      ),
    );
  }
}
