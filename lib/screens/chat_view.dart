import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_bloc.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_event.dart';
import 'package:linerai/utils/constants.dart';
import 'package:linerai/widgets/quick_actions.dart';
import 'package:linerai/widgets/response_bubble.dart';
import 'package:linerai/widgets/typing_indicator.dart';
import 'package:linerai/data/ai_bloc_provider/ai_bloc.dart';
import 'package:linerai/data/ai_bloc_provider/ai_events.dart';
import 'package:linerai/data/ai_bloc_provider/ai_states.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AiBloc>().add(InitializeChatEvent());
    });
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
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleError(BuildContext context, AiState state) {
    if (state is AiErrorState || state is AiOfflineState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.errorMessage),
          
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiBloc, AiState>(
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        WidgetsBinding.instance.addPostFrameCallback((_) => _handleError(context, state));

        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.appName),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthEventLogout());
                },
                icon: Icon(Icons.logout),
              )
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
                    itemCount: state.messages.length + (state.isLoading ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (index < state.messages.length) {
                        final message = state.messages[index];
                        return ResponseBubble(
                          text: message.text,
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
                                curve: Curves.easeInOut);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(180, 210, 164, 255)
                                  .withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: QuickActions(onTap: (text) {
                          _controller.text = text;
                          context.read<AiBloc>().add(SendMessageEvent(text));
                          _controller.clear();
                        }),
                      ),
                      SizedBox(height: 0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 197, 131, 255)
                                  .withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(5),
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
                              onPressed: () {
                                final text = _controller.text;
                                if (text.isNotEmpty && text.length <= 200) {
                                  context
                                      .read<AiBloc>()
                                      .add(SendMessageEvent(text));
                                  _controller.clear();
                                }
                              },
                            ),
                          ),
                          onSubmitted: (text) {
                            final trimmedText = text.trim();
                            if (trimmedText.isNotEmpty &&
                                trimmedText.length <= 200) {
                              context
                                  .read<AiBloc>()
                                  .add(SendMessageEvent(trimmedText));
                              _controller.clear();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
