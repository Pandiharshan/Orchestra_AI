import 'package:flutter/material.dart';
import '../theme.dart';

class SettingsSidebar extends StatelessWidget {
  final String activeSection;
  final ValueChanged<String> onSectionChange;

  const SettingsSidebar({
    super.key,
    required this.activeSection,
    required this.onSectionChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: SettingsColors.navBg,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [SettingsColors.accentPurple, SettingsColors.accentCyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.settings, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                "Settings",
                style: TextStyle(
                  color: SettingsColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              "PREFERENCES",
              style: TextStyle(
                color: SettingsColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Navigation Items
          for (var item in navItems)
            NavRow(
              item: item,
              isActive: activeSection == item.section,
              onClick: () => onSectionChange(item.section),
            ),

          const Spacer(),

          // Bottom Version Tag
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "v2.4.1  ·  Build 240328",
              style: TextStyle(
                color: SettingsColors.textSecondary.withValues(alpha: 0.5),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavRow extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onClick;

  const NavRow({
    super.key,
    required this.item,
    required this.isActive,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isActive ? SettingsColors.navSelected : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Accent bar
              if (isActive) ...[
                Container(
                  width: 3,
                  height: 16,
                  decoration: BoxDecoration(
                    color: SettingsColors.navAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Icon(
                item.icon,
                color: isActive ? SettingsColors.accentPurple : SettingsColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                item.label,
                style: TextStyle(
                  color: isActive ? SettingsColors.textPrimary : SettingsColors.textSecondary,
                  fontSize: 13.5,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
