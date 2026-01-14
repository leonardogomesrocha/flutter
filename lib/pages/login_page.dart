import 'package:flutter/material.dart';
import 'package:flutter_app/pages/authentication_text_form_field.dart';
import 'package:flutter_app/pages/wave.dart';
import 'package:flutter_app/pages/main_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool register = false;
  bool isLoading = false;

  // --- Login Service Call ---
  Future<void> _login(String email, String password) async {
    setState(() => isLoading = true);

    const String basicAuth = 'Basic YXBpdXNlcjoxMjM0NTY=';
    final url = Uri.parse('https://sport-api-914604082584.us-central1.run.app/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'username': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Access token available as data['access_token']
        // Navigate to MainPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else if (response.statusCode == 401) {
        _showError('Invalid email or password.');
      } else {
        _showError('Login failed. Please try again later.');
      }
    } catch (e) {
      _showError('An error occurred: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
                        if (!register) {
                          _login(emailController.text, passwordController.text);
                        } else {
                          print('Register user flow');
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
