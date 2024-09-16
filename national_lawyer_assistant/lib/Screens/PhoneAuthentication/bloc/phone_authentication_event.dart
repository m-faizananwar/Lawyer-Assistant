part of 'phone_authentication_bloc.dart';

@immutable
sealed class PhoneAuthenticationEvent {}

class PhoneAuthenticationInitialEvent extends PhoneAuthenticationEvent {}

class PhoneAuthenticationButtonPressedEvent extends PhoneAuthenticationEvent {
  final String phoneNumber;
  final String verificationId;

  PhoneAuthenticationButtonPressedEvent(
      {required this.verificationId, required this.phoneNumber});
}

class LoadingStateEvent extends PhoneAuthenticationEvent {}
