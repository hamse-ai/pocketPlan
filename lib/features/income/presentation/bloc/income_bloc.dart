import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_plan/features/income/domain/entities/transaction.dart';
import 'package:pocket_plan/features/income/domain/usecases/transaction_usecases.dart';

part 'income_event.dart';
part 'income_state.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  final GetTransactions getTransactions;
  final AddTransaction addTransactionUseCase;
  final ToggleTransactionStatus toggleTransactionStatusUseCase;
  StreamSubscription? _transactionsSubscription;

  IncomeBloc({
    required this.getTransactions,
    required this.addTransactionUseCase,
    required this.toggleTransactionStatusUseCase,
  }) : super(const IncomeInitial()) {
    on<LoadIncomeTransactions>(_onLoad);
    on<ToggleIncomeTransactionStatus>(_onToggle);
    on<AddIncomeTransaction>(_onAdd);
    on<LoadMoreIncomeTransactions>(_onLoadMore);
    on<_TransactionsUpdated>(_onTransactionsUpdated);
  }

  void _onTransactionsUpdated(
    _TransactionsUpdated event,
    Emitter<IncomeState> emit,
  ) {
    emit(IncomeLoaded(transactions: event.transactions));
  }

  void _onLoad(
    LoadIncomeTransactions event,
    Emitter<IncomeState> emit,
  ) {
    emit(const IncomeLoading());
    _transactionsSubscription?.cancel();
    _transactionsSubscription = getTransactions('income').listen(
      (transactions) {
        add(_TransactionsUpdated(transactions: transactions));
      },
      onError: (error) {
        // Emit error state if needed
      },
    );
  }

  void _onToggle(
    ToggleIncomeTransactionStatus event,
    Emitter<IncomeState> emit,
  ) async {
    try {
      await toggleTransactionStatusUseCase('income', event.id, event.value);
    } catch (e) {
      // Handle error
    }
  }

  void _onAdd(
    AddIncomeTransaction event,
    Emitter<IncomeState> emit,
  ) async {
    try {
      await addTransactionUseCase('income', event.transaction);
    } catch (e) {
      // Handle error
    }
  }

  void _onLoadMore(
    LoadMoreIncomeTransactions event,
    Emitter<IncomeState> emit,
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
class _TransactionsUpdated extends IncomeEvent {
  final List<Transaction> transactions;

  const _TransactionsUpdated({required this.transactions});

  @override
  List<Object> get props => [transactions];
}
