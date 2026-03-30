import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/settings_sidebar.dart';
import '../widgets/settings_sections.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _activeSection = "appearance";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SettingsColors.surfaceDark,
      body: Row(
        children: [
          // Sidebar
          SettingsSidebar(
            activeSection: _activeSection,
            onSectionChange: (section) {
              setState(() {
                _activeSection = section;
              });
            },
          ),

          // Divider
          Container(
            width: 1,
            color: SettingsColors.dividerColor,
          ),

          // Content Area
          Expanded(
            child: Container(
              color: SettingsColors.surfaceDark,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: KeyedSubtree(
                  key: ValueKey<String>(_activeSection),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_activeSection == "appearance") const AppearanceSection(),
                        if (_activeSection == "ai") const AIModelSection(),
                        if (_activeSection == "notifications") const NotificationsSection(),
                        if (_activeSection == "storage") const StorageSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
