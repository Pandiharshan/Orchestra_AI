import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';

class RememberMeCheckbox extends StatelessWidget {
  final bool checked;
  final ValueChanged<bool> onChanged;

  const RememberMeCheckbox({
    super.key,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onChanged(!checked),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: checked ? AppColors.accentGold : AppColors.bgInput,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: checked ? AppColors.accentGold : AppColors.bdNormal,
                  width: 0.5,
                ),
              ),
              alignment: Alignment.center,
              child: checked
                  ? const Icon(
                      Icons.check,
                      color: AppColors.logoInner,
                      size: 11,
                    )
                  : null,
            ),
            const SizedBox(width: 7),
            const Text(
              'Remember me',
              style: AppTextStyles.rememberMe,
            ),
          ],
        ),
      ),
    );
  }
}
