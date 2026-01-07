import 'package:flutter/material.dart';
import 'package:flutter_app/pages/login_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heartbeat App',
      theme: ThemeData( colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true),
      home: const AuthenticationScreen(),
    );
  }
}
