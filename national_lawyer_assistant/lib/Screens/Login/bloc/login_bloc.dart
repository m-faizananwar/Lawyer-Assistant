import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);

    on<LoginWithPasswordEvent>(loginWithPasswordEvent);

    on<LoginWithGoogleEvent>(loginWithGoogleEvent);

    on<LoginWithPhoneEvent>(loginWithPhoneEvent);

    on<LoginToForgotPasswordNavicationEvent>(
        loginToForgotPasswordNavicationEvent);

    on<LoginToSignUpNavicationEvent>(loginToSignUpNavicationEvent);
  }

  FutureOr<void> loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    await Future.delayed(const Duration(seconds: 4));
    emit(LoginSuccess());
  }

  FutureOr<void> loginWithPasswordEvent(
      LoginWithPasswordEvent event, Emitter<LoginState> emit) {}

  FutureOr<void> loginWithGoogleEvent(
      LoginWithGoogleEvent event, Emitter<LoginState> emit) {}

  FutureOr<void> loginWithPhoneEvent(
      LoginWithPhoneEvent event, Emitter<LoginState> emit) {}

  FutureOr<void> loginToForgotPasswordNavicationEvent(
      LoginToForgotPasswordNavicationEvent event, Emitter<LoginState> emit) {}

  FutureOr<void> loginToSignUpNavicationEvent(
      LoginToSignUpNavicationEvent event, Emitter<LoginState> emit) {}
}
