import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocket_plan/features/income/domain/entities/transaction.dart';
import 'package:pocket_plan/features/budget/presentation/bloc/expense_bloc.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/fake_data.dart';

void main() {
  late MockGetTransactions mockGetTransactions;
  late MockAddTransaction mockAdd;
  late MockToggleTransactionStatus mockToggle;

  setUp(() {
    mockGetTransactions = MockGetTransactions();
    mockAdd = MockAddTransaction();
    mockToggle = MockToggleTransactionStatus();
  });

  ExpenseBloc buildBloc() => ExpenseBloc(
        getTransactions: mockGetTransactions,
        addTransactionUseCase: mockAdd,
        toggleTransactionStatusUseCase: mockToggle,
      );

  // ── Initial state ──────────────────────────────────────────────────────────
  test('initial state is ExpenseInitial', () {
    when(() => mockGetTransactions(any()))
        .thenAnswer((_) => const Stream.empty());
    expect(buildBloc().state, isA<ExpenseInitial>());
  });

  // ── LoadExpenseTransactions ────────────────────────────────────────────────
  group('LoadExpenseTransactions', () {
    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseLoading, ExpenseLoaded] when stream emits transactions',
      build: buildBloc,
      setUp: () {
        when(() => mockGetTransactions('expense'))
            .thenAnswer((_) => Stream.value(tTransactionList));
      },
      act: (bloc) => bloc.add(const LoadExpenseTransactions()),
      expect: () => [
        isA<ExpenseLoading>(),
        isA<ExpenseLoaded>().having(
          (s) => s.transactions,
          'transactions',
          tTransactionList,
        ),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseLoading, ExpenseLoaded] with empty list',
      build: buildBloc,
      setUp: () {
        when(() => mockGetTransactions('expense'))
            .thenAnswer((_) => Stream.value([]));
      },
      act: (bloc) => bloc.add(const LoadExpenseTransactions()),
      expect: () => [
        isA<ExpenseLoading>(),
        isA<ExpenseLoaded>()
            .having((s) => s.transactions, 'transactions', isEmpty),
      ],
    );
  });

  // ── AddExpenseTransaction ──────────────────────────────────────────────────
  group('AddExpenseTransaction', () {
    blocTest<ExpenseBloc, ExpenseState>(
      'calls addTransaction use case with correct type and transaction',
      build: buildBloc,
      setUp: () {
        when(() => mockAdd('expense', any())).thenAnswer((_) async {});
        when(() => mockGetTransactions('expense'))
            .thenAnswer((_) => const Stream.empty());
      },
      act: (bloc) =>
          bloc.add(AddExpenseTransaction(transaction: tTransaction)),
      verify: (_) {
        verify(() => mockAdd('expense', tTransaction)).called(1);
      },
    );
  });

  // ── ToggleExpenseTransactionStatus ────────────────────────────────────────
  group('ToggleExpenseTransactionStatus', () {
    blocTest<ExpenseBloc, ExpenseState>(
      'calls toggleTransactionStatus with correct arguments',
      build: buildBloc,
      setUp: () {
        when(() => mockToggle('expense', any(), any()))
            .thenAnswer((_) async {});
        when(() => mockGetTransactions('expense'))
            .thenAnswer((_) => const Stream.empty());
      },
      act: (bloc) => bloc.add(
          const ToggleExpenseTransactionStatus(id: 'txn-001', value: true)),
      verify: (_) {
        verify(() => mockToggle('expense', 'txn-001', true)).called(1);
      },
    );
  });

  // ── Multiple stream emissions ──────────────────────────────────────────────
  group('Stream updates', () {
    blocTest<ExpenseBloc, ExpenseState>(
      'emits ExpenseLoaded each time the stream emits new data',
      build: buildBloc,
      setUp: () {
        final controller = StreamController<List<Transaction>>();
        when(() => mockGetTransactions('expense'))
            .thenAnswer((_) => controller.stream);
        Future.delayed(Duration.zero, () {
          controller.add([tTransaction]);
          controller.add([]);
        });
      },
      act: (bloc) => bloc.add(const LoadExpenseTransactions()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<ExpenseLoading>(),
        isA<ExpenseLoaded>(),
        isA<ExpenseLoaded>(),
      ],
    );
  });
}
