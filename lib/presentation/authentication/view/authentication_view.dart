import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../shared/widgets/custom_textfield.dart';
import '../../../shared/widgets/error_message.dart';
import '../../../shared/widgets/password_textfield.dart';
import '../../grocery_list/view/grocery_list_view.dart';
import '../view_model/authentication_view_model.dart';

enum AuthMode { login, register }

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  final _loginForm = GlobalKey<FormState>();

  final viewModel = AuthenticationViewModel();
  bool isLoading = false;
  AuthMode mode = AuthMode.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _loginForm,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            mode == AuthMode.login ? 'Login' : 'Register',
                            style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      const SizedBox(height: 21),
                      Visibility(
                        visible: viewModel.errorMessage != '',
                        child: buildErrorMessage(
                            context, viewModel.errorMessage,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(bottom: 18)),
                      ),
                      CustomTextField(
                        viewModel.emailController,
                        labelText: 'Email',
                        required: true,
                        inputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return 'Please enter email.';
                          }
                          return null;
                        },
                      ),
                      PasswordTextField(viewModel.passwordController),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(top: 18.5),
                        child: ElevatedButton(
                            onPressed: () async {
                              // Pop keyboard from the screen
                              FocusScope.of(context).unfocus();

                              setState(() {
                                isLoading = true;
                              });

                              // Validate text fields
                              if (_loginForm.currentState!.validate()) {
                                if (mode == AuthMode.login) {
                                  await viewModel.login();
                                } else {
                                  await viewModel.register();
                                }

                                setState(() {
                                  isLoading = false;
                                });
                                if (viewModel.messageType ==
                                    AuthenticationMessageType.success) {
                                  viewModel
                                    ..errorMessage = ''
                                    ..messageType =
                                        AuthenticationMessageType.noMessage;

                                  if (!context.mounted) return;
                                  await Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GroceryListView()));
                                }
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                viewModel
                                  ..errorMessage = ''
                                  ..messageType =
                                      AuthenticationMessageType.noMessage;
                              }
                            },
                            child: Text(
                                mode == AuthMode.login ? 'LOGIN' : 'REGISTER')),
                      ),
                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (mode == AuthMode.login) {
                                mode = AuthMode.register;
                              } else {
                                mode = AuthMode.login;
                              }
                            });
                          },
                          child: Text(
                              mode == AuthMode.login ? 'Register' : 'Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .apply(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: isLoading,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
