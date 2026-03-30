import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../file_manager/screens/file_manager_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../tasks/screens/tasks_screen.dart';

class _C {
  static const bg                  = Color(0xFFFCF9F4);
  static const surface             = Color(0xFFFFFFFF);
  static const surfaceContainer    = Color(0xFFF0EDE9);
  static const surfaceContainerLow = Color(0xFFF7F4F0);
  static const primary             = Color(0xFF7B535C);
  static const primaryContainer    = Color(0xFFD8A7B1);
  static const primaryLight        = Color(0xFFEDDDE0);
  static const secondary           = Color(0xFFFFC69C);
  static const onSecondary         = Color(0xFF4A2C10);
  static const onSurface           = Color(0xFF1C1C19);
  static const onSurfaceVar        = Color(0xFF504446);
  static const tertiary            = Color(0xFF4A654D);
  static const outline             = Color(0x26504446);
  static const shadow              = Color(0x0A1C1C19);
}

class _Agent {
  final String id, name, emoji, desc, systemPrompt;
  const _Agent({required this.id, required this.name, required this.emoji,
      required this.desc, required this.systemPrompt});
}

const _kAgents = [
  _Agent(id:'research', name:'Research', emoji:'🔍', desc:'Searches & gathers data',
      systemPrompt:'You are a Research Agent. Return concise bullet-point findings.'),
  _Agent(id:'planner', name:'Planner', emoji:'📅', desc:'Creates timelines & plans',
      systemPrompt:'You are a Planner Agent. Return a numbered, actionable step-by-step plan.'),
  _Agent(id:'writer', name:'Writer', emoji:'✍️', desc:'Drafts content & summaries',
      systemPrompt:'You are a Writer Agent. Return well-structured, engaging written content.'),
  _Agent(id:'coder', name:'Coder', emoji:'💻', desc:'Generates code & scripts',
      systemPrompt:'You are a Coder Agent. Return working code with brief explanations.'),
  _Agent(id:'reviewer', name:'Reviewer', emoji:'✅', desc:'Validates & refines output',
      systemPrompt:'You are a Reviewer Agent. Validate the approach and list quality notes.'),
];

enum _View { hero, app }
enum _AgentStatus { waiting, running, done }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  _View _view = _View.hero;
  final _goalCtrl = TextEditingController();
  String _goal = '';
  bool _isRunning = false, _isDone = false;
  String _conductorStatus = 'Ready';
  final Map<String, _AgentStatus> _agentStatus = {for (final a in _kAgents) a.id: _AgentStatus.waiting};
  final Map<String, String> _agentOutputs = {}, _plan = {};
  String _finalText = '';
  final List<String> _logs = [];
  final Map<String, bool> _outputExpanded = {};

  static const _apiKey = 'YOUR_ANTHROPIC_API_KEY'; // 🔑 replace

  @override void dispose() { _goalCtrl.dispose(); super.dispose(); }

  void _log(String msg) {
    final t = TimeOfDay.now();
    setState(() => _logs.add('${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}  $msg'));
  }

  Future<void> _run() async {
    final goal = _goalCtrl.text.trim();
    if (goal.isEmpty) return;
    setState(() {
      _goal=goal; _view=_View.app; _isRunning=true; _isDone=false;
      _conductorStatus='Orchestrating agents on backend...';
      _logs.clear(); _agentOutputs.clear(); _plan.clear(); _outputExpanded.clear(); _finalText='';
      for (final a in _kAgents) _agentStatus[a.id]=_AgentStatus.running;
    });
    _log('🎼 Conductor analyzing via Python backend...');

    try {
      final res = await http.post(
        Uri.parse('http://127.0.0.1:8000/execute-goal'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'goal': goal}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final finalResult = data['final_result'] as String;
        final outputs = data['agent_outputs'] as List;

        setState(() {
          for (final a in _kAgents) {
            _agentStatus[a.id] = _AgentStatus.done;
            _plan[a.id] = "Executed using backend agent pipeline.";
            // Try to find matching output if possible
            final match = outputs.where((o) => (o['agent_name'] as String).toLowerCase().contains(a.id)).firstOrNull;
            _agentOutputs[a.id] = match != null ? match['output'] : "Agent task completed.";
            _outputExpanded[a.id] = false;
          }
          _finalText = finalResult;
          _conductorStatus = 'Complete. Final result ready.';
          _isRunning = false;
          _isDone = true;
        });
        _log('🎉 OrchestraAI backend execution complete!');
      } else {
        setState(() {
          _conductorStatus = 'Error: ${res.statusCode}';
          _isRunning = false; 
          for (final a in _kAgents) _agentStatus[a.id] = _AgentStatus.waiting;
        });
        _log('❌ Backend returned error ${res.statusCode}.');
      }
    } catch (e) {
      setState(() {
        _conductorStatus = 'Connection Error: $e';
        _isRunning = false;
        for (final a in _kAgents) _agentStatus[a.id] = _AgentStatus.waiting;
      });
      _log('❌ Could not connect to backend. Is it running?');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _C.bg,
    body: Stack(children: [
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (c,a) => FadeTransition(opacity:a, child:c),
        child: _view==_View.hero ? _hero() : _appView(),
      ),
      _nav(),
    ]),
  );

  Widget _nav() => Positioned(top:20, left:0, right:0, child: Center(child: Container(
    decoration: BoxDecoration(color:const Color(0xCCFCF9F4), borderRadius:BorderRadius.circular(999),
      boxShadow:[BoxShadow(color:_C.shadow, blurRadius:32, offset:const Offset(0,8))]),
    padding: const EdgeInsets.symmetric(horizontal:28, vertical:14),
    child: Row(mainAxisSize:MainAxisSize.min, children:[
      const Text('🎼', style:TextStyle(fontSize:16)),
      const SizedBox(width:6),
      const Text('OrchestraAI', style:TextStyle(fontSize:15, fontWeight:FontWeight.w800, color:_C.primary, letterSpacing:-0.3)),
      const SizedBox(width:32),
      _NL('Home', ()=>setState(()=>_view=_View.hero)),
      const SizedBox(width:20),
      _NL('Try it', _isRunning ? (){}  : ()=>_run()),
      const SizedBox(width:20),
      _NL('Tasks', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TasksScreen()))),
      const SizedBox(width:20),
      _NL('Files', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FileManagerScreen()))),
      const SizedBox(width:20),
      _NL('Settings', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()))),
    ]),
  )));

  Widget _hero() => SingleChildScrollView(
    key: const ValueKey('hero'),
    child: SizedBox(height: MediaQuery.of(context).size.height, child: Stack(children:[
      Positioned.fill(child: Container(decoration: BoxDecoration(
        gradient: LinearGradient(colors:[_C.primary.withValues(alpha: 0.07), _C.primaryContainer.withValues(alpha: 0.07)],
          begin:Alignment.topLeft, end:Alignment.bottomRight)))),
      Center(child: Padding(padding: const EdgeInsets.fromLTRB(40,116,40,40),
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth:860),
          child: Column(crossAxisAlignment:CrossAxisAlignment.start, mainAxisAlignment:MainAxisAlignment.center, children:[
            const Text('AGENTIC AI · MULTI-AGENT ORCHESTRATION',
              style:TextStyle(fontSize:11, fontWeight:FontWeight.w600, letterSpacing:0.8, color:_C.primary)),
            const SizedBox(height:20),
            RichText(text: const TextSpan(style:TextStyle(fontSize:52, fontWeight:FontWeight.w800, height:1.08, letterSpacing:-1.2, color:_C.onSurface), children:[
              TextSpan(text:'One goal.\n'),
              TextSpan(text:'Many agents.', style:TextStyle(color:_C.primary)),
              TextSpan(text:'\nOne result.'),
            ])),
            const SizedBox(height:20),
            const Text('OrchestraAI assigns your complex goals to specialized AI agents — Research, Plan, Write, Code, Review — all coordinated by a master Conductor.',
              style:TextStyle(fontSize:16, color:_C.onSurfaceVar, height:1.6)),
            const SizedBox(height:40),
            _goalCard(),
          ]),
        ),
      )),
    ])),
  );

  Widget _goalCard() => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth:620),
    child: Container(
      decoration: BoxDecoration(color:_C.surface, borderRadius:BorderRadius.circular(20),
        boxShadow:[BoxShadow(color:_C.shadow, blurRadius:64)]),
      padding: const EdgeInsets.all(22),
      child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        const Text('YOUR GOAL', style:TextStyle(fontSize:11, fontWeight:FontWeight.w600, letterSpacing:0.8, color:_C.onSurfaceVar)),
        const SizedBox(height:12),
        Row(crossAxisAlignment:CrossAxisAlignment.end, children:[
          Expanded(child: TextField(controller:_goalCtrl, maxLines:3, minLines:1,
            style: const TextStyle(fontSize:15, color:_C.onSurface),
            decoration: InputDecoration(
              hintText:'e.g. Plan and write content for my SaaS product launch...',
              hintStyle: TextStyle(color:_C.onSurfaceVar.withValues(alpha: 0.5), fontSize:15),
              filled:true, fillColor:_C.surfaceContainerLow,
              border:OutlineInputBorder(borderRadius:BorderRadius.circular(12), borderSide:BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal:16, vertical:14)),
            onSubmitted:(_)=>_run())),
          const SizedBox(width:12),
          _PBtn(label:'▶  Orchestrate', onTap:_isRunning ? null : _run),
        ]),
        const SizedBox(height:14),
        Wrap(spacing:8, runSpacing:8, children:[
          _Chip('Product launch', ()=>_goalCtrl.text='Plan a product launch for my SaaS app'),
          _Chip('AI trends report', ()=>_goalCtrl.text='Research latest AI trends and write a report'),
          _Chip('Study plan', ()=>_goalCtrl.text='Create a full study plan for my semester exams'),
        ]),
      ]),
    ),
  );

  Widget _appView() => SingleChildScrollView(
    key: const ValueKey('app'),
    padding: const EdgeInsets.fromLTRB(40,100,40,60),
    child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth:860),
      child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        Row(crossAxisAlignment:CrossAxisAlignment.start, children:[
          Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
            const Text('ACTIVE GOAL', style:TextStyle(fontSize:11, fontWeight:FontWeight.w600, letterSpacing:0.8, color:_C.onSurfaceVar)),
            const SizedBox(height:4),
            Text(_goal, style:const TextStyle(fontSize:18, fontWeight:FontWeight.w700, color:_C.onSurface, letterSpacing:-0.3)),
          ])),
          _RBtn(onTap:()=>setState((){_view=_View.hero; _goalCtrl.clear();})),
        ]),
        const SizedBox(height:28),
        _condBar(),
        const SizedBox(height:20),
        if (_plan.isNotEmpty) ...[_planSec(), const SizedBox(height:20)],
        _agentGrid(),
        const SizedBox(height:20),
        if (_agentOutputs.isNotEmpty) ...[_outputSec(), const SizedBox(height:20)],
        if (_finalText.isNotEmpty) ...[_finalSec(), const SizedBox(height:20)],
        if (_logs.isNotEmpty) _logSec(),
      ]),
    )),
  );

  Widget _condBar() => Container(
    decoration:BoxDecoration(color:_C.surface, borderRadius:BorderRadius.circular(16), boxShadow:[BoxShadow(color:_C.shadow,blurRadius:64)]),
    padding:const EdgeInsets.all(22),
    child:Row(children:[
      Container(width:44,height:44, decoration:BoxDecoration(shape:BoxShape.circle, gradient:const LinearGradient(colors:[_C.primary,_C.primaryContainer])),
        child:const Center(child:Text('🎼',style:TextStyle(fontSize:20)))),
      const SizedBox(width:16),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        const Text('CONDUCTOR AGENT', style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,letterSpacing:0.8,color:_C.primary)),
        const SizedBox(height:2),
        Text(_conductorStatus, style:const TextStyle(fontSize:14,color:_C.onSurfaceVar)),
      ])),
      if (_isRunning) const SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:2,color:_C.primary))
      else if (_isDone) Container(
        padding:const EdgeInsets.symmetric(horizontal:12,vertical:5),
        decoration:BoxDecoration(color:_C.tertiary.withValues(alpha: 0.12),borderRadius:BorderRadius.circular(999)),
        child:const Text('COMPLETE',style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,letterSpacing:0.8,color:_C.tertiary))),
    ]),
  );

  Widget _planSec() => Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
    const Text('EXECUTION PLAN', style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,letterSpacing:0.8,color:_C.onSurfaceVar)),
    const SizedBox(height:12),
    Wrap(spacing:10,runSpacing:10, children:_kAgents.map((a)=>SizedBox(width:240,
      child:Container(decoration:BoxDecoration(color:_C.surfaceContainer,borderRadius:BorderRadius.circular(12)),
        padding:const EdgeInsets.all(14),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
          Text('${a.emoji} ${a.name.toUpperCase()}',style:const TextStyle(fontSize:10,fontWeight:FontWeight.w600,letterSpacing:0.8,color:_C.primary)),
          const SizedBox(height:4),
          Text(_plan[a.id]??'—', style:const TextStyle(fontSize:12,color:_C.onSurfaceVar,height:1.4)),
        ])))).toList()),
  ]);

  Widget _agentGrid() => Wrap(spacing:12,runSpacing:12, children:_kAgents.map((a){
    final st=_agentStatus[a.id]??_AgentStatus.waiting;
    final active=st==_AgentStatus.running, done=st==_AgentStatus.done;
    return AnimatedContainer(duration:const Duration(milliseconds:200), width:160, height:140,
      decoration:BoxDecoration(color:done?_C.surfaceContainerLow:_C.surface, borderRadius:BorderRadius.circular(16),
        border:active?Border.all(color:_C.primary,width:2):null,
        boxShadow:active?[BoxShadow(color:_C.primary.withValues(alpha: 0.12),blurRadius:48)]:[BoxShadow(color:_C.shadow,blurRadius:8)]),
      padding:const EdgeInsets.all(16),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        Text(a.emoji,style:const TextStyle(fontSize:22)),
        const SizedBox(height:6),
        Text(a.name,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w700,color:_C.onSurface,letterSpacing:-0.2)),
        Text(a.desc,style:const TextStyle(fontSize:11,color:_C.onSurfaceVar,height:1.4)),
        const Spacer(),
        Row(children:[
          Container(width:7,height:7,decoration:BoxDecoration(shape:BoxShape.circle,color:done?_C.tertiary:active?_C.secondary:_C.outline)),
          const SizedBox(width:6),
          Text(done?'Done ✓':active?'Working...':'Waiting',
            style:TextStyle(fontSize:10,fontWeight:FontWeight.w600,letterSpacing:0.8,
              color:done?_C.tertiary:active?_C.onSecondary:_C.onSurfaceVar.withValues(alpha: 0.4))),
        ]),
      ]));
  }).toList());

  Widget _outputSec() => Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
    const Text('AGENT OUTPUTS', style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,letterSpacing:0.8,color:_C.onSurfaceVar)),
    const SizedBox(height:12),
    ..._kAgents.where((a)=>_agentOutputs.containsKey(a.id)).map((a){
      final expanded=_outputExpanded[a.id]??false;
      return Container(margin:const EdgeInsets.only(bottom:10),
        decoration:BoxDecoration(color:_C.surface,borderRadius:BorderRadius.circular(16),boxShadow:[BoxShadow(color:_C.shadow,blurRadius:24)]),
        child:Column(children:[
          InkWell(onTap:()=>setState(()=>_outputExpanded[a.id]=!expanded),
            borderRadius:BorderRadius.vertical(top:const Radius.circular(16),bottom:Radius.circular(expanded?0:16)),
            child:Padding(padding:const EdgeInsets.symmetric(horizontal:20,vertical:14),
              child:Row(children:[
                Text(a.emoji,style:const TextStyle(fontSize:16)),const SizedBox(width:10),
                Text(a.name.toUpperCase(),style:const TextStyle(fontSize:11,fontWeight:FontWeight.w600,letterSpacing:0.8,color:_C.primary)),
                const SizedBox(width:10),
                Expanded(child:Text((_plan[a.id]??a.desc).length>55?'${(_plan[a.id]??a.desc).substring(0,55)}...':(_plan[a.id]??a.desc),
                  style:const TextStyle(fontSize:12,color:_C.onSurfaceVar),overflow:TextOverflow.ellipsis)),
                Icon(expanded?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,size:16,color:_C.onSurfaceVar),
              ]))),
          if (expanded) Container(width:double.infinity, padding:const EdgeInsets.fromLTRB(20,14,20,18),
            decoration:const BoxDecoration(border:Border(top:BorderSide(color:_C.outline)),
              borderRadius:BorderRadius.vertical(bottom:Radius.circular(16))),
            child:SelectableText(_agentOutputs[a.id]!,style:const TextStyle(fontSize:13,color:_C.onSurfaceVar,height:1.7))),
        ]));
    }),
  ]);

  Widget _finalSec() => Container(
    decoration:BoxDecoration(color:_C.surface,borderRadius:BorderRadius.circular(20),boxShadow:[BoxShadow(color:_C.shadow,blurRadius:64)]),
    padding:const EdgeInsets.all(28),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      Row(children:[
        Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:5),
          decoration:BoxDecoration(gradient:const LinearGradient(colors:[_C.primary,_C.primaryContainer]),borderRadius:BorderRadius.circular(999)),
          child:const Text('FINAL RESULT',style:TextStyle(color:Colors.white,fontSize:11,fontWeight:FontWeight.w700,letterSpacing:0.8))),
        const SizedBox(width:12),
        const Text('OrchestraAI Complete',style:TextStyle(fontSize:17,fontWeight:FontWeight.w700,color:_C.onSurface,letterSpacing:-0.3)),
      ]),
      const SizedBox(height:20),
      SelectableText(_finalText,style:const TextStyle(fontSize:14,color:_C.onSurfaceVar,height:1.8)),
      const SizedBox(height:20),
      _SBtn(label:'Copy Result', onTap:(){
        Clipboard.setData(ClipboardData(text:_finalText));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Copied!'),duration:Duration(seconds:2),behavior:SnackBarBehavior.floating));
      }),
    ]),
  );

  Widget _logSec() => Container(
    decoration:BoxDecoration(color:_C.surfaceContainer,borderRadius:BorderRadius.circular(16)),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      const Padding(padding:EdgeInsets.fromLTRB(20,14,20,8),
        child:Text('ACTIVITY LOG',style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,letterSpacing:0.8,color:_C.onSurfaceVar))),
      ConstrainedBox(constraints:const BoxConstraints(maxHeight:180),
        child:ListView.builder(shrinkWrap:true, padding:const EdgeInsets.fromLTRB(20,0,20,14), itemCount:_logs.length,
          itemBuilder:(_,i){
            final p=_logs[i].split('  ');
            return Padding(padding:const EdgeInsets.symmetric(vertical:2),
              child:Row(crossAxisAlignment:CrossAxisAlignment.start, children:[
                SizedBox(width:60,child:Text(p.first,style:TextStyle(fontSize:12,color:_C.onSurfaceVar.withValues(alpha: 0.4)))),
                Expanded(child:Text(p.length>1?p.sublist(1).join('  '):'',style:const TextStyle(fontSize:12,color:_C.onSurfaceVar))),
              ]));
          })),
    ]),
  );
}

// ── Helper Widgets ────────────────────────────────────
class _NL extends StatefulWidget {
  final String l; final VoidCallback t;
  const _NL(this.l, this.t);
  @override State<_NL> createState() => _NLS();
}
class _NLS extends State<_NL> {
  bool h=false;
  @override Widget build(BuildContext context) => MouseRegion(cursor:SystemMouseCursors.click,
    onEnter:(_)=>setState(()=>h=true), onExit:(_)=>setState(()=>h=false),
    child:GestureDetector(onTap:widget.t, child:Text(widget.l.toUpperCase(),
      style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,letterSpacing:0.8,color:h?_C.primary:_C.onSurfaceVar))));
}

class _PBtn extends StatefulWidget {
  final String label; final VoidCallback? onTap;
  const _PBtn({required this.label, this.onTap});
  @override State<_PBtn> createState() => _PBtnS();
}
class _PBtnS extends State<_PBtn> {
  bool h=false;
  @override Widget build(BuildContext context) => MouseRegion(
    cursor:widget.onTap==null?SystemMouseCursors.basic:SystemMouseCursors.click,
    onEnter:(_)=>setState(()=>h=true), onExit:(_)=>setState(()=>h=false),
    child:GestureDetector(onTap:widget.onTap, child:AnimatedContainer(duration:const Duration(milliseconds:200),
      transform:h&&widget.onTap!=null?(Matrix4.identity()..setTranslationRaw(0.0, -2.0, 0.0)):Matrix4.identity(),
      decoration:BoxDecoration(color:widget.onTap==null?_C.primary.withValues(alpha: 0.45):_C.primary, borderRadius:BorderRadius.circular(12),
        boxShadow:h&&widget.onTap!=null?[BoxShadow(color:_C.primary.withValues(alpha: 0.25),blurRadius:32,offset:const Offset(0,12))]:[]),
      padding:const EdgeInsets.symmetric(horizontal:22,vertical:15),
      child:Text(widget.label,style:const TextStyle(color:Colors.white,fontSize:13,fontWeight:FontWeight.w700,letterSpacing:-0.2)))));
}

class _SBtn extends StatefulWidget {
  final String label; final VoidCallback onTap;
  const _SBtn({required this.label, required this.onTap});
  @override State<_SBtn> createState() => _SBtnS();
}
class _SBtnS extends State<_SBtn> {
  bool h=false;
  @override Widget build(BuildContext context) => MouseRegion(cursor:SystemMouseCursors.click,
    onEnter:(_)=>setState(()=>h=true), onExit:(_)=>setState(()=>h=false),
    child:GestureDetector(onTap:widget.onTap, child:AnimatedContainer(duration:const Duration(milliseconds:200),
      transform:h?(Matrix4.identity()..setTranslationRaw(0.0, -2.0, 0.0)):Matrix4.identity(),
      decoration:BoxDecoration(color:_C.secondary,borderRadius:BorderRadius.circular(12),
        boxShadow:h?[BoxShadow(color:_C.secondary.withValues(alpha: 0.3),blurRadius:24,offset:const Offset(0,8))]:[]),
      padding:const EdgeInsets.symmetric(horizontal:20,vertical:12),
      child:Text(widget.label,style:const TextStyle(color:_C.onSecondary,fontSize:13,fontWeight:FontWeight.w700)))));
}

class _RBtn extends StatefulWidget {
  final VoidCallback onTap;
  const _RBtn({required this.onTap});
  @override State<_RBtn> createState() => _RBtnS();
}
class _RBtnS extends State<_RBtn> {
  bool h=false;
  @override Widget build(BuildContext context) => MouseRegion(cursor:SystemMouseCursors.click,
    onEnter:(_)=>setState(()=>h=true), onExit:(_)=>setState(()=>h=false),
    child:GestureDetector(onTap:widget.onTap, child:AnimatedContainer(duration:const Duration(milliseconds:200),
      decoration:BoxDecoration(color:h?_C.primaryLight:Colors.transparent, border:Border.all(color:_C.outline), borderRadius:BorderRadius.circular(999)),
      padding:const EdgeInsets.symmetric(horizontal:16,vertical:8),
      child:Text('↺  New Goal',style:TextStyle(fontSize:12,fontWeight:FontWeight.w600,color:h?_C.primary:_C.onSurfaceVar)))));
}

class _Chip extends StatefulWidget {
  final String label; final VoidCallback onTap;
  const _Chip(this.label, this.onTap);
  @override State<_Chip> createState() => _ChipS();
}
class _ChipS extends State<_Chip> {
  bool h=false;
  @override Widget build(BuildContext context) => MouseRegion(cursor:SystemMouseCursors.click,
    onEnter:(_)=>setState(()=>h=true), onExit:(_)=>setState(()=>h=false),
    child:GestureDetector(onTap:widget.onTap, child:AnimatedContainer(duration:const Duration(milliseconds:200),
      decoration:BoxDecoration(color:h?_C.primaryLight:_C.surfaceContainer,borderRadius:BorderRadius.circular(999)),
      padding:const EdgeInsets.symmetric(horizontal:14,vertical:7),
      child:Text(widget.label,style:TextStyle(fontSize:12,fontWeight:FontWeight.w500,color:h?_C.primary:_C.onSurfaceVar)))));
}
