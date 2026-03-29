import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plan/core/error/failures.dart';

void main() {
  group('Failure classes', () {
    test('ServerFailure holds correct message', () {
      const failure = ServerFailure('Server error');
      expect(failure.message, 'Server error');
    });

    test('AuthFailure holds correct message', () {
      const failure = AuthFailure('Unauthorized');
      expect(failure.message, 'Unauthorized');
    });

    test('CacheFailure holds correct message', () {
      const failure = CacheFailure('Cache miss');
      expect(failure.message, 'Cache miss');
    });

    test('Failures support value equality via Equatable', () {
      const f1 = ServerFailure('Error');
      const f2 = ServerFailure('Error');
      expect(f1, equals(f2));
    });

    test('Different failure types are not equal even with same message', () {
      const serverF = ServerFailure('Error');
      const authF = AuthFailure('Error');
      expect(serverF, isNot(equals(authF)));
    });

    test('Failures have the correct props', () {
      const failure = CacheFailure('Cache failed');
      expect(failure.props, ['Cache failed']);
    });
  });
}
