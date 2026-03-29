import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:pocket_plan/features/home/presentation/pages/home_page.dart';
import 'package:pocket_plan/features/income/presentation/bloc/income_bloc.dart';
import 'package:pocket_plan/features/budget/presentation/bloc/expense_bloc.dart';
import 'package:pocket_plan/features/income/domain/entities/transaction.dart';

import '../../helpers/test_helpers.dart';

void main() {
  late MockIncomeBloc mockIncomeBloc;
  late MockExpenseBloc mockExpenseBloc;

  setUpAll(() {
    registerFallbackValue(const LoadIncomeTransactions());
    registerFallbackValue(const LoadExpenseTransactions());
  });

  setUp(() {
    mockIncomeBloc = MockIncomeBloc();
    mockExpenseBloc = MockExpenseBloc();
  });

  Widget buildTestApp() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<IncomeBloc>.value(value: mockIncomeBloc),
          BlocProvider<ExpenseBloc>.value(value: mockExpenseBloc),
        ],
        child: const HomePage(),
      ),
    );
  }

  group('HomePage Widget Tests', () {
    testWidgets('renders balance and safe to spend correctly', (WidgetTester tester) async {
      // Setup mock data
      final transactions = [
        Transaction(
          id: '1',
          title: 'Salary',
          amount: 500000,
          date: DateTime.now(),
        ),
      ];

      when(() => mockIncomeBloc.state).thenReturn(IncomeLoaded(transactions: transactions));
      when(() => mockExpenseBloc.state).thenReturn(const ExpenseLoaded(transactions: []));

      await tester.pumpWidget(buildTestApp());

      // Verify header renders
      expect(find.text('Pocketplan'), findsOneWidget);
      
      // Verify Safe to Spend renders
      // Calculations: 500,000 income - 0 expense = 500,000 balance. 
      // Default savings is 20% = 100,000. Safe to spend = 400,000.
      expect(find.textContaining('RWF 400,000'), findsOneWidget);
    });

    testWidgets('shows warning banner during lean periods', (WidgetTester tester) async {
      // Setup low balance for lean period
      final transactions = [
        Transaction(
          id: '1',
          title: 'Small Job',
          amount: 5000, // Very low income to trigger lean period
          date: DateTime.now(),
        ),
      ];

      when(() => mockIncomeBloc.state).thenReturn(IncomeLoaded(transactions: transactions));
      when(() => mockExpenseBloc.state).thenReturn(const ExpenseLoaded(transactions: []));

      await tester.pumpWidget(buildTestApp());

      // Verify warning banner appears
      expect(find.text('Lean Period Ahead'), findsOneWidget);
      expect(find.textContaining('Try to reduce spending'), findsOneWidget);
    });
  });
}

// Mock definitions for the blocks since they were missing in test_helpers
class MockIncomeBloc extends MockBloc<IncomeEvent, IncomeState> implements IncomeBloc {}
class MockExpenseBloc extends MockBloc<ExpenseEvent, ExpenseState> implements ExpenseBloc {}
