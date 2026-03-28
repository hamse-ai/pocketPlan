 import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up_with_email.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/delete_account.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SignInWithGoogle signInWithGoogle;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final ChangePassword changePassword;
  final DeleteAccount deleteAccount;

  AuthBloc({
    required this.signInWithEmail,
    required this.signUpWithEmail,
    required this.signInWithGoogle,
    required this.signOut,
    required this.getCurrentUser,
    required this.changePassword,
    required this.deleteAccount,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
    on<ChangePasswordEvent>(_onChangePassword);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    final result = await getCurrentUser(NoParams());
    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignInWithEmail(SignInWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithEmail(SignInParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignUpWithEmail(SignUpWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signUpWithEmail(SignInParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignInWithGoogle(SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithGoogle(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signOut(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (success) => emit(Unauthenticated()),
    );
  }

  Future<void> _onChangePassword(ChangePasswordEvent event, Emitter<AuthState> emit) async {
    if (state is Authenticated) {
      emit(AuthLoading());
      final result = await changePassword(event.newPassword);
      
      await result.fold(
        (failure) async => emit(AuthError(failure.message)),
        (_) async {
          await signOut(NoParams());
          emit(Unauthenticated());
        },
      );
    }
  }

  Future<void> _onDeleteAccount(DeleteAccountEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await deleteAccount(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }
}
