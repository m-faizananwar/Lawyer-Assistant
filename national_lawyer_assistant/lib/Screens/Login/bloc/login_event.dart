part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginWithGoogleEvent extends LoginEvent {}

class LoginWithPasswordEvent extends LoginEvent {
  final String email;
  final String password;

  LoginWithPasswordEvent({required this.email, required this.password});
}

class LoginWithPhoneEvent extends LoginEvent {}

class LoginToForgotPasswordNavigationEvent extends LoginEvent {}

class LoginToSignUpNavigationEvent extends LoginEvent {}
