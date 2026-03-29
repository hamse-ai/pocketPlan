import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

// ── Change Password ──────────────────────────────────────────────────────────

class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });
}

class ChangePassword implements UseCase<void, ChangePasswordParams> {
  final FirebaseAuth auth;

  ChangePassword(this.auth);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    try {
      final user = auth.currentUser;
      if (user == null || user.email == null) {
        return const Left(ServerFailure('No user logged in'));
      }

      // Re-authenticate user before changing password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: params.currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(params.newPassword);

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          return const Left(ServerFailure('Current password is incorrect'));
        case 'weak-password':
          return const Left(ServerFailure('New password is too weak'));
        case 'requires-recent-login':
          return const Left(ServerFailure('Please log in again and try'));
        default:
          return Left(ServerFailure('Failed to change password: ${e.message}'));
      }
    } catch (e) {
      return Left(ServerFailure('Failed to change password: $e'));
    }
  }
}

// ── Delete Account ───────────────────────────────────────────────────────────

class DeleteAccountParams {
  final String password;

  DeleteAccountParams({required this.password});
}

class DeleteAccount implements UseCase<void, DeleteAccountParams> {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  DeleteAccount({required this.auth, required this.firestore});

  @override
  Future<Either<Failure, void>> call(DeleteAccountParams params) async {
    try {
      final user = auth.currentUser;
      if (user == null || user.email == null) {
        return const Left(ServerFailure('No user logged in'));
      }

      // Re-authenticate before deletion
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: params.password,
      );

      await user.reauthenticateWithCredential(credential);

      // Delete user data from Firestore
      await firestore.collection('users').doc(user.uid).delete();

      // Delete Firebase Auth account
      await user.delete();

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          return const Left(ServerFailure('Password is incorrect'));
        case 'requires-recent-login':
          return const Left(ServerFailure('Please log in again and try'));
        default:
          return Left(ServerFailure('Failed to delete account: ${e.message}'));
      }
    } catch (e) {
      return Left(ServerFailure('Failed to delete account: $e'));
    }
  }
}

// ── Download User Data ───────────────────────────────────────────────────────

class DownloadUserData implements UseCase<Map<String, dynamic>, NoParams> {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  DownloadUserData({required this.auth, required this.firestore});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return const Left(ServerFailure('No user logged in'));
      }

      final userDoc = await firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) {
        return const Left(ServerFailure('User data not found'));
      }

      // Get all user data including subcollections
      final userData = userDoc.data() ?? {};
      
      // Fetch income transactions
      final incomeSnapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('income')
          .get();
      
      final incomeData = incomeSnapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      // Fetch expense transactions
      final expenseSnapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('expense')
          .get();
      
      final expenseData = expenseSnapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      // Fetch settings
      final settingsDoc = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('settings')
          .doc('preferences')
          .get();
      
      final settingsData = settingsDoc.exists ? settingsDoc.data() : null;

      // Compile all data
      final allData = {
        'user': {
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'createdAt': user.metadata.creationTime?.toIso8601String(),
        },
        'profile': userData,
        'income': incomeData,
        'expenses': expenseData,
        'settings': settingsData,
        'exportedAt': DateTime.now().toIso8601String(),
      };

      return Right(allData);
    } catch (e) {
      return Left(ServerFailure('Failed to download data: $e'));
    }
  }
}