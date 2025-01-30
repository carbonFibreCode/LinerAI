import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_bloc.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_event.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_state.dart';
import 'package:linerai/utils/constants.dart';
import 'package:linerai/utils/dialogs/error_dialog.dart';
import 'package:linerai/utils/dialogs/password_reset_sent_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {

  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(

      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(context,
                'We could not process the request, please make sure you are a registered user');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.forgotPassword),
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Text(
                    AppStrings.resetPassword,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    AppStrings.resetPasswordInstructions,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  _buildEmailField(),
                  SizedBox(height: 24),
                  _buildSendResetButton(context),
                  SizedBox(height: 15),
                  _buildBackToLogin(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
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
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: AppStrings.emailHint,
          prefixIcon: Icon(Icons.email, color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSendResetButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(180, 210, 164, 255).withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          final email = _emailController.text;
          context.read<AuthBloc>().add(AuthEventForgotPassword(email:email));
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
            AppStrings.sendResetLink,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLogin(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<AuthBloc>().add(AuthEventLogout());
      },
      child: Text(
        AppStrings.backToLogin,
        style: TextStyle(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
