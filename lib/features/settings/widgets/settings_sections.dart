import 'package:flutter/material.dart';
import '../theme.dart';

// ─── Shared Components ────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accentColor;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.accentColor = SettingsColors.accentPurple,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: SettingsColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: SettingsColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class SettingsCard extends StatelessWidget {
  final Widget child;

  const SettingsCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: SettingsColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SettingsColors.cardBorder),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.only(bottom: 24),
      child: child,
    );
  }
}

class SettingsRow extends StatelessWidget {
  final String label;
  final String? description;
  final IconData? icon;
  final Color iconTint;
  final Widget trailing;

  const SettingsRow({
    super.key,
    required this.label,
    this.description,
    this.icon,
    this.iconTint = SettingsColors.accentPurple,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconTint.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconTint, size: 18),
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: SettingsColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (description != null)
                  Text(
                    description!,
                    style: const TextStyle(
                      color: SettingsColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class RowDivider extends StatelessWidget {
  const RowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: SettingsColors.dividerColor,
    );
  }
}

class NeatSwitch extends StatelessWidget {
  final bool checked;
  final ValueChanged<bool> onChanged;
  final Color accentColor;

  const NeatSwitch({
    super.key,
    required this.checked,
    required this.onChanged,
    this.accentColor = SettingsColors.accentPurple,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onChanged(!checked),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 24,
          decoration: BoxDecoration(
            color: checked ? accentColor : const Color(0xFF3A3D52),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: checked ? Alignment.centerRight : Alignment.centerLeft,
          padding: const EdgeInsets.all(2),
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── 1. Appearance Section ────────────────────────────────────────────────────

class AppearanceSection extends StatefulWidget {
  const AppearanceSection({super.key});

  @override
  State<AppearanceSection> createState() => _AppearanceSectionState();
}

class _AppearanceSectionState extends State<AppearanceSection> {
  bool isDark = true;
  bool systemSync = false;
  String uiStyle = "Fluent";
  final List<String> uiStyles = ["Fluent", "Minimal", "Compact", "Rounded"];

  IconData _getStyleIcon(String style) {
    switch (style) {
      case "Fluent":
        return Icons.blur_on;
      case "Minimal":
        return Icons.crop_square;
      case "Compact":
        return Icons.view_compact;
      default:
        return Icons.radio_button_checked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: "Appearance",
          subtitle: "Customize how the app looks and feels",
          accentColor: SettingsColors.accentPurple,
        ),
        SettingsCard(
          child: Column(
            children: [
              SettingsRow(
                label: "Dark Mode",
                description: "Switch between light and dark themes",
                icon: Icons.dark_mode_outlined,
                iconTint: SettingsColors.accentPurple,
                trailing: NeatSwitch(
                  checked: isDark,
                  onChanged: (val) => setState(() => isDark = val),
                  accentColor: SettingsColors.accentPurple,
                ),
              ),
              const RowDivider(),
              SettingsRow(
                label: "System Sync",
                description: "Follow the OS color scheme automatically",
                icon: Icons.sync,
                iconTint: SettingsColors.accentCyan,
                trailing: NeatSwitch(
                  checked: systemSync,
                  onChanged: (val) => setState(() => systemSync = val),
                  accentColor: SettingsColors.accentCyan,
                ),
              ),
            ],
          ),
        ),
        const Text(
          "UI STYLE",
          style: TextStyle(
            color: SettingsColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: uiStyles.map((style) {
            final selected = style == uiStyle;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: style != uiStyles.last ? 12 : 0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => setState(() => uiStyle = style),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: selected
                            ? SettingsColors.accentPurple.withValues(alpha: 0.15)
                            : SettingsColors.cardDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? SettingsColors.accentPurple : SettingsColors.cardBorder,
                          width: selected ? 1.5 : 1.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(
                            _getStyleIcon(style),
                            color: selected ? SettingsColors.accentPurple : SettingsColors.textSecondary,
                            size: 22,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            style,
                            style: TextStyle(
                              color: selected ? SettingsColors.textPrimary : SettingsColors.textSecondary,
                              fontSize: 12,
                              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─── 2. AI Model Section ──────────────────────────────────────────────────────

class AIModel {
  final String name;
  final String tag;
  final Color tagColor;
  final String description;
  final IconData icon;

  const AIModel(this.name, this.tag, this.tagColor, this.description, this.icon);
}

const aiModels = [
  AIModel("Nova Ultra", "Latest", SettingsColors.accentCyan, "Most capable, best for complex tasks", Icons.auto_awesome),
  AIModel("Nova Fast", "Fast", SettingsColors.accentGreen, "Optimized speed, great for quick tasks", Icons.speed),
  AIModel("Nova Compact", "Lite", SettingsColors.accentAmber, "Lightweight model for basic queries", Icons.memory),
];

class AIModelSection extends StatefulWidget {
  const AIModelSection({super.key});

  @override
  State<AIModelSection> createState() => _AIModelSectionState();
}

class _AIModelSectionState extends State<AIModelSection> {
  String selectedModel = "Nova Ultra";
  bool streaming = true;
  double temperature = 0.7;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: "AI Models",
          subtitle: "Choose the model powering your experience",
          accentColor: SettingsColors.accentCyan,
        ),
        Column(
          children: aiModels.map((model) {
            final isSelected = model.name == selectedModel;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => setState(() => selectedModel = model.name),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? model.tagColor.withValues(alpha: 0.08) : SettingsColors.cardDark,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? model.tagColor : SettingsColors.cardBorder,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: model.tagColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          alignment: Alignment.center,
                          child: Icon(model.icon, color: model.tagColor, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    model.name,
                                    style: const TextStyle(
                                      color: SettingsColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: model.tagColor.withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      model.tag,
                                      style: TextStyle(
                                        color: model.tagColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                model.description,
                                style: const TextStyle(color: SettingsColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Radio<String>(
                          value: model.name,
                          groupValue: selectedModel,
                          onChanged: (val) => setState(() => selectedModel = val!),
                          activeColor: model.tagColor,
                          fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return model.tagColor;
                            }
                            return SettingsColors.textSecondary;
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        SettingsCard(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.thermostat, color: SettingsColors.accentAmber, size: 18),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "Creativity (Temperature)",
                            style: TextStyle(color: SettingsColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          temperature.toStringAsFixed(1),
                          style: const TextStyle(color: SettingsColors.accentAmber, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      ),
                      child: Slider(
                        value: temperature,
                        onChanged: (val) => setState(() => temperature = val),
                        min: 0,
                        max: 1,
                        activeColor: SettingsColors.accentAmber,
                        inactiveColor: SettingsColors.cardBorder,
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Precise", style: TextStyle(color: SettingsColors.textSecondary, fontSize: 11)),
                        Text("Creative", style: TextStyle(color: SettingsColors.textSecondary, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const RowDivider(),
              SettingsRow(
                label: "Streaming Responses",
                description: "Show text as it's being generated",
                icon: Icons.bolt,
                iconTint: SettingsColors.accentGreen,
                trailing: NeatSwitch(
                  checked: streaming,
                  onChanged: (val) => setState(() => streaming = val),
                  accentColor: SettingsColors.accentGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── 3. Notifications Section ─────────────────────────────────────────────────

class NotificationsSection extends StatefulWidget {
  const NotificationsSection({super.key});

  @override
  State<NotificationsSection> createState() => _NotificationsSectionState();
}

class _NotificationsSectionState extends State<NotificationsSection> {
  bool allNotifs = true;
  bool taskComplete = true;
  bool errorAlerts = true;
  bool updates = false;
  bool sound = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: "Notifications",
          subtitle: "Control what alerts you receive and when",
          accentColor: SettingsColors.accentGreen,
        ),
        SettingsCard(
          child: SettingsRow(
            label: "All Notifications",
            description: "Enable or disable all system alerts",
            icon: Icons.notifications_active,
            iconTint: SettingsColors.accentGreen,
            trailing: NeatSwitch(
              checked: allNotifs,
              onChanged: (val) => setState(() => allNotifs = val),
              accentColor: SettingsColors.accentGreen,
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: allNotifs
              ? SettingsCard(
                  child: Column(
                    children: [
                      SettingsRow(
                        label: "Task Completed",
                        description: "Notify when AI finishes a long task",
                        icon: Icons.check_circle,
                        iconTint: SettingsColors.accentGreen,
                        trailing: NeatSwitch(
                          checked: taskComplete,
                          onChanged: (val) => setState(() => taskComplete = val),
                          accentColor: SettingsColors.accentGreen,
                        ),
                      ),
                      const RowDivider(),
                      SettingsRow(
                        label: "Error Alerts",
                        description: "Notify on failures or connection issues",
                        icon: Icons.error,
                        iconTint: SettingsColors.accentRed,
                        trailing: NeatSwitch(
                          checked: errorAlerts,
                          onChanged: (val) => setState(() => errorAlerts = val),
                          accentColor: SettingsColors.accentRed,
                        ),
                      ),
                      const RowDivider(),
                      SettingsRow(
                        label: "Product Updates",
                        description: "New features and release announcements",
                        icon: Icons.new_releases,
                        iconTint: SettingsColors.accentAmber,
                        trailing: NeatSwitch(
                          checked: updates,
                          onChanged: (val) => setState(() => updates = val),
                          accentColor: SettingsColors.accentAmber,
                        ),
                      ),
                      const RowDivider(),
                      SettingsRow(
                        label: "Sound Effects",
                        description: "Play audio cues with notifications",
                        icon: Icons.volume_up,
                        iconTint: SettingsColors.accentCyan,
                        trailing: NeatSwitch(
                          checked: sound,
                          onChanged: (val) => setState(() => sound = val),
                          accentColor: SettingsColors.accentCyan,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ─── 4. Storage Section ───────────────────────────────────────────────────────

class StorageSection extends StatelessWidget {
  const StorageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: "Storage",
          subtitle: "Manage local cache, history, and data",
          accentColor: SettingsColors.accentAmber,
        ),
        SettingsCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Storage Usage", style: TextStyle(color: SettingsColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                    Text("3.8 GB / 10 GB", style: TextStyle(color: SettingsColors.textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(flex: 22, child: Container(height: 10, decoration: const BoxDecoration(color: SettingsColors.accentPurple, borderRadius: BorderRadius.horizontal(left: Radius.circular(5))))),
                    Expanded(flex: 16, child: Container(height: 10, color: SettingsColors.accentCyan)),
                    Expanded(flex: 10, child: Container(height: 10, color: SettingsColors.accentAmber)),
                    Expanded(flex: 52, child: Container(height: 10, decoration: const BoxDecoration(color: Color(0xFF2A2D3E), borderRadius: BorderRadius.horizontal(right: Radius.circular(5))))),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StorageLegend(label: "Chat History", value: "2.2 GB", color: SettingsColors.accentPurple),
                    StorageLegend(label: "AI Cache", value: "1.6 GB", color: SettingsColors.accentCyan),
                    StorageLegend(label: "Attachments", value: "0.9 GB", color: SettingsColors.accentAmber),
                  ],
                ),
              ],
            ),
          ),
        ),
        SettingsCard(
          child: Column(
            children: [
              StorageActionRow(
                label: "Clear AI Response Cache",
                description: "Remove cached model responses (1.6 GB)",
                icon: Icons.cleaning_services,
                iconTint: SettingsColors.accentCyan,
                buttonLabel: "Clear",
                buttonColor: SettingsColors.accentCyan,
              ),
              const RowDivider(),
              StorageActionRow(
                label: "Delete Old Chat History",
                description: "Chats older than 30 days (2.2 GB)",
                icon: Icons.history,
                iconTint: SettingsColors.accentPurple,
                buttonLabel: "Delete",
                buttonColor: SettingsColors.accentPurple,
              ),
              const RowDivider(),
              StorageActionRow(
                label: "Remove All Attachments",
                description: "Uploaded files and media (0.9 GB)",
                icon: Icons.attach_file,
                iconTint: SettingsColors.accentAmber,
                buttonLabel: "Remove",
                buttonColor: SettingsColors.accentAmber,
              ),
              const RowDivider(),
              StorageActionRow(
                label: "Factory Reset",
                description: "Erase all app data and settings",
                icon: Icons.delete_forever,
                iconTint: SettingsColors.accentRed,
                buttonLabel: "Reset",
                buttonColor: SettingsColors.accentRed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StorageLegend extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StorageLegend({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: SettingsColors.textSecondary, fontSize: 11)),
            Text(value, style: const TextStyle(color: SettingsColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}

class StorageActionRow extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final Color iconTint;
  final String buttonLabel;
  final Color buttonColor;

  const StorageActionRow({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.iconTint,
    required this.buttonLabel,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconTint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconTint, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: SettingsColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                Text(description, style: const TextStyle(color: SettingsColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: buttonColor.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: buttonColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  buttonLabel,
                  style: TextStyle(
                    color: buttonColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
