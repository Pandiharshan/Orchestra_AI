import 'package:flutter/material.dart';
import 'dart:math' as math;

// ── Dark palette ───────────────────────────────────────
class _C {
  static const bg       = Color(0xFF0B0C10);
  static const surface  = Color(0xFF111318);
  static const surface2 = Color(0xFF161820);
  static const border   = Color(0xFF1E2028);
  static const border2  = Color(0xFF252830);
  static const text     = Color(0xFFE2E0D8);
  static const muted    = Color(0xFF5A5C68);
  static const muted2   = Color(0xFF3A3C48);
  static const accent   = Color(0xFF00E5A0);
  static const accentDim= Color(0xFF001F15);
  static const accent2  = Color(0xFF005C40);
  static const amber    = Color(0xFFF5A623);
  static const amberDim = Color(0xFF2A1E06);
  static const blue     = Color(0xFF3D9FFF);
  static const blueDim  = Color(0xFF071B30);
  static const red      = Color(0xFFFF5C5C);
  static const redDim   = Color(0xFF2A0F0F);
}

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  int _period = 1; // 0=Day 1=Week 2=Month 3=Year
  late AnimationController _animCtrl;
  late Animation<double> _anim;

  final _weekData = [
    {'day': 'MON', 'tasks': 18, 'ai': 320, 'focus': 6.2},
    {'day': 'TUE', 'tasks': 24, 'ai': 410, 'focus': 7.0},
    {'day': 'WED', 'tasks': 15, 'ai': 580, 'focus': 5.1},
    {'day': 'THU', 'tasks': 28, 'ai': 390, 'focus': 8.2},
    {'day': 'FRI', 'tasks': 22, 'ai': 445, 'focus': 6.8},
    {'day': 'SAT', 'tasks': 10, 'ai': 210, 'focus': 3.2},
    {'day': 'SUN', 'tasks': 5,  'ai': 125, 'focus': 1.5},
  ];

  // Chart data
  final _tasksCompleted = [18, 24, 15, 28, 22, 10, 5];
  final _tasksPlanned   = [22, 26, 20, 30, 25, 12, 8];
  final _aiQueries      = [320, 410, 580, 390, 445, 210, 125];
  final _aiTokens       = [48, 62, 95, 58, 70, 32, 18];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutQuart);
    _animCtrl.forward();
  }

  @override void dispose() { _animCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _C.bg,
    body: Column(children: [
      _titleBar(),
      Expanded(child: Row(children: [
        _sideNav(),
        Expanded(child: Column(children: [
          _topBar(),
          Expanded(child: _content()),
        ])),
      ])),
    ]),
  );

  // ── Title Bar ───────────────────────────────────────
  Widget _titleBar() => Container(
    height: 34,
    decoration: const BoxDecoration(color: Color(0xFF0D0E12), border: Border(bottom: BorderSide(color: _C.border, width: 0.5))),
    child: Row(children: [
      const SizedBox(width: 14),
      _dot(const Color(0xFFFF5F57)), const SizedBox(width: 8),
      _dot(const Color(0xFFFEBC2E)), const SizedBox(width: 8),
      _dot(const Color(0xFF28C840)),
      const SizedBox(width: 10),
      Text('NEXUS — ANALYTICS', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: _C.muted.withValues(alpha: 0.7), letterSpacing: 0.06)),
      const Spacer(),
      Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: _C.accent,
        boxShadow: [BoxShadow(color: _C.accent.withValues(alpha: 0.5), blurRadius: 6)])),
      const SizedBox(width: 10),
      StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (_, __) {
          final now = DateTime.now();
          return Text('${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}:${now.second.toString().padLeft(2,'0')}',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: _C.muted));
        }),
      const SizedBox(width: 14),
    ]),
  );

  Widget _dot(Color c) => Container(width: 11, height: 11, decoration: BoxDecoration(color: c, shape: BoxShape.circle));

  // ── Side Nav ────────────────────────────────────────
  Widget _sideNav() => Container(
    width: 58, color: const Color(0xFF0D0E12),
    decoration: const BoxDecoration(border: Border(right: BorderSide(color: _C.border, width: 0.5))),
    child: Column(children: [
      const SizedBox(height: 16),
      Container(width: 34, height: 34, margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: _C.accent, borderRadius: BorderRadius.circular(9)),
        child: const Center(child: Text('▲', style: TextStyle(fontSize: 14, color: _C.bg, fontWeight: FontWeight.w700)))),
      _SNBtn(Icons.grid_view_rounded, false),
      _SNBtn(Icons.show_chart_rounded, true),
      _SNBtn(Icons.check_box_outlined, false),
      _SNBtn(Icons.help_outline_rounded, false),
      Container(height: 0.5, width: 30, color: _C.border, margin: const EdgeInsets.symmetric(vertical: 6)),
      _SNBtn(Icons.settings_outlined, false),
      const Spacer(),
      Container(width: 30, height: 30, margin: const EdgeInsets.only(bottom: 12),
        decoration: const BoxDecoration(shape: BoxShape.circle, color: _C.accent),
        child: const Center(child: Text('AJ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _C.bg)))),
    ]),
  );

  // ── Top Bar ─────────────────────────────────────────
  Widget _topBar() => Container(
    height: 52,
    decoration: const BoxDecoration(color: _C.surface, border: Border(bottom: BorderSide(color: _C.border, width: 0.5))),
    padding: const EdgeInsets.symmetric(horizontal: 22),
    child: Row(children: [
      const Text('ANALYTICS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 0.06, color: _C.text)),
      const SizedBox(width: 8),
      const Text('Workspace performance overview', style: TextStyle(fontSize: 12, color: _C.muted, fontWeight: FontWeight.w300)),
      const Spacer(),
      ...['DAY', 'WEEK', 'MONTH', 'YEAR'].asMap().entries.map((e) =>
        _PeriodTab(label: e.value, active: _period == e.key, onTap: () => setState(() => _period = e.key))),
      const SizedBox(width: 6),
      _TBAction(label: 'Export', icon: Icons.download_rounded),
      const SizedBox(width: 6),
      _TBAction(label: 'Live', icon: Icons.schedule_rounded),
    ]),
  );

  // ── Content Grid ────────────────────────────────────
  Widget _content() => SingleChildScrollView(
    padding: const EdgeInsets.all(18),
    child: Column(children: [
      // Row 1: Score + Stats + Insights
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Score card
        Expanded(flex: 2, child: _scoreCard()),
        const SizedBox(width: 14),
        // Stats row
        Expanded(flex: 4, child: Row(children: [
          Expanded(child: _statCard('Tasks Done', '142', _C.accent, 0.78, '+8.3%', true)),
          const SizedBox(width: 10),
          Expanded(child: _statCard('AI Queries', '2,480', _C.blue, 0.64, '+22.1%', true)),
          const SizedBox(width: 10),
          Expanded(child: _statCard('Focus Hours', '38.5', _C.amber, 0.55, '-4.2%', false)),
        ])),
        const SizedBox(width: 14),
        // Insights
        Expanded(flex: 3, child: _insightsCard()),
      ]),
      const SizedBox(height: 14),
      // Row 2: Charts
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _barChartCard()),
        const SizedBox(width: 14),
        Expanded(child: _lineChartCard()),
      ]),
      const SizedBox(height: 14),
      // Row 3: Weekly + Monthly
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _weeklyCard()),
        const SizedBox(width: 14),
        Expanded(child: _monthlyCard()),
      ]),
    ]),
  );

  // ── Score Card ──────────────────────────────────────
  Widget _scoreCard() => _card(child: Row(children: [
    SizedBox(width: 80, height: 80,
      child: AnimatedBuilder(animation: _anim,
        builder: (_, __) => CustomPaint(
          painter: _RingPainter(0.87 * _anim.value),
          child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('87', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _C.accent, height: 1)),
            Text('SCORE', style: TextStyle(fontSize: 9, color: _C.muted, letterSpacing: 0.06)),
          ]))))),
    const SizedBox(width: 16),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('PRODUCTIVITY SCORE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: _C.muted)),
      const SizedBox(height: 4),
      const Text('Excellent', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 0.04, color: _C.text, height: 1)),
      const SizedBox(height: 4),
      const Text('+12 pts vs last week', style: TextStyle(fontSize: 11, color: _C.muted, fontWeight: FontWeight.w300)),
      const SizedBox(height: 8),
      _delta('▲ 16.0%', true),
    ])),
  ]));

  // ── Stat Card ───────────────────────────────────────
  Widget _statCard(String label, String value, Color color, double fill, String delta, bool up) => _card(
    padding: const EdgeInsets.all(13),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, color: _C.muted, letterSpacing: 0.08, fontWeight: FontWeight.w500)),
      const SizedBox(height: 5),
      Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: 0.04, color: color, height: 1)),
      const SizedBox(height: 8),
      ClipRRect(borderRadius: BorderRadius.circular(2),
        child: AnimatedBuilder(animation: _anim,
          builder: (_, __) => LinearProgressIndicator(
            value: fill * _anim.value, minHeight: 3,
            backgroundColor: _C.border2, color: color))),
      const SizedBox(height: 6),
      _delta(delta, up),
    ]));

  Widget _delta(String text, bool up) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: up ? _C.accentDim : _C.redDim,
      borderRadius: BorderRadius.circular(20)),
    child: Text(text, style: TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.w500,
      color: up ? _C.accent : _C.red)));

  // ── Insights Card ───────────────────────────────────
  Widget _insightsCard() => _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [
      const Text('INSIGHTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: _C.muted)),
      const Spacer(),
      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: _C.accentDim, borderRadius: BorderRadius.circular(20)),
        child: const Text('4 new', style: TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.w500, color: _C.accent))),
    ]),
    const SizedBox(height: 14),
    _insightItem('● Suggestion', 'Your peak focus window is 9–11 AM. Schedule deep work tasks during this window for best output.', 'Based on 30-day pattern', _C.accentDim, _C.accent),
    _insightItem('● Watch', 'AI token usage spiked 44% on Wed. Consider batching requests to reduce redundancy.', 'Wednesday — 3 days ago', _C.amberDim, _C.amber),
    _insightItem('● Alert', 'Focus hours dropped 4.2%. Three meetings ran overtime this week, cutting deep work time.', 'This week vs last week', _C.redDim, _C.red),
    _insightItem('● Insight', 'Task completion rate improved when using AI-assisted drafts. Completion time ↓ 18 min avg.', 'Code + Writing modes', _C.blueDim, _C.blue),
    const Divider(color: _C.border, height: 24),
    SizedBox(width: double.infinity, child: _ViewAllBtn()),
  ]));

  Widget _insightItem(String tag, String text, String meta, Color tagBg, Color tagColor) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(border: Border.all(color: _C.border, width: 0.5), borderRadius: BorderRadius.circular(8)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2), margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(20)),
        child: Text(tag, style: TextStyle(fontFamily: 'monospace', fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.06, color: tagColor))),
      Text(text, style: const TextStyle(fontSize: 12, color: _C.text, lineHeight: 1.5, fontWeight: FontWeight.w300)),
      const SizedBox(height: 4),
      Text(meta, style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: _C.muted)),
    ]),
  );

  // ── Bar Chart Card ──────────────────────────────────
  Widget _barChartCard() => _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _chartHeader('Tasks Completed', [('Completed', _C.accent), ('Planned', _C.muted2)]),
    const SizedBox(height: 12),
    SizedBox(height: 140, child: AnimatedBuilder(animation: _anim,
      builder: (_, __) => CustomPaint(
        size: const Size(double.infinity, 140),
        painter: _BarChartPainter(_tasksCompleted, _tasksPlanned, _anim.value)))),
  ]));

  // ── Line Chart Card ─────────────────────────────────
  Widget _lineChartCard() => _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _chartHeader('AI Usage Over Time', [('Queries', _C.blue), ('Tokens (K)', _C.amber)]),
    const SizedBox(height: 12),
    SizedBox(height: 140, child: AnimatedBuilder(animation: _anim,
      builder: (_, __) => CustomPaint(
        size: const Size(double.infinity, 140),
        painter: _LineChartPainter(_aiQueries, _aiTokens, _anim.value)))),
  ]));

  Widget _chartHeader(String title, List<(String, Color)> legend) => Row(children: [
    Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _C.text, letterSpacing: 0.04)),
    const Spacer(),
    ...legend.map((l) => Padding(padding: const EdgeInsets.only(left: 12),
      child: Row(children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: l.$2)),
        const SizedBox(width: 5),
        Text(l.$1, style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: _C.muted)),
      ]))),
  ]);

  // ── Weekly Card ─────────────────────────────────────
  Widget _weeklyCard() => _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _chartHeader('Weekly Breakdown', [('Tasks', _C.accent), ('AI queries', _C.blue), ('Focus hrs', _C.amber)]),
    const SizedBox(height: 10),
    SizedBox(height: 90, child: AnimatedBuilder(animation: _anim,
      builder: (_, __) => Row(children: _weekData.map((d) {
        final maxT = 28;
        final pct = ((d['tasks'] as int) / maxT * 100).round();
        return Expanded(child: Column(children: [
          Text('${d['tasks']}', style: const TextStyle(fontSize: 10, color: _C.text, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          Expanded(child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(color: _C.surface2, borderRadius: BorderRadius.circular(4)),
            child: Align(alignment: Alignment.bottomCenter,
              child: AnimatedContainer(duration: const Duration(milliseconds: 500),
                height: (pct / 100 * 60 * _anim.value),
                decoration: BoxDecoration(color: _C.accent.withValues(alpha: 0.4 + pct / 160), borderRadius: BorderRadius.circular(3)))))),
          const SizedBox(height: 5),
          Text(d['day'] as String, style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: _C.muted, letterSpacing: 0.04)),
        ]));
      }).toList()))),
  ]));

  // ── Monthly Card ────────────────────────────────────
  Widget _monthlyCard() => _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [
      const Text('Monthly Summary', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _C.text, letterSpacing: 0.04)),
      const Spacer(),
      Text('March 2026', style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: _C.muted)),
    ]),
    const SizedBox(height: 10),
    GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.8,
      children: [
        _monthStat('Completed Tasks', '548', 'of 620 planned', _C.accent, 0.88),
        _monthStat('AI Queries', '9.4K', '+22% vs Feb', _C.blue, 0.74),
        _monthStat('Focus Hours', '154h', 'avg 5.6h/day', _C.amber, 0.60),
        _monthStat('Avg Score', '84.2', 'Personal best: 91', _C.text, 0.84),
      ]),
  ]));

  Widget _monthStat(String label, String value, String sub, Color color, double fill) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: _C.surface2, border: Border.all(color: _C.border, width: 0.5), borderRadius: BorderRadius.circular(8)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, color: _C.muted, letterSpacing: 0.08, fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: 0.04, color: color, height: 1)),
      const SizedBox(height: 4),
      Text(sub, style: const TextStyle(fontSize: 10, color: _C.muted)),
      const SizedBox(height: 6),
      ClipRRect(borderRadius: BorderRadius.circular(2),
        child: AnimatedBuilder(animation: _anim,
          builder: (_, __) => LinearProgressIndicator(value: fill * _anim.value, minHeight: 3, backgroundColor: _C.border2, color: color))),
    ]),
  );

  // ── Card wrapper ────────────────────────────────────
  Widget _card({required Widget child, EdgeInsetsGeometry? padding}) => Container(
    padding: padding ?? const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _C.surface, border: Border.all(color: _C.border, width: 0.5),
      borderRadius: BorderRadius.circular(10)),
    child: child);
}

// ── Small widgets ─────────────────────────────────────
class _SNBtn extends StatefulWidget {
  final IconData icon; final bool active;
  const _SNBtn(this.icon, this.active);
  @override State<_SNBtn> createState() => _SNBtnState();
}
class _SNBtnState extends State<_SNBtn> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: AnimatedContainer(duration: const Duration(milliseconds: 150),
      width: 38, height: 38, margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: widget.active ? _C.accentDim : h ? _C.surface2 : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        border: widget.active ? Border.all(color: _C.accent2, width: 0.5) : h ? Border.all(color: _C.border, width: 0.5) : null),
      child: Icon(widget.icon, size: 16, color: widget.active ? _C.accent : h ? _C.muted : _C.muted2)));
}

class _PeriodTab extends StatefulWidget {
  final String label; final bool active; final VoidCallback onTap;
  const _PeriodTab({required this.label, required this.active, required this.onTap});
  @override State<_PeriodTab> createState() => _PeriodTabState();
}
class _PeriodTabState extends State<_PeriodTab> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: GestureDetector(onTap: widget.onTap,
      child: AnimatedContainer(duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), margin: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          color: widget.active ? _C.accentDim : h ? _C.surface2 : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: widget.active ? Border.all(color: _C.accent2, width: 0.5) : null),
        child: Text(widget.label, style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.w500,
          letterSpacing: 0.04, color: widget.active ? _C.accent : h ? _C.text : _C.muted)))));
}

class _TBAction extends StatefulWidget {
  final String label; final IconData icon;
  const _TBAction({required this.label, required this.icon});
  @override State<_TBAction> createState() => _TBActionState();
}
class _TBActionState extends State<_TBAction> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: AnimatedContainer(duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: _C.surface2, border: Border.all(color: h ? _C.muted2 : _C.border2, width: 0.5), borderRadius: BorderRadius.circular(6)),
      child: Row(children: [
        Icon(widget.icon, size: 12, color: h ? _C.text : _C.muted),
        const SizedBox(width: 5),
        Text(widget.label, style: TextStyle(fontFamily: 'monospace', fontSize: 11, letterSpacing: 0.04, color: h ? _C.text : _C.muted)),
      ])));
}

class _ViewAllBtn extends StatefulWidget {
  @override State<_ViewAllBtn> createState() => _ViewAllBtnState();
}
class _ViewAllBtnState extends State<_ViewAllBtn> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: AnimatedOpacity(duration: const Duration(milliseconds: 150), opacity: h ? 0.8 : 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: _C.accentDim, border: Border.all(color: _C.accent2, width: 0.5), borderRadius: BorderRadius.circular(7)),
        child: const Center(child: Text('VIEW ALL INSIGHTS →', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: _C.accent, letterSpacing: 0.06))))));
}

// ── Ring Painter ──────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter(this.progress);
  @override void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 5;
    final track = Paint()..color = _C.border..style = PaintingStyle.stroke..strokeWidth = 4.5..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -2.44, 4.88, false, track);
    if (progress > 0) {
      final fill = Paint()..color = _C.accent..style = PaintingStyle.stroke..strokeWidth = 4.5..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), -2.44, 4.88 * progress, false, fill);
    }
  }
  @override bool shouldRepaint(_RingPainter o) => progress != o.progress;
}

// ── Bar Chart Painter ─────────────────────────────────
class _BarChartPainter extends CustomPainter {
  final List<int> completed, planned;
  final double anim;
  const _BarChartPainter(this.completed, this.planned, this.anim);

  @override void paint(Canvas canvas, Size size) {
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxVal = planned.reduce(math.max).toDouble();
    final w = size.width / labels.length;
    final barW = w * 0.3;

    // Grid lines
    final gridPaint = Paint()..color = const Color(0xFF1A1B22);
    for (int i = 0; i < 4; i++) {
      final y = size.height - 20 - (i / 3 * (size.height - 30));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (int i = 0; i < labels.length; i++) {
      final x = i * w + w / 2;
      final hC = (completed[i] / maxVal) * (size.height - 30) * anim;
      final hP = (planned[i] / maxVal) * (size.height - 30) * anim;

      // Planned bar
      final rrP = RRect.fromRectAndRadius(Rect.fromLTWH(x - barW + 2, size.height - 20 - hP, barW - 2, hP), const Radius.circular(4));
      canvas.drawRRect(rrP, Paint()..color = _C.border);

      // Completed bar
      final rrC = RRect.fromRectAndRadius(Rect.fromLTWH(x + 2, size.height - 20 - hC, barW - 2, hC), const Radius.circular(4));
      canvas.drawRRect(rrC, Paint()..color = _C.accent);

      // Label
      final tp = TextPainter(text: TextSpan(text: labels[i], style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: _C.muted2)),
        textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - 14));
    }
  }
  @override bool shouldRepaint(_BarChartPainter o) => anim != o.anim;
}

// ── Line Chart Painter ────────────────────────────────
class _LineChartPainter extends CustomPainter {
  final List<int> queries, tokens;
  final double anim;
  const _LineChartPainter(this.queries, this.tokens, this.anim);

  @override void paint(Canvas canvas, Size size) {
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final h = size.height - 30;
    final maxQ = queries.reduce(math.max).toDouble();
    final maxT = tokens.reduce(math.max).toDouble();
    final w = size.width / (labels.length - 1);

    // Grid lines
    final gridPaint = Paint()..color = const Color(0xFF1A1B22);
    for (int i = 0; i < 4; i++) {
      final y = size.height - 20 - (i / 3 * h);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Queries line
    _drawLine(canvas, size, queries, maxQ, w, h, _C.blue, anim);
    // Tokens line
    _drawLine(canvas, size, tokens, maxT, w, h, _C.amber, anim);

    // Labels
    for (int i = 0; i < labels.length; i++) {
      final tp = TextPainter(text: TextSpan(text: labels[i], style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: _C.muted2)),
        textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(i * w - tp.width / 2, size.height - 14));
    }
  }

  void _drawLine(Canvas canvas, Size size, List<int> data, double max, double w, double h, Color color, double anim) {
    final path = Path();
    final dotPaint = Paint()..color = color;
    final linePaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2;

    for (int i = 0; i < data.length; i++) {
      final x = i * w;
      final y = size.height - 20 - (data[i] / max * h * anim);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
    canvas.drawPath(path, linePaint);

    // Fill
    final fillPath = Path.from(path)
      ..lineTo((data.length - 1) * w, size.height - 20)
      ..lineTo(0, size.height - 20)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = color.withValues(alpha: 0.08));
  }

  @override bool shouldRepaint(_LineChartPainter o) => anim != o.anim;
}
