import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Your theme, constants, and other imports
import 'package:linerai/app/theme.dart';
import 'package:linerai/data/service/auth_service/firebase_auth_provider.dart';
import 'package:linerai/utils/constants.dart';

// AI Imports
import 'package:linerai/data/service/ai_service/gemini_service.dart';
import 'package:linerai/data/ai_bloc_provider/ai_bloc.dart';

// Auth Imports
import 'package:linerai/data/service/auth_service/bloc/auth_bloc.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_event.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_state.dart';

// Screens
import 'package:linerai/screens/chat_view.dart';
import 'package:linerai/screens/forgot_pass_view.dart';
import 'package:linerai/screens/login_view.dart';
import 'package:linerai/screens/signup_view.dart';
import 'package:linerai/screens/verify_email_view.dart';

// Your custom loading indicator
import 'package:linerai/widgets/loading_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final geminiService = GeminiService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AiBloc>(
          create: (context) => AiBloc(geminiService),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            FirebaseAuthProvider(),
          )..add(const AuthEventInitialize()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state.isLoading){
          LoadingIndicator().show(context,loadingText: state.loadingText ?? "Loading...");
        } else{
          LoadingIndicator().hide();
        }
      },
      builder: (context, state) {

        if (state is AuthStateLoggedIn) {
          return ChatScreen();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailScreen();
        } else if (state is AuthStateForgotPassword) {
          return ForgotPasswordScreen();
        } else if (state is AuthStateRegistering) {
          return SignUpScreen();
        } else if (state is AuthStateLoggedOut) {
          return LoginScreen();
        } else {
          // Covers AuthStateUninitialized or any unexpected state:
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

      },
    );
  }
}
