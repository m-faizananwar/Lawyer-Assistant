part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

sealed class LoginActionState extends LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginFailure extends LoginState {
  final String error;

  LoginFailure({this.error = "An Exception Occured. Try Again"});
}

final class LoginToHomeNavigationState extends LoginActionState {}

final class LoginToVerifyEmailNavigationState extends LoginActionState {}

final class LoginToForgotPasswordNavigationState extends LoginActionState {}

final class LoginToPhoneNavigationState extends LoginActionState {}

final class LoginToSignUpNavigationState extends LoginActionState {}
