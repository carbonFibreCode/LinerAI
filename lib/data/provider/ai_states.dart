import 'package:equatable/equatable.dart';
import 'package:linerai/data/model/message.dart';
import 'package:linerai/utils/constants.dart';

/// Base state class for AI interactions
abstract class AiState extends Equatable {
  final List<Message> messages;
  final bool isLoading;
  final String? error;

  const AiState({
    required this.messages,
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [messages, isLoading, error];
}

/// Initial state when the app starts
class AiInitialState extends AiState {
  AiInitialState()
      : super(
          messages: [
            Message(
              text: AppStrings.defaultResponse,
              isUser: false,
            ),
          ],
        );
}

/// State while waiting for AI response
class AiLoadingState extends AiState {
  const AiLoadingState({required List<Message> messages})
      : super(
          messages: messages,
          isLoading: true,
        );
}

/// State when AI response is successful
class AiSuccessState extends AiState {
  const AiSuccessState({required List<Message> messages})
      : super(
          messages: messages,
          isLoading: false,
        );
}

/// State when an error occurs
class AiErrorState extends AiState {
  const AiErrorState({
    required List<Message> messages,
    required String errorMessage,
  }) : super(
          messages: messages,
          isLoading: false,
          error: errorMessage,
        );
}


/// State when network connection is lost
class AiOfflineState extends AiState {
  const AiOfflineState({required List<Message> messages})
      : super(
          messages: messages,
          isLoading: false,
          error: 'No internet connection',
        );
}