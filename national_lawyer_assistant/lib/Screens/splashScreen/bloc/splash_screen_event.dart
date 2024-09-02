part of 'splash_screen_bloc.dart';

@immutable
sealed class SplashScreenEvent {}

class SplashScreenInitalEvent extends SplashScreenEvent {
  final SplashScreenBloc splashScreenBloc;

  SplashScreenInitalEvent({required this.splashScreenBloc});
}

class SplashScreenDoneEvent extends SplashScreenEvent {}
