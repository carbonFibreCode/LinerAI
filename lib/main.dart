import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:linerai/app/theme.dart';
import 'package:linerai/screens/login_screen.dart';
import 'package:linerai/screens/signup_screen.dart';
import 'utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linerai/data/service/service/gemini_service.dart';
import 'package:linerai/screens/chat_screen.dart';
import 'package:linerai/data/provider/ai_bloc.dart';

import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final geminiService = GeminiService();

  runApp(
    BlocProvider(
      create: (context) => AiBloc(geminiService),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: appTheme,
      home: ChatScreen(),
      routes: {
        loginRoute: (context) =>  LoginScreen(),
        chatScreenRoute: (context) => ChatScreen(),
        signUpRoute: (context) => SignUpScreen(),
      },
    );
  }
}
