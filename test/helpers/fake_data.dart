import 'package:pocket_plan/features/auth/domain/entities/user_entity.dart';
import 'package:pocket_plan/features/income/domain/entities/transaction.dart';
import 'package:pocket_plan/features/profile/domain/entities/user_profile.dart';

/// Reusable fake objects shared across all tests.

const tUser = UserEntity(
  uid: 'uid-001',
  email: 'test@pocketplan.com',
  displayName: 'Test User',
);

final tTransaction = Transaction(
  id: 'txn-001',
  title: 'Salary',
  amount: 5000.0,
  date: DateTime(2026, 1, 1),
  isActive: true,
);

final tTransactionList = [tTransaction];

const tProfile = UserProfile(
  fullName: 'John Doe',
  email: 'john@pocketplan.com',
  country: 'Kenya',
  profession: 'Engineer',
  bio: 'Flutter developer',
  photoUrl: 'https://example.com/photo.jpg',
);
