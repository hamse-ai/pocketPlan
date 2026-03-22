part of 'income_bloc.dart';

abstract class IncomeEvent extends Equatable {
  const IncomeEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered on screen load to fetch/emit mock transactions.
class LoadIncomeTransactions extends IncomeEvent {
  const LoadIncomeTransactions();
}

/// Toggle the active/inactive status of a transaction.
class ToggleIncomeTransactionStatus extends IncomeEvent {
  final String id;
  final bool value;

  const ToggleIncomeTransactionStatus({required this.id, required this.value});

  @override
  List<Object?> get props => [id, value];
}

/// Add a new income transaction.
class AddIncomeTransaction extends IncomeEvent {
  final Transaction transaction;

  const AddIncomeTransaction({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

/// Load additional (paginated) transactions.
class LoadMoreIncomeTransactions extends IncomeEvent {
  const LoadMoreIncomeTransactions();
}
