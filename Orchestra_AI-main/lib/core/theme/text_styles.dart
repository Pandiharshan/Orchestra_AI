// 🎨 Text styles — Aether theme
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Wordmark ─────────────────────────────────────────────────────
  static const wordmark = TextStyle(
    color: AppColors.textHigh,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );

  // ── Subtitle ─────────────────────────────────────────────────────
  static const subtitle = TextStyle(
    color: AppColors.textMid,
    fontSize: 13.5,
  );

  // ── Input label ──────────────────────────────────────────────────
  static TextStyle inputLabel({bool focused = false}) => TextStyle(
    color: focused ? AppColors.accentGoldL : AppColors.textMid,
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  // ── Input text ───────────────────────────────────────────────────
  static const inputText = TextStyle(
    color: AppColors.textHigh,
    fontSize: 13.5,
  );

  // ── Placeholder ──────────────────────────────────────────────────
  static const placeholder = TextStyle(
    color: AppColors.textLow,
    fontSize: 13.5,
  );

  // ── Button label ─────────────────────────────────────────────────
  static const buttonLabel = TextStyle(
    color: AppColors.logoInner,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  // ── Google button ────────────────────────────────────────────────
  static const googleBtn = TextStyle(
    color: AppColors.textHigh,
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
  );

  // ── Switch mode ──────────────────────────────────────────────────
  static const switchHint = TextStyle(
    color: AppColors.textMid,
    fontSize: 13,
  );

  static const switchAction = TextStyle(
    color: AppColors.accentGoldL,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  // ── Error ────────────────────────────────────────────────────────
  static const error = TextStyle(
    color: AppColors.errorRed,
    fontSize: 11,
  );

  // ── Or divider ───────────────────────────────────────────────────
  static const orDivider = TextStyle(
    color: AppColors.textLow,
    fontSize: 12,
  );

  // ── Remember me / Forgot ─────────────────────────────────────────
  static const rememberMe = TextStyle(
    color: AppColors.textMid,
    fontSize: 12.5,
  );

  static const forgotLink = TextStyle(
    color: AppColors.accentGold,
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
  );

  // ── Password strength ────────────────────────────────────────────
  static TextStyle strengthLabel(Color color) => TextStyle(
    color: color,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
}
