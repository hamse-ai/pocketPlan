part of 'expense_bloc.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpenseTransactions extends ExpenseEvent {
  const LoadExpenseTransactions();
}

class ToggleExpenseTransactionStatus extends ExpenseEvent {
  final String id;
  final bool value;

  const ToggleExpenseTransactionStatus({required this.id, required this.value});

  @override
  List<Object?> get props => [id, value];
}

class AddExpenseTransaction extends ExpenseEvent {
  final Transaction transaction;

  const AddExpenseTransaction({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class UpdateExpenseTransaction extends ExpenseEvent {
  final Transaction transaction;

  const UpdateExpenseTransaction({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class DeleteExpenseTransaction extends ExpenseEvent {
  final String id;

  const DeleteExpenseTransaction({required this.id});

  @override
  List<Object?> get props => [id];
}

class LoadMoreExpenseTransactions extends ExpenseEvent {
  const LoadMoreExpenseTransactions();
}
