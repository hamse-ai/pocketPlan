import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isActive;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.isActive = true,
  });

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    bool? isActive,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, title, amount, date, isActive];
}
