part of 'forget_password_bloc.dart';

@immutable
sealed class ForgetPasswordState {}

sealed class ForgetPasswordActionState extends ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoaded extends ForgetPasswordState {}

class ForgetPasswordError extends ForgetPasswordActionState {
  final String message;

  ForgetPasswordError({required this.message});
}

class ForgetPasswordLoading extends ForgetPasswordActionState {}
