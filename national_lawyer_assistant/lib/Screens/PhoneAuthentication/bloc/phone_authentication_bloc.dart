import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:national_lawyer_assistant/utils/sign_in_functions.dart';

part 'phone_authentication_event.dart';
part 'phone_authentication_state.dart';

class PhoneAuthenticationBloc
    extends Bloc<PhoneAuthenticationEvent, PhoneAuthenticationState> {
  PhoneAuthenticationBloc() : super(PhoneAuthenticationInitial()) {
    on<PhoneAuthenticationInitialEvent>(phoneAuthenticationInitialEvent);

    on<PhoneAuthenticationButtonPressedEvent>(
        phoneAuthenticationButtonPressedEvent);

    on<LoadingStateEvent>(loadingStateEvent);
  }

  FutureOr<void> phoneAuthenticationInitialEvent(
      PhoneAuthenticationInitialEvent event,
      Emitter<PhoneAuthenticationState> emit) {
    emit(PhoneAuthenticationLoaded());
  }

  FutureOr<void> phoneAuthenticationButtonPressedEvent(
      PhoneAuthenticationButtonPressedEvent event,
      Emitter<PhoneAuthenticationState> emit) async {
    print("Phone Number: ${event.phoneNumber}");

    emit(PhoneAuthenticationToVerifyPhoneNavigationState(
        verificationId: event.verificationId.toString(),
        phoneNumber: event.phoneNumber.toString()));
  }

  FutureOr<void> loadingStateEvent(
      LoadingStateEvent event, Emitter<PhoneAuthenticationState> emit) {
    emit(PhoneAuthenticationLoadingActionState());
  }
}
