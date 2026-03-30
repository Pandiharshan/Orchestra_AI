import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/app_config.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/auth_header.dart';
import '../widgets/social_login_button.dart';
import '../widgets/auth_input.dart';
import '../widgets/primary_button.dart';
import '../../dashboard/screens/dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback onSwitchToLogin;

  const SignupScreen({super.key, required this.onSwitchToLogin});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleSignup() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    if (mounted) setState(() => _isLoading = true);

    try {
      final res = await http.post(
        Uri.parse('${AppConfig.baseUrl}/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      if (mounted) {
        setState(() => _isLoading = false);
        if (res.statusCode == 200) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        } else {
          final error = jsonDecode(res.body)['detail'] ?? 'Signup failed';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), behavior: SnackBarBehavior.floating),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection error: $e'), behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  Widget _buildPasswordStrength() {
    final password = _passwordController.text;
    if (password.isEmpty) return const SizedBox.shrink();

    int strength = 0;
    if (password.length >= 6) strength = 1;
    if (password.length >= 10) strength = 2;
    if (password.contains(RegExp(r'[A-Z]')) && password.contains(RegExp(r'[0-9]'))) {
      if (strength == 2) {
        strength = 4;
      } else {
        strength = 3;
      }
    }

    final labels = ["", "Weak", "Fair", "Good", "Strong"];
    final colors = [
      Colors.transparent,
      AppColors.errorRed,
      AppColors.warnAmber,
      AppColors.okGreen,
      AppColors.strongGreen,
    ];

    final label = labels[strength];
    final color = colors[strength];

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    height: 3,
                    margin: EdgeInsets.only(right: index < 3 ? 6.0 : 0.0),
                    decoration: BoxDecoration(
                      color: index < strength ? color : AppColors.bdNormal,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: AppTextStyles.strengthLabel(color),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AuthHeader(title: 'Create your account'),
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
          label: 'Full name',
          placeholder: 'Jane Doe',
          controller: _nameController,
          leadingIcon: Icons.person_outline,
        ),
        const SizedBox(height: 12),
        AuthInput(
          label: 'Email address',
          placeholder: 'you@example.com',
          controller: _emailController,
          leadingIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        AuthInput(
          label: 'Password',
          placeholder: 'Min. 8 characters',
          controller: _passwordController,
          leadingIcon: Icons.lock_outline,
          isPassword: true,
          onChanged: (val) => setState(() {}),
        ),
        _buildPasswordStrength(),
        const SizedBox(height: 24),
        PrimaryButton(
          label: _isLoading ? 'Creating account...' : 'Create account',
          isLoading: _isLoading,
          onTap: _handleSignup,
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account? ", style: AppTextStyles.switchHint),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.onSwitchToLogin,
                child: const Text('Sign in', style: AppTextStyles.switchAction),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
