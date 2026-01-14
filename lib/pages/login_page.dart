import 'package:flutter/material.dart';
import 'package:flutter_app/pages/authentication_text_form_field.dart';
import 'package:flutter_app/pages/wave.dart';
import 'package:flutter_app/pages/main_page.dart';
import '../services/auth_service.dart';


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
  final AuthService _authService = AuthService();
  bool register = false;
  bool isLoading = false;

  Future<void> _register(String email, String password, String confirmedPassword) async {
    setState(() => isLoading = true);

    try {
      final data = await _authService.register(
        email: email,
        password: password,
        confirmedPassword: confirmedPassword,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Registration successful! Please log in.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Switch to login mode
      setState(() => register = false);
      _formKey.currentState?.reset();
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _login(String email, String password) async {
    setState(() => isLoading = true);

    try {
      final data = await _authService.login(email, password);

      // Access token is in data['access_token'] if you need it
      // Navigate to MainPage after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red, // Make the SnackBar red
        behavior: SnackBarBehavior.floating, // Optional: makes it float above the UI
      ),
    );
  }

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
                  if (register)
                    AuthenticationTextFormField(
                      icon: Icons.password,
                      label: 'Password Confirmation',
                      textEditingController: passwordConfirmationController,
                    ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        if (register) {
                          _register(emailController.text, passwordController.text, passwordConfirmationController.text);

                        } else {

                          _login(emailController.text, passwordController.text);
                        }
                      }
                    },
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(register ? 'Register' : 'Login'),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      setState(() => register = !register);
                      _formKey.currentState?.reset();
                    },
                    child: Text(register ? 'Login instead' : 'Register instead'),
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
