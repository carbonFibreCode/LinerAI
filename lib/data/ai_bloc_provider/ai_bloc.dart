import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linerai/data/model/message.dart';
import 'package:linerai/data/ai_bloc_provider/ai_events.dart';
import 'package:linerai/data/ai_bloc_provider/ai_states.dart';
import 'package:linerai/data/service/ai_service/ai_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:linerai/data/service/auth_service/firebase_auth_provider.dart';
import 'package:linerai/data/service/cloud_service/firebase_cloud_storage.dart';

class AiBloc extends Bloc<AiEvent, AiState> {
  final AiService _aiService;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  AiBloc(this._aiService) : super(AiInitialState()) {
    on<InitializeChatEvent>(_onInitializeChat);
    on<SendMessageEvent>(_onSendMessage);
    on<CheckConnectionEvent>(_onCheckConnection);

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
      final List<Message> updatedMessages = List.from(state.messages)
        ..add(Message(text: event.message, isUser: true));

      String userId = FirebaseAuthProvider().currentUser!.id;

      await FirebaseCloudStorage().createMessage(
        ownerUserId: userId,
        userChat: event.message,
        aichat: null,
        isUser: true,
      );

      emit(AiLoadingState(messages: updatedMessages));

      final response =
          await _aiService.getResponse(event.message, event.userId);

      updatedMessages.add(Message(text: response, isUser: false));

      await FirebaseCloudStorage().createMessage(
        ownerUserId: userId,
        userChat: null,
        aichat: response,
        isUser: false,
      );

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

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
