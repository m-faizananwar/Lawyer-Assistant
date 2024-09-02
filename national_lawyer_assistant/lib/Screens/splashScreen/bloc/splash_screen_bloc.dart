import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:national_lawyer_assistant/utils/checkSignInMethod.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitial()) {
    on<SplashScreenInitalEvent>(splashScreenInitalEvent);
    on<SplashScreenDoneEvent>(splashScreenDoneEvent);
  }

  FutureOr<void> splashScreenInitalEvent(
      SplashScreenInitalEvent event, Emitter<SplashScreenState> emit) async {
    emit(SplashScreenLoading());
    await Future.delayed(const Duration(seconds: 8));
    event.splashScreenBloc.add(SplashScreenDoneEvent());
  }

  FutureOr<void> splashScreenDoneEvent(
      SplashScreenDoneEvent event, Emitter<SplashScreenState> emit) {
    User? user = FirebaseAuth.instance.currentUser;
    String signInMethod = "Unknown";
    if (user != null) {
      signInMethod = checkSignInMethod(user);
    }
    if (signInMethod == "Phone Sign-In") {
      emit(SplashScreenToHome());
    } else if (!(user?.emailVerified ?? true)) {
      print("verify");
      emit(SplashScreenToVerifyEmail());
    } else if (user?.emailVerified ?? false) {
      print("verified");
      emit(SplashScreenToHome());
    } else {
      print("Login");
      emit(SplashScreenToLogin());
    }
  }
}
