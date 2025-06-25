import 'package:uuid/uuid.dart';

class Expense {
  final String id;
  final String title1;
  final double amount;
  final DateTime date;
  final String category;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Expense({
    String? id,
    required this.title1,
    required this.amount,
    required this.date,
    required this.category,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now() {
    _validate();
  }

  void _validate() {
    if (title1.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    if (amount <= 0) {
      throw ArgumentError('Amount must be greater than 0');
    }
    if (category.trim().isEmpty) {
      throw ArgumentError('Category cannot be empty');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title1': title1,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      title1: map['title1'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      category: map['category'] as String,
      description: map['description'] as String?,
      createdAt: map['created_at'] != null && map['created_at'] != ''
          ? DateTime.tryParse(map['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updated_at'] != null && map['updated_at'] != ''
          ? DateTime.tryParse(map['updated_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Expense copyWith({
    String? id,
    String? title1,
    double? amount,
    DateTime? date,
    String? category,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title1: title1 ?? this.title1,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Expense &&
        other.id == id &&
        other.title1 == title1 &&
        other.amount == amount &&
        other.date == date &&
        other.category == category &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title1,
      amount,
      date,
      category,
      description,
      createdAt,
      updatedAt,
    );
  }
}
