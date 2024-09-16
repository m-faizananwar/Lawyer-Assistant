import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:national_lawyer_assistant/utils/sign_in_functions.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupInitialEvent>(signupInitialEvent);

    on<SignupButtonPressedEvent>(signupButtonPressedEvent);

    on<SignupToLoginEvent>(signupToLoginEvent);
  }

  FutureOr<void> signupInitialEvent(
      SignupInitialEvent event, Emitter<SignupState> emit) {
    emit(SignupLoaded());
  }

  FutureOr<void> signupButtonPressedEvent(
      SignupButtonPressedEvent event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
    await Future.delayed(Duration(seconds: 1));
    String name = event.firstName;
    if (event.lastName.isNotEmpty) {
      name = event.firstName + " " + event.lastName;
    }
    String response =
        await LoginFunctions().signUpUser(name, event.email, event.password);
    if (response == "Registration Successful") {
      emit(SignUpToVerifyEmail());
    } else {
      emit(SignupLoadingError(response));
    }
  }

  FutureOr<void> signupToLoginEvent(
      SignupToLoginEvent event, Emitter<SignupState> emit) {
    emit(SignupToLogin());
  }
}
