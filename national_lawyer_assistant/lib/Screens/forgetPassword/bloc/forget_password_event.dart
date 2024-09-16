part of 'forget_password_bloc.dart';

@immutable
sealed class ForgetPasswordEvent {}

class ForgetPasswordInitialEvent extends ForgetPasswordEvent {}

class ForgetPasswordButtonPressedEvent extends ForgetPasswordEvent {
  final String email;

  ForgetPasswordButtonPressedEvent({required this.email});
}
