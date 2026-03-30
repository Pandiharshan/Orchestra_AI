import 'package:flutter/material.dart';
import '../../../core/theme/text_styles.dart';
import '../widgets/auth_header.dart';
import '../widgets/social_login_button.dart';
import '../widgets/auth_input.dart';
import '../widgets/remember_me_checkbox.dart';
import '../widgets/primary_button.dart';
import '../widgets/auth_layout.dart';
import '../../dashboard/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSwitchToSignup;

  const LoginScreen({super.key, required this.onSwitchToSignup});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _emailError = false;

  void _handleLogin() async {
    if (_emailController.text.trim().isEmpty) {
      if (mounted) setState(() => _emailError = true);
      return;
    }
    if (mounted) {
      setState(() {
        _isLoading = true;
        _emailError = false;
      });
    }

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AuthHeader(title: 'Sign in to continue'),
        const SizedBox(height: 32),
        SocialLoginButton(onTap: () {}),
        const SizedBox(height: 20),
        Row(
          children: const [
            Expanded(child: Divider(color: Color(0xFF2C2F3D), thickness: 0.5)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('or', style: AppTextStyles.orDivider),
            ),
            Expanded(child: Divider(color: Color(0xFF2C2F3D), thickness: 0.5)),
          ],
        ),
        const SizedBox(height: 20),
        AuthInput(
          label: 'Email address',
          placeholder: 'you@example.com',
          controller: _emailController,
          leadingIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          isError: _emailError,
          errorMessage: 'Please enter a valid email',
          onChanged: (_) {
            if (_emailError) setState(() => _emailError = false);
          },
        ),
        const SizedBox(height: 12),
        AuthInput(
          label: 'Password',
          placeholder: '••••••••',
          controller: _passwordController,
          leadingIcon: Icons.lock_outline,
          isPassword: true,
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RememberMeCheckbox(
              checked: _rememberMe,
              onChanged: (val) => setState(() => _rememberMe = val),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {},
                child: const Text('Forgot password?', style: AppTextStyles.forgotLink),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: _isLoading ? 'Signing in...' : 'Sign in',
          isLoading: _isLoading,
          onTap: _handleLogin,
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account? ", style: AppTextStyles.switchHint),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.onSwitchToSignup,
                child: const Text('Create one', style: AppTextStyles.switchAction),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
