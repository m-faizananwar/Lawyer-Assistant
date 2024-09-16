part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

sealed class SignUpActionState extends SignupState {}

final class SignupInitial extends SignupState {}

class SignupLoaded extends SignupState {}

class SignupLoadingError extends SignUpActionState {
  final String error;

  SignupLoadingError(this.error);
}

class SignupToLogin extends SignUpActionState {}

class SignupLoading extends SignUpActionState {}

class SignUpToVerifyEmail extends SignUpActionState {}
