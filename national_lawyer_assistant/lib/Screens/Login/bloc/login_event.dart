part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginWithGoogleEvent extends LoginEvent {}

class LoginWithPasswordEvent extends LoginEvent {}

class LoginWithPhoneEvent extends LoginEvent {}

class LoginToForgotPasswordNavicationEvent extends LoginEvent {}

class LoginToSignUpNavicationEvent extends LoginEvent {}
