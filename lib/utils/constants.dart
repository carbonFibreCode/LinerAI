import 'dart:ui';

class AppStrings {
  static const appName = "One-Line Sunshine";
  static const defaultResponse =
      "Ask me for a joke, motivation, or anything! 🌞";
  static const loadingMessage = "Thinking of something uplifting... 🌼";
  static const errorMessage = "A little hiccup. Tap to retry! 🫶";
  static const hintText = "Ask for a joke, motivation... 🌻";
  static const loginTitle = "Sign-In";
  static const welcomeBack = "LinerAI";
  static const signInToContinue = "Sign-In to Continue";
  static const forgotPassword = "Forgot Password";
  static const noAccount = "Create Account";
  static const signUp = "Sign Up";

  // Auth Strings
  static const login = "Login";
  static const signup = "Sign Up";
  static const email = "Email";
  static const password = "Password";
  static const confirmPassword = "Confirm Password";
  static const loginPrompt = "Already have an account? Login";
  static const signupPrompt = "Don't have an account? Sign up";
  static const emailHint = "Enter your email";
  static const passwordHint = "Enter your password";
  static const confirmPasswordHint = "Confirm your password";
  static const authError = "Something went wrong. Please try again.";
  static const passwordMismatch = "Passwords don't match";
  static const invalidEmail = "Please enter a valid email";
  static const invalidPassword = "Password must be at least 6 characters";
  static const String logout = 'Logout';
  static const String logoutConfirmation = 'Are you sure you want to logout?';
  static const String cancel = 'Cancel';
  static const signUpTitle = "Sign-Up";
  static const createAccount = "Create Account";
  static const signUpPrompt = "Sign-Up to continue";
  static const nameHint = "Enter Full Name";
  static const alreadyHaveAccount = "Already have account?";
  static const String resetPassword = 'Reset Password';
  static const String resetPasswordInstructions =
      'Enter your email address and we\'ll send you a link to reset your password';
  static const String sendResetLink = 'Send Reset Link';
  static const String backToLogin = 'Back to Login';
  static const String verifyEmailTitle = 'Verify Email';
static const String verificationSentMessage = 'Verification Email Sent!';
static const String verificationInstructions = 'Please check your inbox';
static const String resendVerificationEmail = 'Resend Verification Email';
static const String verificationResent = 'Verification email resent successfully';
static const String verificationError = 'Error sending verification email';

}

//cloud storage constants

const aiChatFieldName = "ai_chat";
const userChatFieldName = "user_chat";
const ownerUserIdFieldName = "user_id";
const timeStampFieldName = "timestamp";
const isUserFieldName = "is_user";
class AppColors {
  static const primary = Color(0xFF6C5CE7);
  static const backgroundStart = Color(0xFFF8F9FA);
  static const backgroundEnd = Color(0xFFE9F5FF);
}
