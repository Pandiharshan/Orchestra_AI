import 'package:flutter/material.dart';
import '../widgets/auth_layout.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      // Using AnimatedSize and AnimatedSwitcher to create a smooth transition
      child: AnimatedSize(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            // Emulate slide + fade
            final isLoginWidget = child is LoginScreen;
            final isEntering = animation.status == AnimationStatus.forward;
            
            // Slide magnitude
            final offset = isLoginWidget ? -20.0 : 20.0;
            
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, offset / 400.0), // Relative to screen/card height
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _isLogin
              ? LoginScreen(
                  key: const ValueKey('login'),
                  onSwitchToSignup: () => setState(() => _isLogin = false),
                )
              : SignupScreen(
                  key: const ValueKey('signup'),
                  onSwitchToLogin: () => setState(() => _isLogin = true),
                ),
        ),
      ),
    );
  }
}
