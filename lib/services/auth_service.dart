import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/configure_global.dart';

class AuthService {

  /// Login function
  /// Returns a Map with access_token, token_type, expires_in on success
  /// Throws an exception if login fails (401)
  Future<Map<String, dynamic>> login(String username, String password) async {

    const String baseUrl = ConfigureGlobal.apiBaseUrl;
    final url = Uri.parse('$baseUrl/api/auth/login');

    const String basicAuth = ConfigureGlobal.basicAuth;

    final response = await http.post(
      url,
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Successful login
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // Unauthorized
      throw Exception('Unauthorized: Invalid username or password.');
    } else {
      // Other errors
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  }

  /// Registers a new user
  /// Returns the API response as Map
  /// ThFuture<String>ation fails
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String confirmedPassword,
  }) async {
    const String baseUrl = ConfigureGlobal.apiBaseUrl;
    final url = Uri.parse('$baseUrl/api/Account/Register');

    const String basicAuth = ConfigureGlobal.basicAuth;

    final response = await http.post(
      url,
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'confirmedPassword': confirmedPassword,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success (201 Created or 200 OK)
      return {
        'email': email,
      };
    } else if (response.statusCode == 400) {
      // Bad request (validation error)
      throw Exception('Registration failed: ${response.body}');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid credentials for registration.');
    } else {
      throw Exception(
          'Failed to register. Status code: ${response.statusCode}');
    }
  }
}
