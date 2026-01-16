import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/message.dart';
import '../repository/chat_repository.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  ChatLoaded(this.messages);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  ChatCubit(this.repository) : super(ChatInitial());

  Future<void> loadMessages(int apartmentId) async {
    emit(ChatLoading());
    try {
      final messages = await repository.getMessages(apartmentId);
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendMessage({
    required int toUserId,
    required int apartmentId,
    required String body,
  }) async {
    try {
      await repository.sendMessage(
        toUserId: toUserId,
        apartmentId: apartmentId,
        body: body,
      );
      await loadMessages(apartmentId);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> markMessagesAsRead(int apartmentId) async {
    try {
      await repository.markMessagesAsRead(apartmentId);
    } catch (e) {
      // Silent fail
    }
  }
}