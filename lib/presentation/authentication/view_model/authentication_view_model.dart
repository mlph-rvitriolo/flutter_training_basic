import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training_basic/services/firebase/authentication.dart';

enum AuthenticationMessageType { error, success, noMessage, fieldWarning }

class AuthenticationViewModel {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  AuthenticationMessageType messageType = AuthenticationMessageType.noMessage;

  final authService = Authentication(FirebaseAuth.instance);

  Future<void> login() async {
    final message =
        await authService.login(emailController.text, passwordController.text);
    errorMessage = message!;
    messageType = _messageType(message);
  }

  Future<void> register() async {
    final message = await authService.register(
        emailController.text, passwordController.text);
    errorMessage = message!;
    messageType = _messageType(message);
  }

  AuthenticationMessageType _messageType(String authMessage) {
    if (authMessage.contains('success')) {
      return AuthenticationMessageType.success;
    } else if (authMessage.contains('field-error')) {
      return AuthenticationMessageType.fieldWarning;
    } else {
      return AuthenticationMessageType.error;
    }
  }
}
