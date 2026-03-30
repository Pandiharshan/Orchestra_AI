import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';

class AuthInput extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool isError;
  final IconData leadingIcon;
  final TextEditingController controller;
  final String? errorMessage;
  final ValueChanged<String>? onChanged;

  const AuthInput({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    required this.leadingIcon,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.isError = false,
    this.errorMessage,
    this.onChanged,
  });

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool _focused = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isError
        ? AppColors.errorRed
        : (_focused ? AppColors.bdFocus : AppColors.bdNormal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.inputLabel(focused: _focused),
        ),
        const SizedBox(height: 6),
        Focus(
          onFocusChange: (focus) {
            setState(() {
              _focused = focus;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgInput,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor, width: 0.5),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 10, top: 13, bottom: 13),
                  child: Icon(
                    widget.leadingIcon,
                    color: _focused ? AppColors.accentGold : AppColors.textLow,
                    size: 16,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    obscureText: widget.isPassword && _obscureText,
                    keyboardType: widget.keyboardType,
                    style: AppTextStyles.inputText,
                    cursorColor: AppColors.accentGold,
                    onChanged: widget.onChanged,
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: AppTextStyles.placeholder,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
                if (widget.isPassword)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 14, left: 8, top: 13, bottom: 13),
                        child: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textLow,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.isError && widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              widget.errorMessage!,
              style: AppTextStyles.error,
            ),
          ),
      ],
    );
  }
}
