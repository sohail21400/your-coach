part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatEventLoadChat extends ChatEvent {}

class ChatEventSendMessage extends ChatEvent {
  final String message;

  const ChatEventSendMessage({required this.message});

  @override
  List<Object> get props => [message];
}
