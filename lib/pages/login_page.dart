import 'package:flutter/material.dart';
import 'package:flutter_app/pages/authentication_text_form_field.dart';
import 'package:flutter_app/pages/wave.dart';
import 'package:flutter_app/pages/main_page.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  bool register = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Wave(),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  AuthenticationTextFormField(
                    icon: Icons.email,
                    label: 'Email',
                    textEditingController: emailController,
                  ),
                  AuthenticationTextFormField(
                    icon: Icons.vpn_key,
                    label: 'Password',
                    textEditingController: passwordController,
                  ),
                  if (register == true)
                    AuthenticationTextFormField(
                      icon: Icons.password,
                      label: 'Password Confirmation',
                      textEditingController: passwordConfirmationController,
                    ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (register == false) {

                          // LOGIN → vai para MainPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainPage(),
                            ),
                          );
                        } else {
                          // REGISTER (se quiser tratar depois)
                          print('Registrar usuário');
                        }
                      }
                    },
                    child: Text(register == true ? 'Register' : 'Login'),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      setState(() => register = !register);
                      _formKey.currentState?.reset();
                    },
                    child: Text(
                      register == true ? 'Login instead' : 'Register instead',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}