import 'package:mocktail/mocktail.dart';
import 'package:pocket_plan/features/auth/domain/repositories/auth_repository.dart';
import 'package:pocket_plan/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:pocket_plan/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:pocket_plan/features/auth/domain/usecases/sign_out.dart';
import 'package:pocket_plan/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:pocket_plan/features/auth/domain/usecases/get_current_user.dart';
import 'package:pocket_plan/features/income/domain/repositories/transaction_repository.dart';
import 'package:pocket_plan/features/income/domain/usecases/transaction_usecases.dart';
import 'package:pocket_plan/features/profile/domain/repositories/profile_repository.dart';
import 'package:pocket_plan/features/profile/domain/usecases/get_profile.dart';
import 'package:pocket_plan/features/profile/domain/usecases/update_profile.dart';
import 'package:pocket_plan/features/profile/domain/usecases/upload_profile_photo.dart';

// ── Auth mocks ─────────────────────────────────────────────────────────────
class MockAuthRepository extends Mock implements AuthRepository {}

class MockSignInWithEmail extends Mock implements SignInWithEmail {}

class MockSignUpWithEmail extends Mock implements SignUpWithEmail {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockSignOut extends Mock implements SignOut {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

// ── Transaction mocks ──────────────────────────────────────────────────────
class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockGetTransactions extends Mock implements GetTransactions {}

class MockAddTransaction extends Mock implements AddTransaction {}

class MockToggleTransactionStatus extends Mock implements ToggleTransactionStatus {}

// ── Profile mocks ──────────────────────────────────────────────────────────
class MockProfileRepository extends Mock implements ProfileRepository {}

class MockGetProfile extends Mock implements GetProfile {}

class MockUpdateProfile extends Mock implements UpdateProfile {}

class MockUploadProfilePhoto extends Mock implements UploadProfilePhoto {}
