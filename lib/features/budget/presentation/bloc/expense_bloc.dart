import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_plan/features/income/domain/entities/transaction.dart';
import 'package:pocket_plan/features/income/domain/usecases/transaction_usecases.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetTransactions getTransactions;
  final AddTransaction addTransactionUseCase;
  final ToggleTransactionStatus toggleTransactionStatusUseCase;
  StreamSubscription? _transactionsSubscription;

  ExpenseBloc({
    required this.getTransactions,
    required this.addTransactionUseCase,
    required this.toggleTransactionStatusUseCase,
  }) : super(const ExpenseInitial()) {
    on<LoadExpenseTransactions>(_onLoad);
    on<ToggleExpenseTransactionStatus>(_onToggle);
    on<AddExpenseTransaction>(_onAdd);
    on<LoadMoreExpenseTransactions>(_onLoadMore);
    on<_TransactionsUpdated>(_onTransactionsUpdated);
  }

  void _onTransactionsUpdated(
    _TransactionsUpdated event,
    Emitter<ExpenseState> emit,
  ) {
    emit(ExpenseLoaded(transactions: event.transactions));
  }

  void _onLoad(
    LoadExpenseTransactions event,
    Emitter<ExpenseState> emit,
  ) {
    emit(const ExpenseLoading());
    _transactionsSubscription?.cancel();
    _transactionsSubscription = getTransactions('expense').listen(
      (transactions) {
        add(_TransactionsUpdated(transactions: transactions));
      },
      onError: (error) {
        // Handle error if needed
      },
    );
  }

  void _onToggle(
    ToggleExpenseTransactionStatus event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await toggleTransactionStatusUseCase('expense', event.id, event.value);
    } catch (e) {
      // Handle error
    }
  }

  void _onAdd(
    AddExpenseTransaction event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await addTransactionUseCase('expense', event.transaction);
    } catch (e) {
      // Handle error
    }
  }

  void _onLoadMore(
    LoadMoreExpenseTransactions event,
    Emitter<ExpenseState> emit,
  ) {
    // Pagination logic later
  }

  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    return super.close();
  }
}

// Private event for updating transactions from stream
class _TransactionsUpdated extends ExpenseEvent {
  final List<Transaction> transactions;

  const _TransactionsUpdated({required this.transactions});

  @override
  List<Object> get props => [transactions];
}
