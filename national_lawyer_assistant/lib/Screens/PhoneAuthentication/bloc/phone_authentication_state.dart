part of 'phone_authentication_bloc.dart';

@immutable
sealed class PhoneAuthenticationState {}

sealed class PhoneAuthenticationActionState extends PhoneAuthenticationState {}

final class PhoneAuthenticationInitial extends PhoneAuthenticationState {}

final class PhoneAuthenticationLoaded extends PhoneAuthenticationState {}

final class PhoneAuthenticationError extends PhoneAuthenticationActionState {
  final String error;

  PhoneAuthenticationError({this.error = "An Exception Occured. Try Again"});
}

final class PhoneAuthenticationToSplashNavigationState
    extends PhoneAuthenticationActionState {}

final class PhoneAuthenticationToVerifyPhoneNavigationState
    extends PhoneAuthenticationActionState {
  final String phoneNumber;
  final String verificationId;

  PhoneAuthenticationToVerifyPhoneNavigationState(
      {required this.verificationId, required this.phoneNumber});
}

final class PhoneAuthenticationLoadingActionState
    extends PhoneAuthenticationActionState {}
