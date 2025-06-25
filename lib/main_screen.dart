import 'package:flutter/material.dart';
import 'expense_provider.dart';
import 'add_expense_screen.dart';
import 'statistics_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final _pageController = PageController();

  final List<Widget> _screens = [
    const ExpenseListScreen(),
    const StatisticsScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _showAddExpenseScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddExpenseScreen(),
      ),
    );

    if (result == true && mounted) {
      // Refresh the expense list if a new expense was added
      setState(() {
        // This will trigger a rebuild of the current screen
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseScreen,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.1 * 255).toInt()),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'المصروفات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'الإحصائيات',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ExpenseProvider>().loadExpenses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مدير المصاريف'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Consumer<ExpenseProvider>(
          builder: (context, expenseProvider, _) {
            if (expenseProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final expenses = expenseProvider.expenses;
            if (expenses.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد مصاريف مضافة',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: ListTile(
                    leading: Icon(
                      _getCategoryIcon(expense.category),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          expense.category,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          expense.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(expense.date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      '${expense.amount.toStringAsFixed(2)} د.ل',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('حذف المصروف'),
                          content:
                              const Text('هل أنت متأكد من حذف هذا المصروف؟'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () {
                                expenseProvider.deleteExpense((expense.id is int
                                    ? expense.id
                                    : int.parse(expense.id.toString()))!);
                                Navigator.pop(ctx);
                              },
                              child: const Text('حذف'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'طعام':
        return Icons.restaurant;
      case 'مواصلات':
        return Icons.directions_car;
      case 'تسوق':
        return Icons.shopping_bag;
      case 'فواتير':
        return Icons.receipt;
      case 'ترفيه':
        return Icons.movie;
      case 'صحة':
        return Icons.medical_services;
      default:
        return Icons.category;
    }
  }
}
