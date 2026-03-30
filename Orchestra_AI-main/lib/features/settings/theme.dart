import 'package:flutter/material.dart';

// ─── Color Palette ────────────────────────────────────────────────────────────
class SettingsColors {
  static const navBg = Color(0xFF0F1117);
  static const navSelected = Color(0xFF1E2030);
  static const navAccent = Color(0xFF6C63FF);
  static const surfaceDark = Color(0xFF161820);
  static const cardDark = Color(0xFF1C1E2A);
  static const cardBorder = Color(0xFF2A2D3E);
  static const textPrimary = Color(0xFFF0F0F8);
  static const textSecondary = Color(0xFF8B8FA8);
  static const accentPurple = Color(0xFF6C63FF);
  static const accentCyan = Color(0xFF00D4FF);
  static const accentGreen = Color(0xFF00E5A0);
  static const accentAmber = Color(0xFFFFB547);
  static const accentRed = Color(0xFFFF6B6B);
  static const dividerColor = Color(0xFF252738);
}

// ─── Data Models ──────────────────────────────────────────────────────────────
class NavItem {
  final String label;
  final IconData icon;
  final String section;

  const NavItem(this.label, this.icon, this.section);
}

const List<NavItem> navItems = [
  NavItem("Appearance", Icons.palette_outlined, "appearance"),
  NavItem("AI Models", Icons.smart_toy_outlined, "ai"),
  NavItem("Notifications", Icons.notifications_none, "notifications"),
  NavItem("Storage", Icons.storage_outlined, "storage"),
];
