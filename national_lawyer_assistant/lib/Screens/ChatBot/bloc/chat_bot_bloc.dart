import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_bot_event.dart';
part 'chat_bot_state.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  ChatBotBloc() : super(ChatBotInitial()) {
    on<ChatBotEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
