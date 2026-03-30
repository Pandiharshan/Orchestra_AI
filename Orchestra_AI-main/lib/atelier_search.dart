import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const AtelierApp());
}

// ─── Design Tokens ────────────────────────────────────────────────────────────
class AtelierTokens {
  // Colors
  static const Color surface = Color(0xFFFCF9F4);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFF0EDE9);
  static const Color surfaceContainerLow = Color(0xFFF5F2EE);
  static const Color primary = Color(0xFF7B535C);
  static const Color primaryContainer = Color(0xFFD8A7B1);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1C1C19);
  static const Color onSurfaceVariant = Color(0xFF504446);
  static const Color secondaryContainer = Color(0xFFFFc69C);
  static const Color onSecondaryContainer = Color(0xFF3D2000);
  static const Color outlineVariant = Color(0xFF504446);
  static const Color tertiary = Color(0xFF4A654D);

  // Typography
  static const String fontFamily = 'Manrope';

  static const TextStyle displayLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 56,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.12,
    color: onSurface,
    height: 1.1,
  );

  static const TextStyle titleLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: onSurface,
  );

  static const TextStyle titleMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    color: onSurface,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: onSurface,
    height: 1.6,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: onSurfaceVariant,
    height: 1.5,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: onSurfaceVariant,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.9,
    color: primary,
  );

  // Spacing (0.7rem base = 11.2px)
  static const double spacing1 = 4.0;
  static const double spacing2 = 8.0;
  static const double spacing3 = 11.2;
  static const double spacing4 = 16.0;
  static const double spacing5 = 20.0;
  static const double spacing6 = 22.4;
  static const double spacing8 = 28.0;
  static const double spacing10 = 35.0;
  static const double spacing12 = 44.8;

  // Radius
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusFull = 9999.0;

  // Elevation shadow
  static List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: const Color(0xFF1C1C19).withValues(alpha: 0.04),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: const Color(0xFF7B535C).withValues(alpha: 0.06),
      blurRadius: 64,
      offset: const Offset(0, 16),
    ),
  ];

  static List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: const Color(0xFF1C1C19).withValues(alpha: 0.03),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}

// ─── App ──────────────────────────────────────────────────────────────────────
class AtelierApp extends StatelessWidget {
  const AtelierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atelier — Global Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: AtelierTokens.fontFamily,
        scaffoldBackgroundColor: AtelierTokens.surface,
        colorScheme: const ColorScheme.light(
          primary: AtelierTokens.primary,
          surface: AtelierTokens.surface,
        ),
      ),
      home: const SearchOverlayDemo(),
    );
  }
}

// ─── Demo Host ────────────────────────────────────────────────────────────────
class SearchOverlayDemo extends StatefulWidget {
  const SearchOverlayDemo({super.key});

  @override
  State<SearchOverlayDemo> createState() => _SearchOverlayDemoState();
}

class _SearchOverlayDemoState extends State<SearchOverlayDemo> {
  bool _overlayOpen = false;

  void _openSearch() => setState(() => _overlayOpen = true);
  void _closeSearch() => setState(() => _overlayOpen = false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AtelierTokens.surface,
      body: Stack(
        children: [
          // ── Background page content ──
          _buildBackgroundPage(),

          // ── Overlay ──
          if (_overlayOpen)
            GlobalSearchOverlay(onClose: _closeSearch),
        ],
      ),
    );
  }

  Widget _buildBackgroundPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('The Modern Atelier',
              style: AtelierTokens.displayLg.copyWith(fontSize: 36)),
          const SizedBox(height: AtelierTokens.spacing6),
          Text('A bespoke digital workspace',
              style: AtelierTokens.bodyLg.copyWith(
                color: AtelierTokens.onSurfaceVariant,
              )),
          const SizedBox(height: AtelierTokens.spacing12),
          _SearchTriggerPill(onTap: _openSearch),
          const SizedBox(height: AtelierTokens.spacing4),
          Text('or press  ⌘K',
              style: AtelierTokens.labelMd.copyWith(
                color: AtelierTokens.onSurfaceVariant.withValues(alpha: 0.5),
              )),
        ],
      ),
    );
  }
}

// ─── Search Trigger Pill ──────────────────────────────────────────────────────
class _SearchTriggerPill extends StatefulWidget {
  final VoidCallback onTap;
  const _SearchTriggerPill({required this.onTap});

  @override
  State<_SearchTriggerPill> createState() => _SearchTriggerPillState();
}

class _SearchTriggerPillState extends State<_SearchTriggerPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
          padding: const EdgeInsets.symmetric(
            horizontal: AtelierTokens.spacing8,
            vertical: AtelierTokens.spacing4,
          ),
          decoration: BoxDecoration(
            color: AtelierTokens.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AtelierTokens.radiusFull),
            boxShadow: _hovered
                ? AtelierTokens.floatingShadow
                : AtelierTokens.subtleShadow,
            border: Border.all(
              color: AtelierTokens.outlineVariant.withValues(alpha: 0.10),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_rounded,
                  size: 16, color: AtelierTokens.primary.withValues(alpha: 0.7)),
              const SizedBox(width: AtelierTokens.spacing3),
              Text('Search everything…',
                  style: AtelierTokens.bodyMd.copyWith(
                    color: AtelierTokens.onSurfaceVariant.withValues(alpha: 0.6),
                  )),
              const SizedBox(width: AtelierTokens.spacing8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AtelierTokens.surfaceContainer,
                  borderRadius: BorderRadius.circular(AtelierTokens.radiusSm),
                ),
                child: Text('⌘K', style: AtelierTokens.labelMd),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Global Search Overlay ────────────────────────────────────────────────────
class GlobalSearchOverlay extends StatefulWidget {
  final VoidCallback onClose;
  const GlobalSearchOverlay({super.key, required this.onClose});

  @override
  State<GlobalSearchOverlay> createState() => _GlobalSearchOverlayState();
}

class _GlobalSearchOverlayState extends State<GlobalSearchOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _query = '';

  // ── Sample data ──────────────────────────────────────────────────────────
  final List<String> _recentSearches = [
    'Q3 campaign brief',
    'Brand identity assets',
    'Onboarding flow',
    'Design review notes',
  ];

  final List<_AISuggestion> _aiSuggestions = const [
    _AISuggestion(
      label: 'Unfinished tasks from last week',
      icon: Icons.auto_awesome_rounded,
    ),
    _AISuggestion(
      label: 'Files shared with your team',
      icon: Icons.auto_awesome_rounded,
    ),
    _AISuggestion(
      label: 'Projects nearing deadline',
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  final List<_SearchResult> _tasks = const [
    _SearchResult(
        title: 'Finalize typography system',
        subtitle: 'Design · Due tomorrow',
        tag: 'In Progress'),
    _SearchResult(
        title: 'Review client mood board',
        subtitle: 'Branding · Overdue',
        tag: 'Overdue'),
    _SearchResult(
        title: 'Write content for hero section',
        subtitle: 'Web · No due date',
        tag: 'Todo'),
  ];

  final List<_SearchResult> _projects = const [
    _SearchResult(
        title: 'Atelier Rebrand 2025',
        subtitle: '12 tasks · 4 members',
        tag: 'Active'),
    _SearchResult(
        title: 'Mobile App — Phase II',
        subtitle: '8 tasks · 2 members',
        tag: 'On Hold'),
  ];

  final List<_SearchResult> _files = const [
    _SearchResult(
        title: 'Brand_Guidelines_v3.pdf',
        subtitle: 'Uploaded 2 days ago · 4.2 MB',
        tag: 'PDF'),
    _SearchResult(
        title: 'Hero_Illustration_Final.fig',
        subtitle: 'Edited today · 18.1 MB',
        tag: 'Figma'),
    _SearchResult(
        title: 'Campaign_Assets.zip',
        subtitle: 'Uploaded last week · 102 MB',
        tag: 'Archive'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(begin: 0.97, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    Future.microtask(() => _focusNode.requestFocus());
    _searchController.addListener(() {
      setState(() => _query = _searchController.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (e) {
        if (e is KeyDownEvent &&
            e.logicalKey == LogicalKeyboardKey.escape) {
          _close();
        }
      },
      child: FadeTransition(
        opacity: _fadeAnim,
        child: _buildBackdrop(),
      ),
    );
  }

  Widget _buildBackdrop() {
    return GestureDetector(
      onTap: _close,
      child: Container(
        color: AtelierTokens.onSurface.withValues(alpha: 0.18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Center(
            child: GestureDetector(
              onTap: () {}, // prevent close when clicking modal
              child: ScaleTransition(
                scale: _scaleAnim,
                child: _buildPanel(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    final bool hasQuery = _query.trim().isNotEmpty;

    return Container(
      width: 680,
      constraints: const BoxConstraints(maxHeight: 640),
      decoration: BoxDecoration(
        color: AtelierTokens.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AtelierTokens.radiusXl + 4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C1C19).withValues(alpha: 0.10),
            blurRadius: 64,
            offset: const Offset(0, 24),
          ),
          BoxShadow(
            color: AtelierTokens.primary.withValues(alpha: 0.08),
            blurRadius: 120,
            offset: const Offset(0, 40),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AtelierTokens.radiusXl + 4),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSearchInput(),
              Container(
                height: 1,
                color: AtelierTokens.outlineVariant.withValues(alpha: 0.08),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    bottom: AtelierTokens.spacing6,
                  ),
                  child: hasQuery
                      ? _buildResults()
                      : _buildIdleState(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search Input ─────────────────────────────────────────────────────────
  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AtelierTokens.spacing6,
        vertical: AtelierTokens.spacing4,
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 20,
            color: _query.isNotEmpty
                ? AtelierTokens.primary
                : AtelierTokens.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(width: AtelierTokens.spacing4),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              style: AtelierTokens.titleMd.copyWith(
                fontWeight: FontWeight.w500,
                color: AtelierTokens.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Search tasks, projects, files…',
                hintStyle: AtelierTokens.titleMd.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AtelierTokens.onSurfaceVariant.withValues(alpha: 0.35),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              cursorColor: AtelierTokens.primary,
              cursorWidth: 1.5,
            ),
          ),
          if (_query.isNotEmpty)
            GestureDetector(
              onTap: () => _searchController.clear(),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AtelierTokens.surfaceContainer,
                    borderRadius:
                        BorderRadius.circular(AtelierTokens.radiusFull),
                  ),
                  child: Icon(Icons.close_rounded,
                      size: 12,
                      color: AtelierTokens.onSurfaceVariant.withValues(alpha: 0.6)),
                ),
              ),
            ),
          const SizedBox(width: AtelierTokens.spacing3),
          _buildEscapeChip(),
        ],
      ),
    );
  }

  Widget _buildEscapeChip() {
    return GestureDetector(
      onTap: _close,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AtelierTokens.surfaceContainer,
            borderRadius: BorderRadius.circular(AtelierTokens.radiusSm),
            border: Border.all(
              color: AtelierTokens.outlineVariant.withValues(alpha: 0.08),
            ),
          ),
          child: Text('ESC', style: AtelierTokens.labelMd),
        ),
      ),
    );
  }

  // ── Idle State ───────────────────────────────────────────────────────────
  Widget _buildIdleState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AtelierTokens.spacing6,
        AtelierTokens.spacing5,
        AtelierTokens.spacing6,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('RECENT SEARCHES', Icons.history_rounded),
          const SizedBox(height: AtelierTokens.spacing3),
          ..._recentSearches.map((s) => _buildRecentItem(s)),
          const SizedBox(height: AtelierTokens.spacing8),
          _buildAISuggestionsSection(),
        ],
      ),
    );
  }

  Widget _buildRecentItem(String text) {
    return _HoverableItem(
      onTap: () => _searchController.text = text,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 9,
          horizontal: AtelierTokens.spacing3,
        ),
        child: Row(
          children: [
            Icon(Icons.north_west_rounded,
                size: 13,
                color: AtelierTokens.onSurfaceVariant.withValues(alpha: 0.35)),
            const SizedBox(width: AtelierTokens.spacing3),
            Expanded(
              child: Text(text, style: AtelierTokens.bodyMd),
            ),
            Icon(Icons.close_rounded,
                size: 13,
                color: AtelierTokens.onSurfaceVariant.withValues(alpha: 0.25)),
          ],
        ),
      ),
    );
  }

  Widget _buildAISuggestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('AI SUGGESTIONS', Icons.auto_awesome_rounded),
        const SizedBox(height: AtelierTokens.spacing3),
        ..._aiSuggestions.map((s) => _buildAISuggestionItem(s)),
      ],
    );
  }

  Widget _buildAISuggestionItem(_AISuggestion suggestion) {
    return _HoverableItem(
      onTap: () => _searchController.text = suggestion.label,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 9,
          horizontal: AtelierTokens.spacing3,
        ),
        child: Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AtelierTokens.primary, AtelierTokens.primaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Icon(suggestion.icon,
                  size: 14, color: Colors.white),
            ),
            const SizedBox(width: AtelierTokens.spacing3),
            Expanded(
              child: Text(suggestion.label,
                  style: AtelierTokens.bodyMd.copyWith(
                    color: AtelierTokens.onSurface.withValues(alpha: 0.75),
                  )),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFF3E8EC),
                    Color(0xFFFDE8D8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(AtelierTokens.radiusFull),
              ),
              child: Text('AI',
                  style: AtelierTokens.labelSm.copyWith(fontSize: 9)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Results ──────────────────────────────────────────────────────────────
  Widget _buildResults() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AtelierTokens.spacing6,
        AtelierTokens.spacing5,
        AtelierTokens.spacing6,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultSection(
            label: 'TASKS',
            icon: Icons.check_circle_outline_rounded,
            results: _tasks,
            iconColor: AtelierTokens.tertiary,
          ),
          const SizedBox(height: AtelierTokens.spacing8),
          _buildResultSection(
            label: 'PROJECTS',
            icon: Icons.folder_open_rounded,
            results: _projects,
            iconColor: AtelierTokens.primary,
          ),
          const SizedBox(height: AtelierTokens.spacing8),
          _buildResultSection(
            label: 'FILES',
            icon: Icons.description_outlined,
            results: _files,
            iconColor: AtelierTokens.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection({
    required String label,
    required IconData icon,
    required List<_SearchResult> results,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(label, icon, iconColor: iconColor),
        const SizedBox(height: AtelierTokens.spacing3),
        ...results.map((r) => _buildResultItem(r, iconColor)),
      ],
    );
  }

  Widget _buildResultItem(_SearchResult result, Color accentColor) {
    return _HoverableItem(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 9,
          horizontal: AtelierTokens.spacing3,
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HighlightText(
                    text: result.title,
                    query: _query,
                    baseStyle: AtelierTokens.bodyLg.copyWith(
                      fontSize: 14,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(result.subtitle, style: AtelierTokens.bodyMd.copyWith(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: AtelierTokens.spacing3),
            _buildTag(result.tag, accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String tag, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AtelierTokens.radiusFull),
      ),
      child: Text(
        tag.toUpperCase(),
        style: AtelierTokens.labelMd.copyWith(
          color: color,
          fontSize: 9,
        ),
      ),
    );
  }

  // ── Shared ───────────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String label, IconData icon,
      {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon,
            size: 12,
            color:
                (iconColor ?? AtelierTokens.onSurfaceVariant).withValues(alpha: 0.5)),
        const SizedBox(width: 6),
        Text(label.toUpperCase(), style: AtelierTokens.labelMd),
        const SizedBox(width: AtelierTokens.spacing3),
        Expanded(
          child: Container(
            height: 1,
            color: AtelierTokens.outlineVariant.withValues(alpha: 0.07),
          ),
        ),
      ],
    );
  }
}

// ─── Hover Item ───────────────────────────────────────────────────────────────
class _HoverableItem extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _HoverableItem({required this.child, required this.onTap});

  @override
  State<_HoverableItem> createState() => _HoverableItemState();
}

class _HoverableItemState extends State<_HoverableItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _hovered
                ? AtelierTokens.primary.withValues(alpha: 0.04)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AtelierTokens.radiusMd),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ─── Highlight Text ───────────────────────────────────────────────────────────
class _HighlightText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle baseStyle;

  const _HighlightText({
    required this.text,
    required this.query,
    required this.baseStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) return Text(text, style: baseStyle);

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final idx = lowerText.indexOf(lowerQuery);

    if (idx < 0) return Text(text, style: baseStyle);

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          if (idx > 0) TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: text.substring(idx, idx + query.length),
            style: baseStyle.copyWith(
              color: AtelierTokens.primary,
              fontWeight: FontWeight.w700,
              backgroundColor: AtelierTokens.primaryContainer.withValues(alpha: 0.25),
            ),
          ),
          if (idx + query.length < text.length)
            TextSpan(text: text.substring(idx + query.length)),
        ],
      ),
    );
  }
}

// ─── Data Models ─────────────────────────────────────────────────────────────
class _SearchResult {
  final String title;
  final String subtitle;
  final String tag;
  const _SearchResult({
    required this.title,
    required this.subtitle,
    required this.tag,
  });
}

class _AISuggestion {
  final String label;
  final IconData icon;
  const _AISuggestion({required this.label, required this.icon});
}
