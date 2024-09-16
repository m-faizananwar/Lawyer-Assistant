import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:national_lawyer_assistant/utils/sign_in_functions.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);

    on<LoginWithPasswordEvent>(loginWithPasswordEvent);

    on<LoginWithGoogleEvent>(loginWithGoogleEvent);

    on<LoginWithPhoneEvent>(loginWithPhoneEvent);

    on<LoginToForgotPasswordNavigationEvent>(
        loginToForgotPasswordNavigationEvent);

    on<LoginToSignUpNavigationEvent>(loginToSignUpNavigationEvent);
  }

  FutureOr<void> loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    await Future.delayed(const Duration(seconds: 2));
    emit(LoginSuccess());
  }

  FutureOr<void> loginWithPasswordEvent(
      LoginWithPasswordEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingActionState());
    await Future.delayed(const Duration(seconds: 1));
    String response =
        await LoginFunctions.logInUser(event.email, event.password);

    if (response == "Login Successfull") {
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        emit(LoginToSplashNavigationState());
      } else {
        print('Verify Email');
        emit(LoginToVerifyEmailNavigationState());
      }
    } else {
      emit(LoginFailure(error: response));
      emit(LoginSuccess());
    }
  }

  FutureOr<void> loginWithGoogleEvent(
      LoginWithGoogleEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingActionState());
    await Future.delayed(const Duration(seconds: 1));
    String response = await LoginFunctions.googleLogInUser();

    if (response == "Login Successfull") {
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        emit(LoginToSplashNavigationState());
      } else {
        print('Verify Email');
        emit(LoginToVerifyEmailNavigationState());
      }
    } else {
      emit(LoginFailure(error: response));
      emit(LoginSuccess());
    }
  }

  FutureOr<void> loginWithPhoneEvent(
      LoginWithPhoneEvent event, Emitter<LoginState> emit) {
    emit(LoginToPhoneNavigationState());
  }

  FutureOr<void> loginToForgotPasswordNavigationEvent(
      LoginToForgotPasswordNavigationEvent event, Emitter<LoginState> emit) {
    emit(LoginToForgotPasswordNavigationState());
  }

  FutureOr<void> loginToSignUpNavigationEvent(
      LoginToSignUpNavigationEvent event, Emitter<LoginState> emit) {
    emit(LoginToSignUpNavigationState());
  }
}
