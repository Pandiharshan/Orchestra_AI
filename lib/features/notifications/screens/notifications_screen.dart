import 'package:flutter/material.dart';

// ── Palette ─────────────────────────────────────────────
class _C {
  static const bg       = Color(0xFFF5F3EE);
  static const surface  = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF0EDE8);
  static const surface3 = Color(0xFFE8E4DE);
  static const border   = Color(0xFFDDD9D2);
  static const border2  = Color(0xFFC8C4BC);
  static const text     = Color(0xFF1A1816);
  static const muted    = Color(0xFF8A8680);
  static const muted2   = Color(0xFFB8B4AE);
  static const sys      = Color(0xFFE8572A);
  static const sysBg    = Color(0xFFFDF0EC);
  static const sysBord  = Color(0xFFF5C4B5);
  static const task     = Color(0xFF2563EB);
  static const taskBg   = Color(0xFFEFF4FF);
  static const taskBord = Color(0xFFBFCFFF);
  static const ai       = Color(0xFF7C3AED);
  static const aiBg     = Color(0xFFF4F0FF);
  static const aiBord   = Color(0xFFD4C5FF);
  static const unreadBg = Color(0xFFFFFEF5);
  static const unreadBd = Color(0xFFE8E0C8);
}

// ── Models ──────────────────────────────────────────────
enum _Cat { sys, task, ai }

class _Notif {
  final int id;
  final _Cat cat;
  final String title, desc, time;
  final int ts;
  bool read;
  _Notif({required this.id, required this.cat, required this.title,
    required this.desc, required this.time, required this.ts, this.read = false});
}

// ── Screen ──────────────────────────────────────────────
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  _Cat? _catFilter; // null = All
  String _sort = 'newest';

  late List<_Notif> _notifs;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().millisecondsSinceEpoch;
    _notifs = [
      _Notif(id:1,  cat:_Cat.sys,  title:'System update available', desc:'Nexus v3.4.1 is ready to install. This update includes performance improvements and security patches for the workspace engine.', time:'2 min ago', ts:now-120000),
      _Notif(id:2,  cat:_Cat.ai,   title:'AI response generated', desc:'Your Code mode query about React hooks returned 3 code examples. The suggested useDebounce pattern reduced your render cycles by an estimated 40%.', time:'8 min ago', ts:now-480000),
      _Notif(id:3,  cat:_Cat.task, title:'Task deadline approaching', desc:'"Finalize Q2 design brief" is due in 2 hours. You have 3 subtasks remaining. Consider using AI Writing mode to accelerate the copy section.', time:'15 min ago', ts:now-900000),
      _Notif(id:4,  cat:_Cat.task, title:'Task assigned to you', desc:'Maya Rodriguez assigned "API endpoint documentation" to you with high priority. Estimated completion: 1.5 hours. Deadline: Friday 5 PM.', time:'34 min ago', ts:now-2040000),
      _Notif(id:5,  cat:_Cat.sys,  title:'Storage usage warning', desc:'Your workspace storage is at 87% capacity (4.35 GB / 5 GB). Consider archiving completed projects or upgrading your plan for more space.', time:'1 hr ago', ts:now-3600000),
      _Notif(id:6,  cat:_Cat.ai,   title:'Insight generated', desc:'Based on your activity patterns, your peak productivity window is 9–11 AM. Scheduling deep work tasks in this window improves output by 28%.', time:'2 hrs ago', ts:now-7200000),
      _Notif(id:7,  cat:_Cat.task, title:'3 tasks marked complete', desc:'James completed "Mobile nav prototype", "Color token audit", and "Accessibility review". Sprint progress is now at 68%.', time:'3 hrs ago', ts:now-10800000),
      _Notif(id:8,  cat:_Cat.sys,  title:'Workspace backup complete', desc:'Automatic backup completed successfully. 142 files saved to secure cloud storage. Next backup scheduled in 24 hours.', time:'5 hrs ago', ts:now-18000000, read:true),
      _Notif(id:9,  cat:_Cat.task, title:'Comment on your task', desc:'Sara Chen left a comment on "Landing page redesign": "The hero section looks great — can we explore a dark variant too?"', time:'Yesterday', ts:now-93600000, read:true),
      _Notif(id:10, cat:_Cat.ai,   title:'AI model updated', desc:'Nexus AI has been upgraded to the latest reasoning model. You may notice improved code generation accuracy and faster response times.', time:'Yesterday', ts:now-100800000, read:true),
      _Notif(id:11, cat:_Cat.sys,  title:'Login from new device', desc:'A login was detected from MacBook Pro (Chrome, macOS 14.3) in Bangalore, India. If this was you, no action needed.', time:'2 days ago', ts:now-180000000, read:true),
      _Notif(id:12, cat:_Cat.task, title:'Sprint review scheduled', desc:'Your team sprint review is scheduled for Friday, Apr 3 at 3 PM IST. 8 tasks are ready for review.', time:'2 days ago', ts:now-187200000, read:true),
    ];
  }

  List<_Notif> get _filtered {
    var items = _catFilter == null ? _notifs : _notifs.where((n) => n.cat == _catFilter).toList();
    if (_sort == 'oldest') {
      items.sort((a, b) => a.ts.compareTo(b.ts));
    } else if (_sort == 'unread') {
      items.sort((a, b) => a.read == b.read ? b.ts.compareTo(a.ts) : a.read ? 1 : -1);
    } else {
      items.sort((a, b) => b.ts.compareTo(a.ts));
    }
    return items;
  }

  int get _unreadCount => _notifs.where((n) => !n.read).length;
  int _catCount(_Cat? cat) => cat == null ? _notifs.length : _notifs.where((n) => n.cat == cat).length;

  void _markAllRead() {
    setState(() {
      final items = _catFilter == null ? _notifs : _notifs.where((n) => n.cat == _catFilter).toList();
      for (final n in items) n.read = true;
    });
  }

  void _clearAll() {
    setState(() {
      if (_catFilter == null) {
        _notifs.clear();
      } else {
        _notifs.removeWhere((n) => n.cat == _catFilter);
      }
    });
  }

  void _toggleRead(int id) {
    setState(() {
      final n = _notifs.firstWhere((x) => x.id == id, orElse: () => _notifs.first);
      n.read = !n.read;
    });
  }

  void _dismiss(int id) {
    setState(() => _notifs.removeWhere((x) => x.id == id));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _C.bg,
    body: Column(children: [
      _titleBar(),
      Expanded(child: Row(children: [
        _sideNav(),
        Expanded(child: Column(children: [
          _topBar(),
          _catBar(),
          Expanded(child: _notifList()),
          _statusBar(),
        ])),
      ])),
    ]),
  );

  // ── Title Bar ───────────────────────────────────────
  Widget _titleBar() => Container(
    height: 34,
    color: _C.text,
    child: Row(children: [
      const SizedBox(width: 14),
      _dot(const Color(0xFFFF5F57)), const SizedBox(width: 8),
      _dot(const Color(0xFFFEBC2E)), const SizedBox(width: 8),
      _dot(const Color(0xFF28C840)),
      const SizedBox(width: 10),
      Text('NEXUS — NOTIFICATIONS', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: _C.muted.withValues(alpha: 0.6), letterSpacing: 0.07)),
      const Spacer(),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: const Color(0xFF2A2724), borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3A3734), width: 0.5)),
        child: Text('${_unreadCount} unread', style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: _C.muted, letterSpacing: 0.05)),
      ),
      const SizedBox(width: 14),
    ]),
  );

  Widget _dot(Color c) => Container(width: 11, height: 11, decoration: BoxDecoration(color: c, shape: BoxShape.circle));

  // ── Side Nav ────────────────────────────────────────
  Widget _sideNav() => Container(
    width: 60,
    color: _C.text,
    child: Column(children: [
      const SizedBox(height: 16),
      Container(width: 36, height: 36, margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(color: _C.bg, borderRadius: BorderRadius.circular(10)),
        child: const Center(child: Text('▲', style: TextStyle(fontSize: 14, color: _C.text, fontWeight: FontWeight.w700)))),
      _SideIcon(Icons.grid_view_rounded, false),
      _SideIcon(Icons.notifications_outlined, true, badge: true),
      _SideIcon(Icons.check_box_outlined, false),
      _SideIcon(Icons.chat_bubble_outline_rounded, false),
      _SideIcon(Icons.show_chart_rounded, false),
      Container(height: 0.5, width: 32, color: const Color(0xFF2A2724), margin: const EdgeInsets.symmetric(vertical: 6)),
      _SideIcon(Icons.settings_outlined, false),
      const Spacer(),
      Container(width: 32, height: 32, margin: const EdgeInsets.only(bottom: 16),
        decoration: const BoxDecoration(shape: BoxShape.circle, color: _C.bg),
        child: const Center(child: Text('AJ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _C.text)))),
    ]),
  );

  // ── Top Bar ─────────────────────────────────────────
  Widget _topBar() => Container(
    height: 56, color: _C.surface,
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _C.border))),
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.01)),
        Text('${_unreadCount} unread • ${_notifs.length} total', style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: _C.muted, letterSpacing: 0.04)),
      ]),
      const Spacer(),
      _TopBtn(label: 'Mark all read', icon: Icons.check_rounded, onTap: _markAllRead),
      const SizedBox(width: 8),
      _TopBtn(label: 'Clear all', icon: Icons.delete_outline_rounded, onTap: _clearAll, danger: true),
      const SizedBox(width: 8),
      _MarkAllBtn(onTap: _markAllRead),
    ]),
  );

  // ── Category Bar ────────────────────────────────────
  Widget _catBar() => Container(
    height: 46, color: _C.surface,
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _C.border))),
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(children: [
      _CatBtn(label: 'All', cat: null, count: _catCount(null), active: _catFilter == null,
        onTap: () => setState(() => _catFilter = null)),
      const SizedBox(width: 4),
      _CatBtn(label: 'System', cat: _Cat.sys, count: _catCount(_Cat.sys), active: _catFilter == _Cat.sys,
        icon: Icons.computer_rounded,
        onTap: () => setState(() => _catFilter = _catFilter == _Cat.sys ? null : _Cat.sys)),
      const SizedBox(width: 4),
      _CatBtn(label: 'Tasks', cat: _Cat.task, count: _catCount(_Cat.task), active: _catFilter == _Cat.task,
        icon: Icons.check_box_outlined,
        onTap: () => setState(() => _catFilter = _catFilter == _Cat.task ? null : _Cat.task)),
      const SizedBox(width: 4),
      _CatBtn(label: 'AI', cat: _Cat.ai, count: _catCount(_Cat.ai), active: _catFilter == _Cat.ai,
        icon: Icons.change_history_rounded,
        onTap: () => setState(() => _catFilter = _catFilter == _Cat.ai ? null : _Cat.ai)),
      const Spacer(),
      const Text('Sort: ', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: _C.muted)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: _C.surface2, border: Border.all(color: _C.border), borderRadius: BorderRadius.circular(6)),
        child: DropdownButtonHideUnderline(child: DropdownButton<String>(
          value: _sort, isDense: true, style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: _C.text),
          items: const [
            DropdownMenuItem(value: 'newest', child: Text('Newest first')),
            DropdownMenuItem(value: 'oldest', child: Text('Oldest first')),
            DropdownMenuItem(value: 'unread', child: Text('Unread first')),
          ],
          onChanged: (v) => setState(() => _sort = v!),
        )),
      ),
    ]),
  );

  // ── Notification List ───────────────────────────────
  Widget _notifList() {
    final items = _filtered;
    if (items.isEmpty) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: _C.surface2, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.notifications_off_outlined, size: 20, color: _C.muted2)),
        const SizedBox(height: 10),
        const Text('No notifications here', style: TextStyle(fontSize: 14, color: _C.muted, fontWeight: FontWeight.w300)),
      ]));
    }

    // Group by time
    final now = DateTime.now().millisecondsSinceEpoch;
    final today = <_Notif>[], yesterday = <_Notif>[], older = <_Notif>[];
    for (final n in items) {
      final age = now - n.ts;
      if (age < 86400000) {
        today.add(n);
      } else if (age < 172800000) {
        yesterday.add(n);
      } else {
        older.add(n);
      }
    }

    return ListView(padding: const EdgeInsets.fromLTRB(24, 16, 24, 20), children: [
      if (today.isNotEmpty) ...[
        _groupLabel('Today'),
        ...today.map((n) => _notifItem(n)),
      ],
      if (yesterday.isNotEmpty) ...[
        _groupLabel('Yesterday'),
        ...yesterday.map((n) => _notifItem(n)),
      ],
      if (older.isNotEmpty) ...[
        _groupLabel('Earlier'),
        ...older.map((n) => _notifItem(n)),
      ],
    ]);
  }

  Widget _groupLabel(String label) => Padding(
    padding: EdgeInsets.only(bottom: 8, left: 4, top: label == 'Today' ? 0 : 20),
    child: Text(label.toUpperCase(), style: const TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.w600,
      letterSpacing: 0.1, color: _C.muted2)),
  );

  Widget _notifItem(_Notif n) => _NotifTile(
    notif: n,
    onTap: () { if (!n.read) setState(() => n.read = true); },
    onToggleRead: () => _toggleRead(n.id),
    onDismiss: () => _dismiss(n.id),
  );

  // ── Status Bar ──────────────────────────────────────
  Widget _statusBar() => Container(
    height: 26, color: _C.surface,
    decoration: const BoxDecoration(border: Border(top: BorderSide(color: _C.border))),
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(children: [
      Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF28C840))),
      const SizedBox(width: 5),
      const Text('Connected', style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: _C.muted2, letterSpacing: 0.04)),
      const SizedBox(width: 16),
      Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: _C.sys)),
      const SizedBox(width: 5),
      Text('${_unreadCount} unread', style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: _C.muted2, letterSpacing: 0.04)),
      const Spacer(),
      const Text('Last synced: just now', style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: _C.muted2, letterSpacing: 0.04)),
    ]),
  );
}

// ── Notification Tile ─────────────────────────────────
class _NotifTile extends StatefulWidget {
  final _Notif notif;
  final VoidCallback onTap, onToggleRead, onDismiss;
  const _NotifTile({required this.notif, required this.onTap, required this.onToggleRead, required this.onDismiss});
  @override State<_NotifTile> createState() => _NotifTileState();
}
class _NotifTileState extends State<_NotifTile> {
  bool _hover = false;

  Color _stripeColor() {
    if (widget.notif.read) return _C.border;
    return switch (widget.notif.cat) { _Cat.sys => _C.sys, _Cat.task => _C.task, _Cat.ai => _C.ai };
  }
  Color _iconBg() => switch (widget.notif.cat) { _Cat.sys => _C.sysBg, _Cat.task => _C.taskBg, _Cat.ai => _C.aiBg };
  Color _iconColor() => switch (widget.notif.cat) { _Cat.sys => _C.sys, _Cat.task => _C.task, _Cat.ai => _C.ai };
  IconData _iconData() => switch (widget.notif.cat) { _Cat.sys => Icons.computer_rounded, _Cat.task => Icons.check_box_outlined, _Cat.ai => Icons.change_history_rounded };
  String _tagLabel() => switch (widget.notif.cat) { _Cat.sys => 'System', _Cat.task => 'Tasks', _Cat.ai => 'AI' };
  Color _tagBg() => switch (widget.notif.cat) { _Cat.sys => _C.sysBg, _Cat.task => _C.taskBg, _Cat.ai => _C.aiBg };
  Color _tagColor() => switch (widget.notif.cat) { _Cat.sys => _C.sys, _Cat.task => _C.task, _Cat.ai => _C.ai };

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _hover = true),
    onExit: (_) => setState(() => _hover = false),
    child: GestureDetector(onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: widget.notif.read ? _C.surface : _C.unreadBg,
          border: Border.all(color: widget.notif.read ? (_hover ? _C.border2 : _C.border) : _C.unreadBd),
          borderRadius: BorderRadius.circular(10),
          boxShadow: _hover ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)] : [],
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(10),
          child: IntrinsicHeight(child: Row(children: [
            // Stripe
            Container(width: 3, color: _stripeColor()),
            // Icon
            Padding(padding: const EdgeInsets.only(left: 12),
              child: Container(width: 32, height: 32,
                decoration: BoxDecoration(color: _iconBg(), borderRadius: BorderRadius.circular(9)),
                child: Icon(_iconData(), size: 15, color: _iconColor()))),
            // Body
            Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(10, 12, 12, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(widget.notif.title,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13,
                      fontWeight: widget.notif.read ? FontWeight.w400 : FontWeight.w600,
                      color: widget.notif.read ? _C.muted : _C.text))),
                  if (!widget.notif.read) ...[
                    const SizedBox(width: 8),
                    Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: _iconColor())),
                  ],
                  const SizedBox(width: 8),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(color: _tagBg(), borderRadius: BorderRadius.circular(20)),
                    child: Text(_tagLabel().toUpperCase(), style: TextStyle(fontFamily: 'monospace', fontSize: 9, fontWeight: FontWeight.w600,
                      letterSpacing: 0.06, color: _tagColor()))),
                ]),
                const SizedBox(height: 3),
                Text(widget.notif.desc, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12,
                    color: widget.notif.read ? _C.muted2 : _C.muted,
                    fontWeight: FontWeight.w300, height: 1.5)),
                const SizedBox(height: 4),
                Text(widget.notif.time, style: TextStyle(fontFamily: 'monospace', fontSize: 10,
                  color: widget.notif.read ? _C.muted2 : _C.muted, letterSpacing: 0.03)),
              ]))),
            // Actions
            AnimatedOpacity(duration: const Duration(milliseconds: 150), opacity: _hover ? 1 : 0,
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _ActBtn(icon: widget.notif.read ? Icons.remove_circle_outline : Icons.check_circle_outline,
                    onTap: widget.onToggleRead),
                  const SizedBox(height: 4),
                  _ActBtn(icon: Icons.close_rounded, onTap: widget.onDismiss, danger: true),
                ]))),
          ]))),
      )),
  );
}

// ── Small Widgets ─────────────────────────────────────
class _SideIcon extends StatefulWidget {
  final IconData icon;
  final bool active;
  final bool badge;
  const _SideIcon(this.icon, this.active, {this.badge = false});
  @override State<_SideIcon> createState() => _SideIconState();
}
class _SideIconState extends State<_SideIcon> {
  bool h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true),
    onExit: (_) => setState(() => h = false),
    child: Stack(children: [
      AnimatedContainer(duration: const Duration(milliseconds: 150),
        width: 40, height: 40, margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: widget.active || h ? const Color(0xFF2A2724) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: widget.active ? Border.all(color: const Color(0xFF3A3734), width: 0.5) : null,
        ),
        child: Icon(widget.icon, size: 16,
          color: widget.active ? _C.bg : h ? _C.muted : const Color(0xFF4A4844))),
      if (widget.badge)
        Positioned(top: 6, right: 6, child: Container(width: 7, height: 7,
          decoration: BoxDecoration(shape: BoxShape.circle, color: _C.sys,
            border: Border.all(color: _C.text, width: 1.5)))),
    ]),
  );
}

class _TopBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;
  const _TopBtn({required this.label, required this.icon, required this.onTap, this.danger = false});
  @override State<_TopBtn> createState() => _TopBtnState();
}
class _TopBtnState extends State<_TopBtn> {
  bool h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true),
    onExit: (_) => setState(() => h = false),
    child: GestureDetector(onTap: widget.onTap,
      child: AnimatedContainer(duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: h && widget.danger ? _C.sysBg : h ? _C.surface2 : _C.surface,
          border: Border.all(color: h ? _C.border2 : _C.border),
          borderRadius: BorderRadius.circular(7)),
        child: Row(children: [
          Icon(widget.icon, size: 12, color: h && widget.danger ? _C.sys : h ? _C.text : _C.muted),
          const SizedBox(width: 5),
          Text(widget.label, style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.w500,
            letterSpacing: 0.04, color: h && widget.danger ? _C.sys : h ? _C.text : _C.muted)),
        ]))),
  );
}

class _MarkAllBtn extends StatefulWidget {
  final VoidCallback onTap;
  const _MarkAllBtn({required this.onTap});
  @override State<_MarkAllBtn> createState() => _MarkAllBtnState();
}
class _MarkAllBtnState extends State<_MarkAllBtn> {
  bool h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true),
    onExit: (_) => setState(() => h = false),
    child: GestureDetector(onTap: widget.onTap,
      child: AnimatedOpacity(duration: const Duration(milliseconds: 150), opacity: h ? 0.85 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: _C.text, borderRadius: BorderRadius.circular(7)),
          child: Row(children: [
            const Icon(Icons.check_circle_outline, size: 12, color: _C.bg),
            const SizedBox(width: 5),
            const Text('All caught up', style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.w500,
              letterSpacing: 0.04, color: _C.bg)),
          ])))),
  );
}

class _CatBtn extends StatefulWidget {
  final String label;
  final _Cat? cat;
  final int count;
  final bool active;
  final IconData? icon;
  final VoidCallback onTap;
  const _CatBtn({required this.label, required this.cat, required this.count,
    required this.active, this.icon, required this.onTap});
  @override State<_CatBtn> createState() => _CatBtnState();
}
class _CatBtnState extends State<_CatBtn> {
  bool h = false;

  Color _activeBg() => switch (widget.cat) {
    null => _C.text,
    _Cat.sys => _C.sysBg,
    _Cat.task => _C.taskBg,
    _Cat.ai => _C.aiBg,
  };
  Color _activeColor() => switch (widget.cat) {
    null => _C.bg,
    _Cat.sys => _C.sys,
    _Cat.task => _C.task,
    _Cat.ai => _C.ai,
  };
  Color _activeBorder() => switch (widget.cat) {
    null => _C.text,
    _Cat.sys => _C.sysBord,
    _Cat.task => _C.taskBord,
    _Cat.ai => _C.aiBord,
  };
  Color _countBg() => switch (widget.cat) {
    null => _C.surface3,
    _Cat.sys => _C.sysBg,
    _Cat.task => _C.taskBg,
    _Cat.ai => _C.aiBg,
  };
  Color _countColor() => switch (widget.cat) {
    null => _C.text,
    _Cat.sys => _C.sys,
    _Cat.task => _C.task,
    _Cat.ai => _C.ai,
  };

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true),
    onExit: (_) => setState(() => h = false),
    child: GestureDetector(onTap: widget.onTap,
      child: AnimatedContainer(duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: widget.active ? _activeBg() : h ? _C.surface2 : Colors.transparent,
          border: Border.all(color: widget.active ? _activeBorder() : Colors.transparent),
          borderRadius: BorderRadius.circular(6)),
        child: Row(children: [
          if (widget.icon != null) ...[
            Icon(widget.icon!, size: 11, color: widget.active ? _activeColor() : h ? _C.text : _C.muted),
            const SizedBox(width: 4),
          ],
          Text(widget.label, style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.w500,
            letterSpacing: 0.04, color: widget.active ? _activeColor() : h ? _C.text : _C.muted)),
          const SizedBox(width: 6),
          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(color: _countBg(), borderRadius: BorderRadius.circular(20)),
            child: Text('${widget.count}', style: TextStyle(fontFamily: 'monospace', fontSize: 9,
              fontWeight: FontWeight.w600, color: _countColor()))),
        ]))),
  );
}

class _ActBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;
  const _ActBtn({required this.icon, required this.onTap, this.danger = false});
  @override State<_ActBtn> createState() => _ActBtnState();
}
class _ActBtnState extends State<_ActBtn> {
  bool h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true),
    onExit: (_) => setState(() => h = false),
    child: GestureDetector(onTap: widget.onTap,
      child: AnimatedContainer(duration: const Duration(milliseconds: 150),
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: h && widget.danger ? _C.sysBg : h ? _C.surface2 : Colors.transparent,
          border: Border.all(color: h ? _C.border2 : _C.border),
          borderRadius: BorderRadius.circular(7)),
        child: Icon(widget.icon, size: 12,
          color: h && widget.danger ? _C.sys : h ? _C.text : _C.muted))),
  );
}
