import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Subtle radial glow top-right
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08 - 600,
            right: MediaQuery.of(context).size.width * 0.15 - 600,
            child: Container(
              width: 1200,
              height: 1200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.glowGoldHi, Colors.transparent],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
          // Subtle radial glow bottom-left
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.08 - 400,
            left: MediaQuery.of(context).size.width * 0.1 - 400,
            child: Container(
              width: 800,
              height: 800,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.glowGoldLo, Colors.transparent],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
          // Content
          Center(
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.bdNormal, width: 0.5), // Fallback border
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  )
                ],
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
