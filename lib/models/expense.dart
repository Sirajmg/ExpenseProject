class Expense {
  final int? id;
  final double amount;
  final String description;
  final String category;
  final DateTime date;

  Expense({
    this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int,
      amount: map['amount'] as double,
      description: map['description'] as String,
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  Expense copyWith({
    int? id,
    double? amount,
    String? description,
    String? category,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
} 