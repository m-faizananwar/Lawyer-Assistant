import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:national_lawyer_assistant/utils/sign_in_functions.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  ForgetPasswordBloc() : super(ForgetPasswordInitial()) {
    on<ForgetPasswordInitialEvent>(forgetPasswordInitialEvent);

    on<ForgetPasswordButtonPressedEvent>(forgetPasswordButtonPressedEvent);
  }

  FutureOr<void> forgetPasswordInitialEvent(
      ForgetPasswordInitialEvent event, Emitter<ForgetPasswordState> emit) {
    emit(ForgetPasswordLoaded());
  }

  FutureOr<void> forgetPasswordButtonPressedEvent(
      ForgetPasswordButtonPressedEvent event,
      Emitter<ForgetPasswordState> emit) async {
    emit(ForgetPasswordLoading());
    await Future.delayed(const Duration(seconds: 1));
    String response = await LoginFunctions.sendPasswordResetEmail(event.email);
    emit(ForgetPasswordError(message: response));
  }
}
