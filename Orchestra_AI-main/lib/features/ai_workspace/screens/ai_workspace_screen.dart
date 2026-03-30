import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Dark palette ──────────────────────────────────────
class _C {
  static const bg         = Color(0xFF0D0D0F);
  static const surface    = Color(0xFF111114);
  static const surfaceEl  = Color(0xFF141418);
  static const surfaceHov = Color(0xFF1A1A20);
  static const border     = Color(0xFF222228);
  static const borderEl   = Color(0xFF2A2A30);
  static const accent     = Color(0xFFC8F135);
  static const accentDim  = Color(0xFF161A0A);
  static const accentBord = Color(0xFF3A4A18);
  static const textPri    = Color(0xFFC8C6BE);
  static const textDim    = Color(0xFF666666);
  static const textMid    = Color(0xFF555555);
  static const textFaint  = Color(0xFF3A3A42);
  static const codeBlue   = Color(0xFF8DB4F5);
  static const codePurple = Color(0xFFB48EF5);
  static const codeCyan   = Color(0xFF61DAFB);
  static const codeGreen  = Color(0xFFA8FF78);
  static const codeComment= Color(0xFF4A5A4A);
}

// ── Data ─────────────────────────────────────────────
class _Msg {
  final bool isUser;
  final String text;
  final String? codeBlock;
  const _Msg({required this.isUser, required this.text, this.codeBlock});
}

const _historyToday = ['React component refactor', 'API error handling guide', 'Landing page copy draft'];
const _historyYesterday = ['Tailwind dark mode setup', 'Design system tokens', 'Blog post: AI in 2025', 'Python data pipeline'];
const _historyLastWeek = ['Postgres query optimization', 'Email onboarding sequence', 'Component design review'];

// ── Screen ────────────────────────────────────────────
class AiWorkspaceScreen extends StatefulWidget {
  const AiWorkspaceScreen({super.key});
  @override State<AiWorkspaceScreen> createState() => _AiWorkspaceScreenState();
}

class _AiWorkspaceScreenState extends State<AiWorkspaceScreen> {
  int _mode = 0; // 0=Code 1=Design 2=Writing
  int _activeHistory = 0;
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isTyping = false;

  final List<_Msg> _messages = const [
    _Msg(isUser: false,
      text: "Hey! I can help you refactor that React component. Here's a cleaner version using hooks and a custom useDebounce hook to optimize renders:",
      codeBlock: "// useDebounce.ts\nimport { useState, useEffect } from 'react'\n\nexport function useDebounce<T>(\n  value: T, delay: number\n): T {\n  const [debouncedValue, setDebouncedValue] =\n    useState<T>(value)\n  useEffect(() => {\n    const timer = setTimeout(\n      () => setDebouncedValue(value), delay\n    )\n    return () => clearTimeout(timer)\n  }, [value, delay])\n  return debouncedValue\n}"),
    _Msg(isUser: true, text: "Can you also add a loading state and error boundary around the component?"),
  ];

  List<_Msg> _msgs = [];

  @override
  void initState() {
    super.initState();
    _msgs = List.from(_messages);
    Future.delayed(Duration.zero, () => _scrollToBottom());
  }

  @override void dispose() { _inputCtrl.dispose(); _scrollCtrl.dispose(); super.dispose(); }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }

  void _send() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() { _msgs.add(_Msg(isUser: true, text: text)); _isTyping = true; });
    _inputCtrl.clear();
    Future.delayed(const Duration(milliseconds: 300), _scrollToBottom);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() { _isTyping = false; _msgs.add(const _Msg(isUser: false, text: "I'll add error boundaries and loading states to the component. Let me work on that for you...")); });
      Future.delayed(const Duration(milliseconds: 200), _scrollToBottom);
    });
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _C.accent)),
      backgroundColor: const Color(0xFF1E2E12),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: _C.accentBord)),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _C.bg,
    body: Column(children: [
      _titleBar(),
      Expanded(child: Row(children: [
        _sideNav(),
        _leftPanel(),
        Expanded(child: _chatArea()),
      ])),
    ]),
  );

  // ── Title Bar ─────────────────────────────────────
  Widget _titleBar() => Container(
    height: 36, color: _C.surface,
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _C.border, width: 0.5))),
    child: Row(children: [
      const SizedBox(width: 14),
      _TrafficBtn(Colors.red), const SizedBox(width: 6),
      _TrafficBtn(const Color(0xFFFEBC2E)), const SizedBox(width: 6),
      _TrafficBtn(const Color(0xFF28C840)),
      const SizedBox(width: 12),
      const Text('Nexus AI Workspace', style: TextStyle(fontSize: 12, color: _C.textDim, letterSpacing: 0.06, fontWeight: FontWeight.w500)),
      const Spacer(),
      _TitleIcon(icon: Icons.subject_rounded), const SizedBox(width: 6),
      _TitleIcon(icon: Icons.adjust_rounded), const SizedBox(width: 14),
    ]),
  );

  // ── Side Nav ──────────────────────────────────────
  Widget _sideNav() => Container(
    width: 52,
    color: _C.surface,
    decoration: const BoxDecoration(border: Border(right: BorderSide(color: _C.border, width: 0.5))),
    child: Column(children: [
      const SizedBox(height: 12),
      Container(width: 32, height: 32, margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: _C.accent, borderRadius: BorderRadius.circular(8)),
        child: const Center(child: Text('▲', style: TextStyle(fontSize: 14, color: Colors.black)))),
      _NavIcon(icon: Icons.chat_bubble_outline_rounded, active: true),
      _NavIcon(icon: Icons.work_outline_rounded),
      _NavIcon(icon: Icons.insert_drive_file_outlined),
      Container(height: 0.5, width: 28, color: _C.border, margin: const EdgeInsets.symmetric(vertical: 6)),
      _NavIcon(icon: Icons.search_rounded),
      _NavIcon(icon: Icons.settings_outlined),
      const Spacer(),
      Container(width: 28, height: 28, margin: const EdgeInsets.only(bottom: 12),
        decoration: const BoxDecoration(shape: BoxShape.circle,
          gradient: LinearGradient(colors: [_C.accent, Color(0xFF7ED321)])),
        child: const Center(child: Text('AJ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black)))),
    ]),
  );

  // ── Left Panel (History) ──────────────────────────
  Widget _leftPanel() => Container(
    width: 220,
    color: _C.surface,
    decoration: const BoxDecoration(border: Border(right: BorderSide(color: _C.border, width: 0.5))),
    child: Column(children: [
      Container(padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _C.border, width: 0.5))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('CHAT HISTORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: _C.textFaint)),
          const SizedBox(height: 10),
          _NewChatBtn(),
        ])),
      Expanded(child: ListView(padding: const EdgeInsets.all(8), children: [
        _HistoryGroup('Today', _historyToday, 0, [0, 1, 2]),
        _HistoryGroup('Yesterday', _historyYesterday, _activeHistory, [3, 4, 5, 6]),
        _HistoryGroup('Last week', _historyLastWeek, _activeHistory, [7, 8, 9]),
      ])),
    ]),
  );

  // ── Chat Area ─────────────────────────────────────
  Widget _chatArea() => Container(
    color: _C.bg,
    child: Column(children: [
      _modeBar(),
      Expanded(child: ListView.builder(
        controller: _scrollCtrl,
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
        itemCount: _msgs.length + (_isTyping ? 1 : 0),
        itemBuilder: (_, i) {
          if (i == _msgs.length) return _typingRow();
          final m = _msgs[i];
          return Padding(padding: const EdgeInsets.only(bottom: 24), child: m.isUser ? _userMsg(m) : _aiMsg(m));
        },
      )),
      _inputArea(),
    ]),
  );

  Widget _modeBar() => Container(
    height: 52,
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF1E1E24), width: 0.5))),
    child: Row(children: [
      const SizedBox(width: 20),
      ...[['Code', 0], ['Design', 1], ['Writing', 2]].map((e) => _ModeBtn(label: e[0] as String, active: _mode == (e[1] as int), onTap: () => setState(() => _mode = e[1] as int))),
      const Spacer(),
      _TopbarBtn(label: 'History', icon: Icons.history_rounded, onTap: () {}),
      const SizedBox(width: 8),
      _TopbarBtn(label: 'Share', icon: Icons.add_box_outlined, onTap: () {}),
      const SizedBox(width: 20),
    ]),
  );

  Widget _aiMsg(_Msg m) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(width: 30, height: 30, decoration: BoxDecoration(
      color: _C.accentDim, borderRadius: BorderRadius.circular(8),
      border: Border.all(color: _C.accentBord, width: 0.5)),
      child: const Center(child: Text('N', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _C.accent)))),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Nexus', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.08, color: _C.textFaint)),
      const SizedBox(height: 6),
      Container(padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _C.surfaceEl, borderRadius: BorderRadius.circular(10), border: Border.all(color: _C.border, width: 0.5)),
        child: Text(m.text, style: const TextStyle(fontSize: 13.5, color: _C.textPri, height: 1.65))),
      if (m.codeBlock != null) ...[const SizedBox(height: 6), _codeBlock(m.codeBlock!)],
      const SizedBox(height: 6),
      Row(children: [
        _ActionBtn('Copy', Icons.copy_outlined, () => _toast('Copied to clipboard')),
        const SizedBox(width: 4),
        _ActionBtn('Regenerate', Icons.refresh_rounded, () => _toast('Regenerating…')),
        const SizedBox(width: 4),
        _ActionBtn('Save', Icons.download_outlined, () => _toast('Saved to project')),
      ]),
    ])),
  ]);

  Widget _userMsg(_Msg m) => Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
    Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      const Text('You', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.08, color: _C.textFaint)),
      const SizedBox(height: 6),
      Container(padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _C.accentDim, borderRadius: BorderRadius.circular(10), border: Border.all(color: _C.accentBord, width: 0.5)),
        child: Text(m.text, style: const TextStyle(fontSize: 13.5, color: Color(0xFFDDE8BE), height: 1.65))),
      const SizedBox(height: 6),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        _ActionBtn('Copy', Icons.copy_outlined, () => _toast('Copied')),
      ]),
    ])),
    const SizedBox(width: 12),
    Container(width: 30, height: 30,
      decoration: BoxDecoration(color: _C.surfaceHov, borderRadius: BorderRadius.circular(8), border: Border.all(color: _C.borderEl, width: 0.5)),
      child: const Center(child: Text('AJ', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFFAAAAAA))))),
  ]);

  Widget _codeBlock(String code) => Container(
    width: double.infinity, padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: const Color(0xFF0A0A0C), borderRadius: BorderRadius.circular(8), border: Border.all(color: _C.border, width: 0.5)),
    child: SelectableText(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 11.5, color: _C.codeBlue, height: 1.7)),
  );

  Widget _typingRow() => Row(children: [
    Container(width: 30, height: 30,
      decoration: BoxDecoration(color: _C.accentDim, borderRadius: BorderRadius.circular(8), border: Border.all(color: _C.accentBord, width: 0.5)),
      child: const Center(child: Text('N', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _C.accent)))),
    const SizedBox(width: 12),
    const _TypingDots(),
  ]);

  Widget _inputArea() => Container(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
    decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFF1A1A20), width: 0.5))),
    child: Container(
      decoration: BoxDecoration(color: _C.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: _C.borderEl, width: 0.5)),
      child: Column(children: [
        TextField(controller: _inputCtrl, maxLines: 4, minLines: 2,
          style: const TextStyle(fontSize: 13.5, color: _C.textPri),
          decoration: const InputDecoration(hintText: 'Ask Nexus anything…', hintStyle: TextStyle(color: _C.textFaint, fontSize: 13.5),
            filled: true, fillColor: Colors.transparent, border: InputBorder.none, contentPadding: EdgeInsets.fromLTRB(14, 12, 14, 8)),
          onSubmitted: (_) => _send(),
          textInputAction: TextInputAction.send,
        ),
        Padding(padding: const EdgeInsets.fromLTRB(10, 0, 10, 10), child: Row(children: [
          _ToolbarBtn('Attach file', Icons.upload_rounded, () => _toast('File upload opened')),
          const SizedBox(width: 4),
          _ToolbarBtn('Code', Icons.code_rounded, () => _toast('Code block inserted')),
          const SizedBox(width: 4),
          _ToolbarBtn('Context', Icons.add_circle_outline_rounded, () {}),
          const Spacer(),
          _SendBtn(onTap: _send),
        ])),
      ]),
    ),
  );
}

// ── Small widgets ─────────────────────────────────────
class _TrafficBtn extends StatelessWidget {
  final Color color;
  const _TrafficBtn(this.color);
  @override Widget build(BuildContext context) => Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

class _TitleIcon extends StatelessWidget {
  final IconData icon;
  const _TitleIcon({required this.icon});
  @override Widget build(BuildContext context) => Container(width: 18, height: 18,
    decoration: BoxDecoration(color: const Color(0xFF1E1E24), borderRadius: BorderRadius.circular(4), border: Border.all(color: _C.borderEl, width: 0.5)),
    child: Icon(icon, size: 10, color: _C.textMid));
}

class _NavIcon extends StatefulWidget {
  final IconData icon; final bool active;
  const _NavIcon({required this.icon, this.active = false});
  @override State<_NavIcon> createState() => _NavIconState();
}
class _NavIconState extends State<_NavIcon> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: AnimatedContainer(duration: const Duration(milliseconds: 150),
      width: 36, height: 36, margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(color: widget.active || h ? const Color(0xFF1E1E24) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
      child: Icon(widget.icon, size: 16, color: widget.active ? _C.accent : h ? const Color(0xFFBBBBBB) : _C.textMid)));
}

class _NewChatBtn extends StatefulWidget {
  @override State<_NewChatBtn> createState() => _NewChatBtnState();
}
class _NewChatBtnState extends State<_NewChatBtn> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: GestureDetector(child: AnimatedOpacity(duration: const Duration(milliseconds: 150), opacity: h ? 0.88 : 1.0,
      child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: BoxDecoration(color: _C.accent, borderRadius: BorderRadius.circular(6)),
        child: const Row(children: [Icon(Icons.add, size: 12, color: Colors.black), SizedBox(width: 6),
          Text('New chat', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black))])))));
}

class _HistoryGroup extends StatelessWidget {
  final String label; final List<String> items; final int activeIndex; final List<int> indices;
  const _HistoryGroup(this.label, this.items, this.activeIndex, this.indices);
  @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.fromLTRB(6, 10, 6, 4),
      child: Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.08, color: Color(0xFF3A3A42)))),
    ...items.asMap().entries.map((e) {
      final isActive = indices[e.key] == 0;
      return _HistoryItem(text: e.value, active: isActive);
    }),
  ]);
}

class _HistoryItem extends StatefulWidget {
  final String text; final bool active;
  const _HistoryItem({required this.text, required this.active});
  @override State<_HistoryItem> createState() => _HistoryItemState();
}
class _HistoryItemState extends State<_HistoryItem> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: AnimatedContainer(duration: const Duration(milliseconds: 120),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(color: widget.active ? const Color(0xFF1E1E26) : h ? const Color(0xFF1A1A20) : Colors.transparent, borderRadius: BorderRadius.circular(6)),
      child: Row(children: [
        Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, color: widget.active ? _C.accent : const Color(0xFF3A3A42))),
        const SizedBox(width: 8),
        Expanded(child: Text(widget.text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: widget.active ? const Color(0xFFCCCCCC) : const Color(0xFF666666)))),
      ])));
}

class _ModeBtn extends StatefulWidget {
  final String label; final bool active; final VoidCallback onTap;
  const _ModeBtn({required this.label, required this.active, required this.onTap});
  @override State<_ModeBtn> createState() => _ModeBtnState();
}
class _ModeBtnState extends State<_ModeBtn> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: GestureDetector(onTap: widget.onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5), margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(color: widget.active ? _C.accentDim : h ? const Color(0xFF16161C) : Colors.transparent,
        borderRadius: BorderRadius.circular(6), border: Border.all(color: widget.active ? _C.accentBord : Colors.transparent, width: 0.5)),
      child: Row(children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: widget.active ? _C.accent : const Color(0xFF444444))),
        const SizedBox(width: 5),
        Text(widget.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: widget.active ? _C.accent : h ? const Color(0xFFAAAAAA) : const Color(0xFF555555))),
      ]))));
}

class _TopbarBtn extends StatefulWidget {
  final String label; final IconData icon; final VoidCallback onTap;
  const _TopbarBtn({required this.label, required this.icon, required this.onTap});
  @override State<_TopbarBtn> createState() => _TopbarBtnState();
}
class _TopbarBtnState extends State<_TopbarBtn> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: GestureDetector(onTap: widget.onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: h ? const Color(0xFF16161C) : Colors.transparent, borderRadius: BorderRadius.circular(6),
        border: Border.all(color: h ? _C.border : _C.border, width: 0.5)),
      child: Row(children: [Icon(widget.icon, size: 12, color: h ? const Color(0xFFAAAAAA) : const Color(0xFF555555)), const SizedBox(width: 4),
        Text(widget.label, style: TextStyle(fontSize: 11, color: h ? const Color(0xFFAAAAAA) : const Color(0xFF555555)))]))));
}

class _ActionBtn extends StatefulWidget {
  final String label; final IconData icon; final VoidCallback onTap;
  const _ActionBtn(this.label, this.icon, this.onTap);
  @override State<_ActionBtn> createState() => _ActionBtnState();
}
class _ActionBtnState extends State<_ActionBtn> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: GestureDetector(onTap: widget.onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 120),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: h ? _C.surfaceHov : Colors.transparent, borderRadius: BorderRadius.circular(5),
        border: Border.all(color: h ? _C.border : Colors.transparent, width: 0.5)),
      child: Row(children: [Icon(widget.icon, size: 11, color: h ? const Color(0xFFAAAAAA) : const Color(0xFF444444)), const SizedBox(width: 4),
        Text(widget.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 0.04, color: h ? const Color(0xFFAAAAAA) : const Color(0xFF444444)))]))));
}

class _ToolbarBtn extends StatefulWidget {
  final String label; final IconData icon; final VoidCallback onTap;
  const _ToolbarBtn(this.label, this.icon, this.onTap);
  @override State<_ToolbarBtn> createState() => _ToolbarBtnState();
}
class _ToolbarBtnState extends State<_ToolbarBtn> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: GestureDetector(onTap: widget.onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 120),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: h ? _C.surfaceHov : Colors.transparent, borderRadius: BorderRadius.circular(6),
        border: Border.all(color: h ? _C.border : Colors.transparent, width: 0.5)),
      child: Row(children: [Icon(widget.icon, size: 13, color: h ? const Color(0xFF888888) : const Color(0xFF444444)), const SizedBox(width: 4),
        Text(widget.label, style: TextStyle(fontSize: 11, color: h ? const Color(0xFF888888) : const Color(0xFF444444)))]))));
}

class _SendBtn extends StatefulWidget {
  final VoidCallback onTap;
  const _SendBtn({required this.onTap});
  @override State<_SendBtn> createState() => _SendBtnState();
}
class _SendBtnState extends State<_SendBtn> {
  bool h = false;
  @override Widget build(BuildContext context) => MouseRegion(cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => h = true), onExit: (_) => setState(() => h = false),
    child: GestureDetector(onTap: widget.onTap, child: AnimatedOpacity(duration: const Duration(milliseconds: 150), opacity: h ? 0.88 : 1.0,
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(color: _C.accent, borderRadius: BorderRadius.circular(7)),
        child: const Row(children: [Text('Send', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black)), SizedBox(width: 6),
          Icon(Icons.send_rounded, size: 12, color: Colors.black)])))));
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();
  @override State<_TypingDots> createState() => _TypingDotsState();
}
class _TypingDotsState extends State<_TypingDots> with TickerProviderStateMixin {
  late final List<AnimationController> _ctrls;
  @override void initState() {
    super.initState();
    _ctrls = List.generate(3, (i) {
      final c = AnimationController(duration: const Duration(milliseconds: 600), vsync: this)..repeat(reverse: true);
      Future.delayed(Duration(milliseconds: i * 200), () { if (mounted) c.repeat(reverse: true); });
      return c;
    });
  }
  @override void dispose() { for (final c in _ctrls) c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) => Padding(
      padding: EdgeInsets.only(right: i < 2 ? 4 : 0),
      child: FadeTransition(opacity: CurvedAnimation(parent: _ctrls[i], curve: Curves.easeInOut),
        child: Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: _C.accentBord)))))));
}
