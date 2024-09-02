part of 'splash_screen_bloc.dart';

@immutable
sealed class SplashScreenState {}

sealed class SplashScreenActionState extends SplashScreenState {}

final class SplashScreenInitial extends SplashScreenState {}

class SplashScreenLoading extends SplashScreenState {}

class SplashScreenLoaded extends SplashScreenState {}

class SplashScreenError extends SplashScreenState {
  final String message;

  SplashScreenError(this.message);
}

class SplashScreenToHome extends SplashScreenActionState {}

class SplashScreenToLogin extends SplashScreenActionState {}

class SplashScreenToVerifyEmail extends SplashScreenActionState {}
