import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linerai/data/service/auth_service/auth_exceptions.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_bloc.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_event.dart';
import 'package:linerai/data/service/auth_service/bloc/auth_state.dart';
import 'package:linerai/utils/constants.dart';
import 'package:linerai/utils/dialogs/error_dialog.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _confirmPasswordController = TextEditingController();

  bool _isFormValid = false;

  bool _passwordsMatch = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'email already in use');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Enter valid email');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'failed to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.signUpTitle),
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
          child: Builder(builder: (context) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      AppStrings.createAccount,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      AppStrings.signUpPrompt,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    _buildTextField(
                      controller: _nameController,
                      hintText: AppStrings.nameHint,
                      icon: Icons.person,
                      onChanged: _validatePasswords,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      hintText: AppStrings.emailHint,
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: _validatePasswords,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: AppStrings.passwordHint,
                      icon: Icons.lock,
                      isPassword: true,
                      onChanged: _validatePasswords,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      hintText: AppStrings.confirmPassword,
                      icon: Icons.lock,
                      isPassword: true,
                      onChanged: _validatePasswords,
                    ),
                    if (!_passwordsMatch)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          AppStrings.passwordMismatch,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: 24),
                    _buildSignUpButton(context),
                    SizedBox(height: 16),
                    _buildLoginPrompt(context),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
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
        keyboardType: keyboardType,
        onChanged: onChanged,
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

  void _validatePasswords(String value) {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
      _isFormValid = _passwordsMatch &&
          _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  Widget _buildSignUpButton(BuildContext context) {
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
        onPressed: _isFormValid
            ? () {
                final email = _emailController.text;
                final password = _passwordController.text;
                context
                    .read<AuthBloc>()
                    .add(AuthEventRegister(email, password));
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            AppStrings.signUp,
            style: TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid ? AppColors.primary : Color.fromARGB(0, 125, 125, 125),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppStrings.alreadyHaveAccount),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(
                            const AuthEventLogout(),
                          );
          },
          child: Text(AppStrings.login),
        ),
      ],
    );
  }
}
