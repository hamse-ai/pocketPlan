import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;

import '../../../../core/error/failures.dart';
import '../models/user_model.dart';


abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail({required String email, required String password});
  Future<UserModel> signUpWithEmail({required String email, required String password});
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel> getCurrentUser();
  Future<void> changePassword(String newPassword);
  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final gsi.GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> signInWithEmail({required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return UserModel.fromFirebaseUser(userCredential.user!);
      } else {
        throw const AuthFailure('User not found.');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message ?? 'Authentication failed.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No account found with this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Invalid email or password.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      }
      throw AuthFailure(errorMessage);
    } catch (e) {
      throw const ServerFailure('An unexpected error occurred.');
    }
  }

  @override
  Future<UserModel> signUpWithEmail({required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return UserModel.fromFirebaseUser(userCredential.user!);
      } else {
        throw const AuthFailure('Failed to create account.');
      }
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Sign up failed.');
    } catch (e) {
      throw const ServerFailure('An unexpected error occurred.');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final gsi.GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthFailure('Google sign in cancelled.');
      }

      final gsi.GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);
      if (userCredential.user != null) {
        return UserModel.fromFirebaseUser(userCredential.user!);
      } else {
        throw const AuthFailure('Google sign in failed.');
      }
    } on FirebaseAuthException catch (e) {
       throw AuthFailure(e.message ?? 'Google sign in failed.');
    } on PlatformException catch (e) {
       throw AuthFailure('Google Sign-In Error: ${e.message} (Code: ${e.code})');
    } catch (e) {
      throw ServerFailure('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      try {
        await googleSignIn.signOut();
      } catch (_) {
        // Ignore Google Sign In errors (e.g., if never signed in via Google)
      }
    } catch (e) {
      throw const ServerFailure('Failed to sign out.');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    } else {
      throw const AuthFailure('No user logged in.');
    }
  }

  @override
  Future<void> changePassword(String newPassword) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        await user.updatePassword(newPassword);
      } on FirebaseAuthException catch (e) {
        throw AuthFailure(e.message ?? 'Failed to update password.');
      } catch (e) {
        throw const ServerFailure('An unexpected error occurred.');
      }
    } else {
      throw const AuthFailure('No user logged in.');
    }
  }

  @override
  Future<void> deleteAccount() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        await user.delete();
      } on FirebaseAuthException catch (e) {
        // May require re-authentication if credentials are too old.
        throw AuthFailure(e.message ?? 'Failed to delete account. You may need to sign in again first.');
      } catch (e) {
        throw const ServerFailure('An unexpected error occurred.');
      }
    } else {
      throw const AuthFailure('No user logged in.');
    }
  }
}
