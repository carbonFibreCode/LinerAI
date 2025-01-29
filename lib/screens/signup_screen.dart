import 'package:flutter/material.dart';
import 'package:linerai/utils/constants.dart';

class SignUpScreen extends StatefulWidget {

  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _passwordsMatch = true;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Builder(
          builder: (context) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      AppStrings.createAccount,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      hintText: AppStrings.emailHint,
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: AppStrings.passwordHint,
                      icon: Icons.lock,
                      isPassword: true,
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
          }
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
      _passwordsMatch = _passwordController.text == _confirmPasswordController.text;
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
        onPressed: () {
          // TODO: Implement sign up logic
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            AppStrings.signUp,
            style: TextStyle(fontSize: 18,
            color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
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
            Navigator.pop(context);
          },
          child: Text(AppStrings.login),
        ),
      ],
    );
  }
}
