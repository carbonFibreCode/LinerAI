import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linerai/data/service/auth_service/auth_exceptions.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_bloc.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_event.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_state.dart';
import 'package:linerai/utils/constants.dart';
import 'package:linerai/utils/dialogs/error_dialog.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  @override
void initState() {
  _emailController = TextEditingController();
  _passwordController = TextEditingController();
  super.initState();
}

@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc,AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {


          if (state.exception != null) {
            if (state.exception is UserNotLoggedInAuthException) {
              await showErrorDialog(context, 'User not Logged In');
            } else if (state.exception is InvalidCredentialsAuthException) {
              await showErrorDialog(context, 'Invalid credentials');
            } else if (state.exception is ChannelErrorAuthException) {
              await showErrorDialog(context, 'Enter the Credentials');
            } else if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(context, 'Invalid email');
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(context, 'Authentication Error');
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.loginTitle),
        ),
        resizeToAvoidBottomInset: false,
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.welcomeBack,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    AppStrings.signInToContinue,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 40),
                  _buildTextField(
                    controller: _emailController,
                    hintText: AppStrings.emailHint,
                    icon: Icons.email,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordController,
                    hintText: AppStrings.passwordHint,
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  SizedBox(height: 24),
                  _buildLoginButton(context),
                  SizedBox(height: 16),
                  _buildSignUpPrompt(context),
                  _buildForgotPassword(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 197, 131, 255).withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(193, 213, 168, 255).withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          final email = _emailController.text;
          final password = _passwordController.text;
          context.read<AuthBloc>().add(AuthEventLogin(email: email, password: password));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            AppStrings.login,
            style: TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          context.read<AuthBloc>().add(AuthEventForgotPassword());
        },
        child: Text(AppStrings.forgotPassword),
      ),
    );
  }

  Widget _buildSignUpPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppStrings.noAccount),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(AuthEventShouldRegister());
          },
          child: Text(AppStrings.signUp),
        ),
      ],
    );
  }
}
