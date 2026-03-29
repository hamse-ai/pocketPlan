import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;

import '../../../../core/error/failures.dart';
import '../models/user_model.dart';


abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail({required String email, required String password});
  Future<UserModel> signUpWithEmail({required String email, required String password});
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel> getCurrentUser();
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
      throw AuthFailure(e.message ?? 'Authentication failed.');
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
    } catch (e) {
      throw const ServerFailure('An unexpected error occurred.');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
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
}
