import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plan/features/income/domain/entities/transaction.dart';

void main() {
  final baseDate = DateTime(2026, 1, 1);

  group('Transaction entity', () {
    final transaction = Transaction(
      id: 'txn-001',
      title: 'Salary',
      amount: 5000.0,
      date: baseDate,
      isActive: true,
    );

    test('supports value equality via Equatable', () {
      final duplicate = Transaction(
        id: 'txn-001',
        title: 'Salary',
        amount: 5000.0,
        date: baseDate,
        isActive: true,
      );
      expect(transaction, equals(duplicate));
    });

    test('is not equal when id differs', () {
      final other = Transaction(
        id: 'txn-999',
        title: 'Salary',
        amount: 5000.0,
        date: baseDate,
      );
      expect(transaction, isNot(equals(other)));
    });

    test('defaults isActive to true', () {
      final t = Transaction(
        id: 'txn-002',
        title: 'Bonus',
        amount: 1000.0,
        date: baseDate,
      );
      expect(t.isActive, isTrue);
    });

    test('copyWith preserves existing fields when nothing is overridden', () {
      final copy = transaction.copyWith();
      expect(copy, equals(transaction));
    });

    test('copyWith correctly overrides isActive', () {
      final toggled = transaction.copyWith(isActive: false);
      expect(toggled.isActive, isFalse);
      expect(toggled.id, transaction.id);
      expect(toggled.amount, transaction.amount);
    });

    test('copyWith correctly overrides amount', () {
      final updated = transaction.copyWith(amount: 9999.99);
      expect(updated.amount, 9999.99);
      expect(updated.title, 'Salary');
    });

    test('props list contains all fields', () {
      expect(transaction.props,
          [transaction.id, transaction.title, transaction.amount, transaction.date, transaction.isActive]);
    });
  });

  // ── Business logic helpers ─────────────────────────────────────────────────
  group('Transaction amount logic', () {
    test('total of a list is the sum of active transaction amounts', () {
      final transactions = [
        Transaction(id: '1', title: 'A', amount: 100, date: baseDate, isActive: true),
        Transaction(id: '2', title: 'B', amount: 200, date: baseDate, isActive: false),
        Transaction(id: '3', title: 'C', amount: 300, date: baseDate, isActive: true),
      ];

      final activeTotal = transactions
          .where((t) => t.isActive)
          .fold<double>(0, (sum, t) => sum + t.amount);

      expect(activeTotal, equals(400.0));
    });

    test('inactive transactions contribute zero to the active total', () {
      final transactions = [
        Transaction(id: '1', title: 'Paused', amount: 500, date: baseDate, isActive: false),
      ];

      final activeTotal = transactions
          .where((t) => t.isActive)
          .fold<double>(0, (sum, t) => sum + t.amount);

      expect(activeTotal, equals(0.0));
    });
  });
}
