import 'package:flutter/material.dart';
import 'dart:math' as math;

// ── Palette ───────────────────────────────────────────
class _C {
  static const s0  = Color(0xFFFFFFFF);
  static const s1  = Color(0xFFFCF9F4);
  static const s2  = Color(0xFFF0EDE9);
  static const s3  = Color(0xFFE6E3DE);
  static const pri = Color(0xFF7B535C);
  static const prL = Color(0xFFD8A7B1);
  static const sec = Color(0xFFFFC69C);
  static const on  = Color(0xFF1C1C19);
  static const onv = Color(0xFF504446);
  static const ter = Color(0xFF4A654D);
  static const trL = Color(0xFFCAE6CC);
  static const sh  = Color(0x0D1C1C19);
  static const sh2 = Color(0x1A1C1C19);
  static const ov  = Color(0x211C1C19);
}

// ── Task model ────────────────────────────────────────
class _Task {
  final int id;
  String title, priority, status;
  String deadline;
  List<String> assignees;
  int progress;
  _Task({required this.id, required this.title, required this.priority,
      required this.status, required this.deadline, required this.assignees, required this.progress});
}

String _today() {
  final d = DateTime.now();
  return '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
}
String _addDays(int n) {
  final d = DateTime.now().add(Duration(days: n));
  return '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
}

// ── Screen ────────────────────────────────────────────
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});
  @override State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _filter = 'all'; // all/today/upcoming/done
  bool _kanban = true;
  int _activeNav = 1;
  bool _showModal = false;
  final _titleCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _modalPri = 'medium', _modalStatus = 'todo', _modalAssignee = 'KM';
  String _modalDl = _addDays(1);

  late List<_Task> _tasks;

  @override
  void initState() {
    super.initState();
    final td = _today();
    _tasks = [
      _Task(id:1, title:"Finalize brand color tokens", priority:"urgent", status:"doing", deadline:td, assignees:["KM","SR"], progress:75),
      _Task(id:2, title:"Design system component audit", priority:"high", status:"doing", deadline:_addDays(2), assignees:["KM"], progress:40),
      _Task(id:3, title:"Moodboard for AW25 campaign", priority:"medium", status:"doing", deadline:_addDays(4), assignees:["AJ","KM"], progress:55),
      _Task(id:4, title:"Review typography scale proposal", priority:"high", status:"todo", deadline:td, assignees:["KM"], progress:0),
      _Task(id:5, title:"Write copy for homepage hero", priority:"medium", status:"todo", deadline:_addDays(3), assignees:["AJ"], progress:20),
      _Task(id:6, title:"Conduct usability testing — checkout", priority:"high", status:"todo", deadline:_addDays(7), assignees:["LT","KM"], progress:0),
      _Task(id:7, title:"Create navigation icon set", priority:"low", status:"todo", deadline:_addDays(10), assignees:["SR"], progress:10),
      _Task(id:8, title:"Photo selection for editorial spread", priority:"medium", status:"todo", deadline:_addDays(2), assignees:["KM","AJ"], progress:30),
      _Task(id:9, title:"Update brand guidelines document", priority:"medium", status:"done", deadline:_addDays(-2), assignees:["KM","AJ"], progress:100),
      _Task(id:10, title:"Export design assets for devs", priority:"high", status:"done", deadline:_addDays(-1), assignees:["SR"], progress:100),
      _Task(id:11, title:"Stakeholder presentation deck", priority:"urgent", status:"done", deadline:_addDays(-3), assignees:["KM"], progress:100),
      _Task(id:12, title:"Set up Figma project structure", priority:"low", status:"done", deadline:_addDays(-5), assignees:["LT"], progress:100),
    ];
    _modalDl = _addDays(1);
  }

  @override void dispose() { _titleCtrl.dispose(); _notesCtrl.dispose(); super.dispose(); }

  List<_Task> get _filtered {
    if (_filter == 'today') return _tasks.where((t) { if (t.status == 'done') return false; final d = _dlabel(t.deadline); return d != null && (d.$1 == 'Due today' || d.$2); }).toList();
    if (_filter == 'upcoming') return _tasks.where((t) { if (t.status == 'done') return false; final d = _dlabel(t.deadline); return d != null && !d.$2 && d.$1 != 'Due today'; }).toList();
    if (_filter == 'done') return _tasks.where((t) => t.status == 'done').toList();
    return _tasks;
  }

  (String, bool)? _dlabel(String dl) {
    if (dl.isEmpty) return null;
    final d = DateTime.parse(dl);
    final t = DateTime.now(); final today = DateTime(t.year, t.month, t.day);
    final diff = d.difference(today).inDays;
    if (diff < 0) return ('${diff.abs()}d overdue', true);
    if (diff == 0) return ('Due today', false);
    if (diff == 1) return ('Tomorrow', false);
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return ('${months[d.month-1]} ${d.day}', false);
  }

  int get _doneCount => _tasks.where((t) => t.status == 'done').length;
  int get _progPct => _tasks.isEmpty ? 0 : (_doneCount / _tasks.length * 100).round();

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg),
      backgroundColor: _C.on, behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2)));
  }

  void _saveTask() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;
    setState(() {
      _tasks.insert(0, _Task(id: _tasks.length + 100, title: title, priority: _modalPri,
          status: _modalStatus, deadline: _modalDl, assignees: [_modalAssignee], progress: 0));
      _showModal = false;
    });
    _titleCtrl.clear(); _notesCtrl.clear();
    _toast('Task created ✦');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _C.s1,
    body: Column(children: [
      _chrome(),
      Expanded(child: Row(children: [
        _sidebar(),
        Expanded(child: Column(children: [
          _topbar(),
          Expanded(child: _kanban ? _board() : _listView()),
        ])),
      ])),
      if (_showModal) const SizedBox.shrink(),
    ]),
  );

  // ── Chrome ────────────────────────────────────────
  Widget _chrome() => Container(height: 36, color: _C.s2, child: Row(children: [
    const SizedBox(width: 14),
    Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFFE0655A), shape: BoxShape.circle, border: Border.all(color: const Color(0xFFCC5048), width: 0.5))),
    const SizedBox(width: 6),
    Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFFE0B84E), shape: BoxShape.circle, border: Border.all(color: const Color(0xFFCCA438), width: 0.5))),
    const SizedBox(width: 6),
    Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFF5DB85C), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF4DA44C), width: 0.5))),
    const Spacer(),
    const Text('Atelier — Task Manager', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.07, color: _C.onv)),
    const Spacer(), const SizedBox(width: 42),
  ]));

  // ── Sidebar ───────────────────────────────────────
  Widget _sidebar() {
    final navItems = [
      ('Overview', Icons.grid_view_rounded, null),
      ('My Tasks', Icons.check_box_outlined, _tasks.length.toString()),
      ('Team Tasks', Icons.people_outline_rounded, null),
      ('Calendar', Icons.calendar_month_outlined, null),
    ];
    final projects = [
      ('Brand Refresh', Icons.folder_outlined),
      ('Web Redesign', Icons.folder_outlined),
      ('Analytics', Icons.show_chart_rounded),
    ];
    return Container(width: 230, color: _C.s2, padding: const EdgeInsets.fromLTRB(14, 24, 14, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 26, height: 26, decoration: BoxDecoration(gradient: const LinearGradient(colors:[_C.pri,_C.prL]), borderRadius: BorderRadius.circular(8))),
          const SizedBox(width: 8),
          const Text('Atelier', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -0.02)),
        ]),
        const SizedBox(height: 28),
        const Text('WORKSPACE', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.1, color: _C.onv, height: 1)),
        const SizedBox(height: 6),
        ...navItems.asMap().entries.map((e) => _NavItem(label: e.value.$1, icon: e.value.$2, badge: e.value.$3,
          active: _activeNav == e.key, onTap: () => setState(() => _activeNav = e.key))),
        const SizedBox(height: 14),
        const Text('PROJECTS', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.1, color: _C.onv, height: 1)),
        const SizedBox(height: 6),
        ...projects.map((p) => _NavItem(label: p.$1, icon: p.$2, active: false, onTap: () {})),
        const Spacer(),
        _progressWidget(),
        const SizedBox(height: 12),
        _userFooter(),
      ]));
  }

  Widget _progressWidget() => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(
    color: _C.s0, borderRadius: BorderRadius.circular(13), boxShadow: [BoxShadow(color: _C.sh, blurRadius: 14)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("TODAY'S PROGRESS", style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.09, color: _C.onv)),
      const SizedBox(height: 12),
      Row(children: [
        SizedBox(width: 50, height: 50, child: CustomPaint(painter: _RingPainter(_progPct / 100),
          child: Center(child: Text('$_progPct%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _C.pri, letterSpacing: -0.02))))),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$_progPct%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.03, height: 1)),
          const SizedBox(height: 2),
          Text('$_doneCount of ${_tasks.length} done', style: const TextStyle(fontSize: 10.5, color: _C.onv)),
        ]),
      ]),
    ]));

  Widget _userFooter() => MouseRegion(cursor: SystemMouseCursors.click, child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(9)),
    child: Row(children: [
      Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors:[_C.pri,_C.prL])),
        child: const Center(child: Text('KM', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.04)))),
      const SizedBox(width: 10),
      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Kai Moreau', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
        Text('DESIGN LEAD', style: TextStyle(fontSize: 9.5, letterSpacing: 0.07, color: _C.onv)),
      ]),
    ])));

  // ── Topbar ────────────────────────────────────────
  Widget _topbar() => Padding(padding: const EdgeInsets.fromLTRB(28, 20, 28, 0), child: Row(children: [
    const Text('My Tasks', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: -0.025)),
    const Spacer(),
    _filterTabs(),
    const SizedBox(width: 10),
    _viewToggle(),
    const SizedBox(width: 10),
    _AddBtn(onTap: () => setState(() => _showModal = true)),
  ]));

  Widget _filterTabs() {
    final filters = [('All', 'all', _tasks.length), ('Today', 'today', _filtered.length),
        ('Upcoming', 'upcoming', _tasks.where((t) => t.status != 'done').length - _filtered.where((t) => t.status != 'done').length),
        ('Completed', 'done', _tasks.where((t) => t.status == 'done').length)];
    return Row(children: filters.map((f) {
      final active = _filter == f.$2;
      return MouseRegion(cursor: SystemMouseCursors.click, child: GestureDetector(onTap: () => setState(() => _filter = f.$2),
        child: AnimatedContainer(duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6), margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(color: active ? _C.on : Colors.transparent, borderRadius: BorderRadius.circular(999)),
          child: Row(children: [Text(f.$1, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, letterSpacing: 0.02, color: active ? _C.s1 : _C.onv)),
            Text(' ${f.$3}', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: active ? _C.s1.withValues(alpha: 0.6) : _C.onv.withValues(alpha: 0.5)))]))));
    }).toList());
  }

  Widget _viewToggle() => Container(padding: const EdgeInsets.all(2), decoration: BoxDecoration(color: _C.s2, borderRadius: BorderRadius.circular(9)),
    child: Row(children: [
      _VBtn(icon: Icons.view_column_rounded, active: _kanban, onTap: () => setState(() => _kanban = true)),
      _VBtn(icon: Icons.list_rounded, active: !_kanban, onTap: () => setState(() => _kanban = false)),
    ]));

  // ── Kanban Board ──────────────────────────────────
  Widget _board() {
    final vis = _filtered;
    return SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _column('Todo', 'todo', vis.where((t) => t.status == 'todo').toList()),
        const SizedBox(width: 18),
        _column('In Progress', 'doing', vis.where((t) => t.status == 'doing').toList()),
        const SizedBox(width: 18),
        _column('Done', 'done', vis.where((t) => t.status == 'done').toList()),
      ]));
  }

  Widget _column(String label, String status, List<_Task> tasks) {
    final colors = {'todo': _C.onv, 'doing': _C.pri, 'done': _C.ter};
    return SizedBox(width: 285, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: colors[status])),
        const SizedBox(width: 8),
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 0.1, color: _C.onv)),
        const Spacer(),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: _C.s2, borderRadius: BorderRadius.circular(999)),
          child: Text('${tasks.length}', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: _C.onv))),
      ]),
      const SizedBox(height: 12),
      ...tasks.map((t) => Padding(padding: const EdgeInsets.only(bottom: 11), child: _TaskCard(task: t,
        onDelete: () => setState(() { _tasks.removeWhere((x) => x.id == t.id); _toast('Task removed'); }),
        onComplete: () => setState(() { t.status = t.status == 'done' ? 'todo' : 'done'; if (t.status == 'done') t.progress = 100; })))),
    ]));
  }

  // ── List View ─────────────────────────────────────
  Widget _listView() {
    final vis = _filtered;
    final groups = {'todo': 'To Do', 'doing': 'In Progress', 'done': 'Done'};
    return ListView(padding: const EdgeInsets.fromLTRB(28, 20, 28, 28), children: [
      for (final s in ['todo', 'doing', 'done']) ...[
        if (vis.any((t) => t.status == s)) ...[
          Padding(padding: const EdgeInsets.only(bottom: 8, left: 3),
            child: Text(groups[s]!.toUpperCase(), style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.1, color: _C.onv))),
          ...vis.where((t) => t.status == s).map((t) => _ListRow(task: t,
            onToggle: () => setState(() { t.status = t.status == 'done' ? 'todo' : 'done'; }))),
          const SizedBox(height: 14),
        ]
      ],
    ]);
  }

  // ── Modal ─────────────────────────────────────────
  @override
  Widget build2(BuildContext context) => Stack(children: [
    build(context),
    if (_showModal) _modal(),
  ]);

  Widget _modal() => GestureDetector(
    onTap: () => setState(() => _showModal = false),
    child: Container(color: Colors.black.withValues(alpha: 0.32), child: Center(child: GestureDetector(
      onTap: () {}, child: Container(width: 400, decoration: BoxDecoration(color: _C.s0, borderRadius: BorderRadius.circular(17),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 70)]),
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Text('New Task', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -0.015)), const Spacer(),
            GestureDetector(onTap: () => setState(() => _showModal = false),
              child: Container(width: 26, height: 26, decoration: BoxDecoration(color: _C.s2, borderRadius: BorderRadius.circular(7)),
                child: const Icon(Icons.close_rounded, size: 14, color: _C.onv)))],
          ),
          const SizedBox(height: 22),
          _mField('Task Title', TextField(controller: _titleCtrl, decoration: _mDeco('What needs to be done?'))),
          Row(children: [
            Expanded(child: _mField('Priority', DropdownButtonFormField<String>(value: _modalPri,
              decoration: _mDeco(null), items: ['urgent','high','medium','low'].map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 13)))).toList(),
              onChanged: (v) => setState(() => _modalPri = v!)))),
            const SizedBox(width: 12),
            Expanded(child: _mField('Status', DropdownButtonFormField<String>(value: _modalStatus,
              decoration: _mDeco(null), items: ['todo','doing','done'].map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 13)))).toList(),
              onChanged: (v) => setState(() => _modalStatus = v!)))),
          ]),
          _mField('Notes', TextField(controller: _notesCtrl, maxLines: 2, decoration: _mDeco('Optional context…'))),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(onPressed: () => setState(() => _showModal = false),
              child: const Text('Cancel', style: TextStyle(color: _C.onv, fontWeight: FontWeight.w600))),
            const SizedBox(width: 10),
            GestureDetector(onTap: _saveTask, child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: _C.pri, borderRadius: BorderRadius.circular(9),
                boxShadow: [BoxShadow(color: _C.pri.withValues(alpha: 0.2), blurRadius: 10)]),
              child: const Text('Create Task', style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)))),
          ]),
        ]))))));

  Widget _mField(String label, Widget child) => Padding(padding: const EdgeInsets.only(bottom: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label.toUpperCase(), style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.08, color: _C.onv)),
    const SizedBox(height: 6), child]));

  InputDecoration _mDeco(String? hint) => InputDecoration(hintText: hint, hintStyle: const TextStyle(color: _C.onv, fontSize: 13),
    filled: true, fillColor: _C.s2, border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: BorderSide.none),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: BorderSide(color: _C.pri.withValues(alpha: 0.2), width: 1.5)));
}

// ── Task Card ─────────────────────────────────────────
class _TaskCard extends StatefulWidget {
  final _Task task; final VoidCallback onDelete, onComplete;
  const _TaskCard({required this.task, required this.onDelete, required this.onComplete});
  @override State<_TaskCard> createState() => _TaskCardState();
}
class _TaskCardState extends State<_TaskCard> {
  bool h = false;
  static const _priColors = {'urgent': Color(0xFFB8534A), 'high': Color(0xFF7B535C), 'medium': Color(0xFFC09050), 'low': Color(0xFF4A654D)};
  static const _priBg = {'urgent': Color(0x1AB8534A), 'high': Color(0x1A7B535C), 'medium': Color(0x1AC09050), 'low': Color(0x1A4A654D)};
  static const _accentGrads = {'urgent': [Color(0xFFB8534A), Color(0xFFD8857E)], 'high': [Color(0xFF7B535C), Color(0xFFD8A7B1)], 'medium': [Color(0xFFC09050), Color(0xFFFFC69C)], 'low': [Color(0xFF4A654D), Color(0xFFCAE6CC)]};
  static const _avColors = {'KM': [Color(0xFF7B535C), Color(0xFFD8A7B1)], 'AJ': [Color(0xFFB87243), Color(0xFFFFC69C)], 'SR': [Color(0xFF4A654D), Color(0xFFCAE6CC)], 'LT': [Color(0xFF4A654D), Color(0xFFCAE6CC)]};

  @override Widget build(BuildContext context) => MouseRegion(cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: AnimatedContainer(duration: const Duration(milliseconds: 200),
      transform: h ? (Matrix4.identity()..setTranslationRaw(0.0, -2.0, 0.0)) : Matrix4.identity(),
      decoration: BoxDecoration(color: _C.s0, borderRadius: BorderRadius.circular(12),
        boxShadow: h ? [BoxShadow(color: _C.sh2, blurRadius: 28)] : [BoxShadow(color: _C.sh, blurRadius: 4)]),
      child: Stack(children: [
        if (h) Positioned(top: 0, left: 0, right: 0, child: Container(height: 3,
          decoration: BoxDecoration(gradient: LinearGradient(colors: _accentGrads[widget.task.priority]!), borderRadius: const BorderRadius.vertical(top: Radius.circular(12))))),
        Padding(padding: const EdgeInsets.fromLTRB(14, 14, 14, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: _priBg[widget.task.priority], borderRadius: BorderRadius.circular(999)),
              child: Text(widget.task.priority[0].toUpperCase() + widget.task.priority.substring(1),
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.08, color: _priColors[widget.task.priority]))),
            const Spacer(),
            AnimatedOpacity(duration: const Duration(milliseconds: 200), opacity: h ? 0.6 : 0,
              child: GestureDetector(onTap: widget.onDelete,
                child: Container(width: 20, height: 20, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: const Icon(Icons.delete_outline_rounded, size: 13, color: _C.onv)))),
          ]),
          const SizedBox(height: 10),
          Text(widget.task.title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, letterSpacing: -0.01, height: 1.35)),
          const SizedBox(height: 8),
          if (widget.task.progress > 0) ...[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('PROGRESS', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.08, color: _C.onv)),
              Text('${widget.task.progress}%', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 4),
            ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(
              value: widget.task.progress / 100, minHeight: 3,
              backgroundColor: _C.s2, color: _C.prL)),
            const SizedBox(height: 8),
          ],
          Row(children: [
            ...widget.task.assignees.take(3).map((a) {
              final colors = _avColors[a] ?? [_C.pri, _C.prL];
              return Container(width: 19, height: 19, margin: const EdgeInsets.only(right: -5),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _C.s0, width: 1.5),
                  gradient: LinearGradient(colors: colors.cast<Color>())),
                child: Center(child: Text(a, style: const TextStyle(fontSize: 7.5, fontWeight: FontWeight.w800, color: Colors.white))));
            }),
          ]),
        ])),
      ])));
}

// ── List Row ──────────────────────────────────────────
class _ListRow extends StatefulWidget {
  final _Task task; final VoidCallback onToggle;
  const _ListRow({required this.task, required this.onToggle});
  @override State<_ListRow> createState() => _ListRowState();
}
class _ListRowState extends State<_ListRow> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: GestureDetector(onTap: widget.onToggle,
      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        transform: h ? (Matrix4.identity()..setTranslationRaw(3.0, 0.0, 0.0)) : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        margin: const EdgeInsets.only(bottom: 7),
        decoration: BoxDecoration(color: _C.s0, borderRadius: BorderRadius.circular(11), boxShadow: h ? [BoxShadow(color: _C.sh2, blurRadius: 14)] : [BoxShadow(color: _C.sh, blurRadius: 3)]),
        child: Row(children: [
          Container(width: 17, height: 17, decoration: BoxDecoration(
            color: widget.task.status == 'done' ? _C.ter : Colors.transparent,
            borderRadius: BorderRadius.circular(5), border: Border.all(color: widget.task.status == 'done' ? _C.ter : _C.s3, width: 1.5)),
            child: widget.task.status == 'done' ? const Icon(Icons.check_rounded, size: 10, color: Colors.white) : null),
          const SizedBox(width: 14),
          Expanded(child: Text(widget.task.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
            decoration: widget.task.status == 'done' ? TextDecoration.lineThrough : null,
            color: widget.task.status == 'done' ? _C.onv.withValues(alpha: 0.5) : _C.on))),
          const SizedBox(width: 12),
          Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(color: _C.s2, borderRadius: BorderRadius.circular(999)),
            child: Text(widget.task.priority, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: _C.onv))),
        ]))));
}

// ── Supporting widgets ────────────────────────────────
class _NavItem extends StatefulWidget {
  final String label; final IconData icon; final String? badge; final bool active; final VoidCallback onTap;
  const _NavItem({required this.label, required this.icon, this.badge, required this.active, required this.onTap});
  @override State<_NavItem> createState() => _NavItemState();
}
class _NavItemState extends State<_NavItem> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: GestureDetector(onTap: widget.onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8), margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(color: widget.active ? _C.s0 : h ? _C.s3 : Colors.transparent, borderRadius: BorderRadius.circular(9),
        boxShadow: widget.active ? [BoxShadow(color: _C.sh2, blurRadius: 12)] : []),
      child: Row(children: [
        Icon(widget.icon, size: 14, color: widget.active ? _C.pri : h ? _C.on : _C.onv),
        const SizedBox(width: 10),
        Expanded(child: Text(widget.label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: widget.active ? _C.pri : h ? _C.on : _C.onv))),
        if (widget.badge != null) Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(color: _C.prL, borderRadius: BorderRadius.circular(999)),
          child: Text(widget.badge!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: _C.pri))),
      ]))));
}

class _VBtn extends StatelessWidget {
  final IconData icon; final bool active; final VoidCallback onTap;
  const _VBtn({required this.icon, required this.active, required this.onTap});
  @override Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: 28, height: 26,
      decoration: BoxDecoration(color: active ? _C.s0 : Colors.transparent, borderRadius: BorderRadius.circular(7),
        boxShadow: active ? [BoxShadow(color: _C.sh2, blurRadius: 5)] : []),
      child: Icon(icon, size: 13, color: active ? _C.on : _C.onv)));
}

class _AddBtn extends StatefulWidget {
  final VoidCallback onTap;
  const _AddBtn({required this.onTap});
  @override State<_AddBtn> createState() => _AddBtnState();
}
class _AddBtnState extends State<_AddBtn> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: GestureDetector(onTap: widget.onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 200),
      transform: h ? (Matrix4.identity()..setTranslationRaw(0.0, -2.0, 0.0)) : Matrix4.identity(),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      decoration: BoxDecoration(color: _C.pri, borderRadius: BorderRadius.circular(9),
        boxShadow: h ? [BoxShadow(color: _C.pri.withValues(alpha: 0.28), blurRadius: 20)] : [BoxShadow(color: _C.pri.withValues(alpha: 0.2), blurRadius: 12)]),
      child: const Row(children: [Icon(Icons.add_rounded, color: Colors.white, size: 14), SizedBox(width: 6), Text('Add Task', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))]))));
}

// ── Ring painter ──────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter(this.progress);
  @override void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 4;
    final track = Paint()..color = const Color(0xFFE6E3DE)..style = PaintingStyle.stroke..strokeWidth = 4.5..strokeCap = StrokeCap.round;
    canvas.drawCircle(c, r, track);
    if (progress > 0) {
      final fill = Paint()..shader = const LinearGradient(colors: [_C.pri, _C.prL]).createShader(Rect.fromCircle(center: c, radius: r))
        ..style = PaintingStyle.stroke..strokeWidth = 4.5..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), -math.pi / 2, 2 * math.pi * progress, false, fill);
    }
  }
  @override bool shouldRepaint(_RingPainter o) => progress != o.progress;
}
