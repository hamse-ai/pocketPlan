import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_plan/features/income/domain/entities/transaction.dart';

part 'income_event.dart';
part 'income_state.dart';

/// Mock income data mimicking realistic Rwandan workforce income patterns.
final List<Transaction> _mockIncomeTransactions = [
  Transaction(
    id: 'inc_001',
    title: 'Freelance Payment',
    amount: 85000,
    date: DateTime(2026, 3, 10),
    isActive: true,
  ),
  Transaction(
    id: 'inc_002',
    title: 'Internship Stipend',
    amount: 60000,
    date: DateTime(2026, 3, 5),
    isActive: true,
  ),
  Transaction(
    id: 'inc_003',
    title: 'Parental Support',
    amount: 50000,
    date: DateTime(2026, 3, 1),
    isActive: true,
  ),
  Transaction(
    id: 'inc_004',
    title: 'Weekend Tutoring',
    amount: 30000,
    date: DateTime(2026, 2, 28),
    isActive: false,
  ),
  Transaction(
    id: 'inc_005',
    title: 'Side Project Bonus',
    amount: 120000,
    date: DateTime(2026, 2, 20),
    isActive: true,
  ),
  Transaction(
    id: 'inc_006',
    title: 'Part-time Consulting',
    amount: 45000,
    date: DateTime(2026, 2, 15),
    isActive: false,
  ),
];

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  IncomeBloc() : super(const IncomeInitial()) {
    on<LoadIncomeTransactions>(_onLoad);
    on<ToggleIncomeTransactionStatus>(_onToggle);
    on<AddIncomeTransaction>(_onAdd);
    on<LoadMoreIncomeTransactions>(_onLoadMore);
  }

  Future<void> _onLoad(
    LoadIncomeTransactions event,
    Emitter<IncomeState> emit,
  ) async {
    emit(const IncomeLoading());
    // Simulate network/DB delay
    await Future.delayed(const Duration(seconds: 1));
    emit(IncomeLoaded(transactions: List.from(_mockIncomeTransactions)));
  }

  void _onToggle(
    ToggleIncomeTransactionStatus event,
    Emitter<IncomeState> emit,
  ) {
    if (state is IncomeLoaded) {
      final current = (state as IncomeLoaded).transactions;
      final List<Transaction> updated = current.map((t) {
        return t.id == event.id ? t.copyWith(isActive: event.value) : t;
      }).toList();
      emit(IncomeLoaded(transactions: updated));
    }
  }

  void _onAdd(
    AddIncomeTransaction event,
    Emitter<IncomeState> emit,
  ) {
    if (state is IncomeLoaded) {
      final current = (state as IncomeLoaded).transactions;
      emit(IncomeLoaded(transactions: [event.transaction, ...current]));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreIncomeTransactions event,
    Emitter<IncomeState> emit,
  ) async {
    if (state is IncomeLoaded) {
      final current = (state as IncomeLoaded).transactions;
      // Simulate loading more (in real app would use pagination cursor)
      await Future.delayed(const Duration(milliseconds: 800));
      // Re-append mock data as placeholder for "next page"
      final List<Transaction> more = _mockIncomeTransactions
          .map((t) => t.copyWith(
                id: '${t.id}_p2',
                date: t.date.subtract(const Duration(days: 30)),
              ))
          .toList();
      emit(IncomeLoaded(transactions: [...current, ...more]));
    }
  }
}
