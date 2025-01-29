import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linerai/data/model/message.dart';
import 'package:linerai/data/provider/ai_events.dart';
import 'package:linerai/data/provider/ai_states.dart';
import 'package:linerai/data/service/service/ai_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AiBloc extends Bloc<AiEvent, AiState> {
  final AiService _aiService;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  AiBloc(this._aiService) : super(AiInitialState()) {
    on<InitializeChatEvent>(_onInitializeChat);
    on<SendMessageEvent>(_onSendMessage);
    on<CheckConnectionEvent>(_onCheckConnection);
    on<RetryEvent>(_onRetry);

    // Initialize connectivity monitoring
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        if (results.contains(ConnectivityResult.none)) {
          add(CheckConnectionEvent());
        }
      },
    );
  }

  Future<void> _onInitializeChat(
    InitializeChatEvent event,
    Emitter<AiState> emit,
  ) async {
    emit(AiInitialState());
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<AiState> emit,
  ) async {
    try {
      // Add user message to the list
      final List<Message> updatedMessages = List.from(state.messages)
        ..add(Message(text: event.message, isUser: true));
      
      // Show loading state
      emit(AiLoadingState(messages: updatedMessages));

      // Get AI response
      final response = await _aiService.getResponse(event.message);
      
      // Add AI response to messages
      updatedMessages.add(Message(text: response, isUser: false));
      
      // Update state with new messages
      emit(AiSuccessState(messages: updatedMessages));
    } catch (e) {
      emit(AiErrorState(
        messages: state.messages,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCheckConnection(
    CheckConnectionEvent event,
    Emitter<AiState> emit,
  ) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit(AiOfflineState(messages: state.messages));
    }
  }

  Future<void> _onRetry(
    RetryEvent event,
    Emitter<AiState> emit,
  ) async {
    if (state is AiErrorState || state is AiOfflineState) {
      // Reset to success state with current messages
      emit(AiSuccessState(messages: state.messages));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
} 