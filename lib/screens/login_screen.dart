import 'package:flutter/material.dart';
import 'package:linerai/utils/constants.dart';
import 'package:linerai/utils/routes.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Navigator.of(context).pushNamedAndRemoveUntil(
            chatScreenRoute,
            (route) => false,
          );
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
          // TODO: Implement forgot password logic
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
            Navigator.of(context).pushNamed(signUpRoute);
          },
          child: Text(AppStrings.signUp),
        ),
      ],
    );
  }
}
