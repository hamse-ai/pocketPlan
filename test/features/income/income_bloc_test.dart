import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocket_plan/features/income/domain/entities/transaction.dart';
import 'package:pocket_plan/features/income/presentation/bloc/income_bloc.dart';

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

  IncomeBloc buildBloc() => IncomeBloc(
        getTransactions: mockGetTransactions,
        addTransactionUseCase: mockAdd,
        toggleTransactionStatusUseCase: mockToggle,
      );

  // ── Initial state ──────────────────────────────────────────────────────────
  test('initial state is IncomeInitial', () {
    when(() => mockGetTransactions(any()))
        .thenAnswer((_) => const Stream.empty());
    expect(buildBloc().state, isA<IncomeInitial>());
  });

  // ── LoadIncomeTransactions ─────────────────────────────────────────────────
  group('LoadIncomeTransactions', () {
    blocTest<IncomeBloc, IncomeState>(
      'emits [IncomeLoading, IncomeLoaded] when stream emits transactions',
      build: buildBloc,
      setUp: () {
        when(() => mockGetTransactions('income'))
            .thenAnswer((_) => Stream.value(tTransactionList));
      },
      act: (bloc) => bloc.add(const LoadIncomeTransactions()),
      expect: () => [
        isA<IncomeLoading>(),
        isA<IncomeLoaded>().having(
          (s) => s.transactions,
          'transactions',
          tTransactionList,
        ),
      ],
    );

    blocTest<IncomeBloc, IncomeState>(
      'emits [IncomeLoading, IncomeLoaded] with empty list when stream emits nothing',
      build: buildBloc,
      setUp: () {
        when(() => mockGetTransactions('income'))
            .thenAnswer((_) => Stream.value([]));
      },
      act: (bloc) => bloc.add(const LoadIncomeTransactions()),
      expect: () => [
        isA<IncomeLoading>(),
        isA<IncomeLoaded>().having((s) => s.transactions, 'transactions', isEmpty),
      ],
    );
  });

  // ── AddIncomeTransaction ───────────────────────────────────────────────────
  group('AddIncomeTransaction', skip: true, () {
    blocTest<IncomeBloc, IncomeState>(
      'calls addTransaction use case with correct type and transaction',
      build: buildBloc,
      setUp: () {
        when(() => mockAdd('income', any())).thenAnswer((_) async {});
        when(() => mockGetTransactions('income'))
            .thenAnswer((_) => const Stream.empty());
      },
      act: (bloc) =>
          bloc.add(AddIncomeTransaction(transaction: tTransaction)),
      verify: (_) {
        verify(() => mockAdd('income', tTransaction)).called(1);
      },
    );
  });

  // ── ToggleIncomeTransactionStatus ──────────────────────────────────────────
  group('ToggleIncomeTransactionStatus', () {
    blocTest<IncomeBloc, IncomeState>(
      'calls toggleTransactionStatus with correct arguments',
      build: buildBloc,
      setUp: () {
        when(() => mockToggle('income', any(), any()))
            .thenAnswer((_) async {});
        when(() => mockGetTransactions('income'))
            .thenAnswer((_) => const Stream.empty());
      },
      act: (bloc) => bloc
          .add(const ToggleIncomeTransactionStatus(id: 'txn-001', value: false)),
      verify: (_) {
        verify(() => mockToggle('income', 'txn-001', false)).called(1);
      },
    );
  });

  // ── Multiple stream emissions ──────────────────────────────────────────────
  group('Stream updates', () {
    blocTest<IncomeBloc, IncomeState>(
      'emits IncomeLoaded each time the stream emits',
      build: buildBloc,
      setUp: () {
        final controller = StreamController<List<Transaction>>();
        when(() => mockGetTransactions('income'))
            .thenAnswer((_) => controller.stream);
        // Add two emissions
        Future.delayed(Duration.zero, () {
          controller.add([tTransaction]);
          controller.add([]);
        });
      },
      act: (bloc) => bloc.add(const LoadIncomeTransactions()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<IncomeLoading>(),
        isA<IncomeLoaded>(),
        isA<IncomeLoaded>(),
      ],
    );
  });
}
