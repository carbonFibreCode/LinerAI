import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_bloc.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_event.dart';
import 'package:linerai/data/service/auth_service/firebase_auth_provider.dart';
import 'package:linerai/data/service/cloud_service/chat_model.dart';
import 'package:linerai/data/service/cloud_service/firebase_cloud_storage.dart';
import 'package:linerai/utils/constants.dart';
import 'package:linerai/widgets/quick_actions.dart';
import 'package:linerai/widgets/response_bubble.dart';
import 'package:linerai/widgets/typing_indicator.dart';
import 'package:linerai/data/ai_bloc_provider/ai_bloc.dart';
import 'package:linerai/data/ai_bloc_provider/ai_events.dart';
import 'package:linerai/data/ai_bloc_provider/ai_states.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  final userId = FirebaseAuthProvider().currentUser!.id;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
  if (_scrollController.hasClients) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<ChatMessage>>(
      stream: FirebaseCloudStorage().allChats(ownerUserId: userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error occurred: ${snapshot.error}'));
        }

        final messages = snapshot.data?.toList() ?? [];
        final reversedMessages = messages.reversed.toList();
        //for new messages scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());


        return BlocBuilder<AiBloc, AiState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.appName),
                actions: [
                  IconButton(
                    onPressed: () => context.read<AuthBloc>().add(const AuthEventLogout()),
                    icon: const Icon(Icons.logout),
                  ),
                ],
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 223, 239, 255),
                      AppColors.backgroundEnd
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: reversedMessages.length + (state.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < reversedMessages.length) {
                            final message = reversedMessages[index];
                            return ResponseBubble(
                              text: message.isUser ? message.userChats : message.aiChats,
                              isUser: message.isUser,
                            );
                          } else {
                            return TypingIndicator()
                                .animate()
                                .fadeIn(duration: 300.ms)
                                .slideY(
                                  begin: 0.2,
                                  end: 0,
                                  duration: 300.ms,
                                  curve: Curves.easeInOut,
                                );
                          }
                        },
                      ),
                    ),
                    _buildInputSection(context),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(180, 210, 164, 255).withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: QuickActions(
              onTap: (text) {
                _controller.text = text;
                context.read<AiBloc>().add(SendMessageEvent(text, userId));
                _controller.clear();
              },
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 197, 131, 255).withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(5),
            child: TextField(
              maxLength: 200,
              controller: _controller,
              decoration: InputDecoration(
                hintText: AppStrings.hintText,
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: AppColors.primary),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    final trimmedText = text.trim();
    if (trimmedText.isNotEmpty && trimmedText.length <= 200) {
      context.read<AiBloc>().add(SendMessageEvent(trimmedText, userId));
      _controller.clear();
    }
  }
}
