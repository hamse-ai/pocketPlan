import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_plan/features/income/domain/entities/transaction.dart';

part 'expense_event.dart';
part 'expense_state.dart';

/// Mock expense data reflecting typical Rwandan cost-of-living patterns.
final List<Transaction> _mockExpenseTransactions = [
  Transaction(
    id: 'exp_001',
    title: 'Monthly Rent',
    amount: 120000,
    date: DateTime(2026, 3, 1),
    isActive: true,
  ),
  Transaction(
    id: 'exp_002',
    title: 'Grocery Shopping',
    amount: 35000,
    date: DateTime(2026, 3, 5),
    isActive: true,
  ),
  Transaction(
    id: 'exp_003',
    title: 'Transport (Moto/Bus)',
    amount: 15000,
    date: DateTime(2026, 3, 10),
    isActive: true,
  ),
  Transaction(
    id: 'exp_004',
    title: 'Internet & Airtime',
    amount: 20000,
    date: DateTime(2026, 2, 28),
    isActive: false,
  ),
  Transaction(
    id: 'exp_005',
    title: 'School Fees Contribution',
    amount: 50000,
    date: DateTime(2026, 2, 20),
    isActive: true,
  ),
  Transaction(
    id: 'exp_006',
    title: 'Medical / Health',
    amount: 12000,
    date: DateTime(2026, 2, 15),
    isActive: false,
  ),
];

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(const ExpenseInitial()) {
    on<LoadExpenseTransactions>(_onLoad);
    on<ToggleExpenseTransactionStatus>(_onToggle);
    on<AddExpenseTransaction>(_onAdd);
    on<LoadMoreExpenseTransactions>(_onLoadMore);
  }

  Future<void> _onLoad(
    LoadExpenseTransactions event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(ExpenseLoaded(transactions: List.from(_mockExpenseTransactions)));
  }

  void _onToggle(
    ToggleExpenseTransactionStatus event,
    Emitter<ExpenseState> emit,
  ) {
    if (state is ExpenseLoaded) {
      final current = (state as ExpenseLoaded).transactions;
      final List<Transaction> updated = current.map((t) {
        return t.id == event.id ? t.copyWith(isActive: event.value) : t;
      }).toList();
      emit(ExpenseLoaded(transactions: updated));
    }
  }

  void _onAdd(
    AddExpenseTransaction event,
    Emitter<ExpenseState> emit,
  ) {
    if (state is ExpenseLoaded) {
      final current = (state as ExpenseLoaded).transactions;
      emit(ExpenseLoaded(transactions: [event.transaction, ...current]));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreExpenseTransactions event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is ExpenseLoaded) {
      final current = (state as ExpenseLoaded).transactions;
      await Future.delayed(const Duration(milliseconds: 800));
      final List<Transaction> more = _mockExpenseTransactions
          .map((t) => t.copyWith(
                id: '${t.id}_p2',
                date: t.date.subtract(const Duration(days: 30)),
              ))
          .toList();
      emit(ExpenseLoaded(transactions: [...current, ...more]));
    }
  }
}
