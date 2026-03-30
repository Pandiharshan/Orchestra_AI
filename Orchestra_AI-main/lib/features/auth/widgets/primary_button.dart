import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [AppColors.accentGold, AppColors.accentBtn],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.logoInner),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Signing in...', // This can be overriden via a different label, but we just use the passed label
                      style: AppTextStyles.buttonLabel,
                    ),
                  ],
                )
              : Text(
                  label,
                  style: AppTextStyles.buttonLabel,
                ),
        ),
      ),
    );
  }
}
