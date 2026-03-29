import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plan/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    const user = UserEntity(
      uid: 'uid-001',
      email: 'test@pocketplan.com',
      displayName: 'Test User',
    );

    test('supports value equality via Equatable', () {
      const duplicate = UserEntity(
        uid: 'uid-001',
        email: 'test@pocketplan.com',
        displayName: 'Test User',
      );
      expect(user, equals(duplicate));
    });

    test('is not equal when uid differs', () {
      const different = UserEntity(
        uid: 'uid-999',
        email: 'test@pocketplan.com',
        displayName: 'Test User',
      );
      expect(user, isNot(equals(different)));
    });

    test('allows nullable displayName', () {
      const noName = UserEntity(uid: 'uid-002', email: 'anon@app.com');
      expect(noName.displayName, isNull);
    });

    test('props list contains uid, email, displayName', () {
      expect(user.props, ['uid-001', 'test@pocketplan.com', 'Test User']);
    });
  });
}
