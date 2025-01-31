import 'package:equatable/equatable.dart';

/// Base event class for AI interactions
abstract class AiEvent extends Equatable {
  const AiEvent();

  @override
  List<Object?> get props => [];
}

/// Event when user sends a message
class SendMessageEvent extends AiEvent {
  final String message;
  final String userId;

  const SendMessageEvent(this.message, this.userId);

  @override
  List<Object?> get props => [message];
}

/// Event when checking network connectivity
class CheckConnectionEvent extends AiEvent {
  const CheckConnectionEvent();
}

/// Event when retrying after an error
// class RetryEvent extends AiEvent {
//   const RetryEvent();
// }

/// Event when initializing the chat
class InitializeChatEvent extends AiEvent {
  const InitializeChatEvent();
} 