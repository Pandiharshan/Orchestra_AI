import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/auth_screen.dart';

// 🚀 Entry point — OrchestraAI (Windows)
void main() {
  runApp(const OrchestraApp());
}

class OrchestraApp extends StatelessWidget {
  const OrchestraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign in',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const AuthScreen(),
    );
  }
}
