import { AppLayout } from "@/components/layout/AppLayout";
import { useState, useRef, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Send, Copy, RefreshCw, Sparkles, Code, Palette, PenTool, Clock, Loader2, CheckCircle2 } from "lucide-react";
import { api } from "@/lib/api";
import { toast } from "sonner";

type Mode = "code" | "design" | "writing";

const modes: { id: Mode; label: string; icon: React.ElementType }[] = [
  { id: "code", label: "Code", icon: Code },
  { id: "design", label: "Design", icon: Palette },
  { id: "writing", label: "Writing", icon: PenTool },
];

interface Message {
  role: "user" | "ai";
  content: string;
  agentOutputs?: { agent_name: string; output: string }[];
}

interface HistoryItem {
  goal: string;
  timestamp: string;
}

export default function AIWorkspace() {
  const [mode, setMode] = useState<Mode>("code");
  const [input, setInput] = useState("");
  const [messages, setMessages] = useState<Message[]>([]);
  const [loading, setLoading] = useState(false);
  const [history, setHistory] = useState<HistoryItem[]>([]);
  const bottomRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  const handleSend = async () => {
    const goal = input.trim();
    if (!goal || loading) return;

    const userMsg: Message = { role: "user", content: goal };
    setMessages((prev) => [...prev, userMsg]);
    setInput("");
    setLoading(true);

    try {
      const res = await api.executeGoal(goal);
      const aiMsg: Message = {
        role: "ai",
        content: res.final_result,
        agentOutputs: res.agent_outputs,
      };
      setMessages((prev) => [...prev, aiMsg]);
      setHistory((prev) => [
        { goal, timestamp: new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }) },
        ...prev.slice(0, 9),
      ]);
    } catch (err: unknown) {
      toast.error(err instanceof Error ? err.message : "Failed to reach backend");
      setMessages((prev) => [
        ...prev,
        { role: "ai", content: "⚠️ Could not connect to the backend. Make sure it is running on port 8000." },
      ]);
    } finally {
      setLoading(false);
    }
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === "Enter" && (e.metaKey || e.ctrlKey)) handleSend();
  };

  const copyText = (text: string) => {
    navigator.clipboard.writeText(text);
    toast.success("Copied to clipboard");
  };

  return (
    <AppLayout>
      <div className="flex h-screen overflow-hidden">
        {/* Main Chat Area */}
        <div className="flex-1 flex flex-col min-w-0">
          {/* Header */}
          <div className="flex items-center gap-6 px-8 py-4 shrink-0">
            <div className="flex items-center gap-2">
              <Sparkles className="w-5 h-5 text-primary" />
              <h1 className="text-lg font-bold text-foreground">AI Workspace</h1>
            </div>
            <div className="flex gap-1 surface-container-low rounded-xl p-1">
              {modes.map((m) => (
                <button
                  key={m.id}
                  onClick={() => setMode(m.id)}
                  className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-all duration-200 ${
                    mode === m.id ? "surface-lowest shadow-ambient text-foreground" : "text-muted-foreground hover:text-foreground"
                  }`}
                >
                  <m.icon className="w-3.5 h-3.5" />
                  {m.label}
                </button>
              ))}
            </div>
          </div>

          {/* Messages */}
          <div className="flex-1 overflow-auto px-8 py-4 space-y-6">
            {messages.length === 0 && (
              <motion.div
                initial={{ opacity: 0, y: 12 }}
                animate={{ opacity: 1, y: 0 }}
                className="flex flex-col items-center justify-center h-full gap-4 text-center"
              >
                <div className="w-16 h-16 rounded-2xl gradient-primary flex items-center justify-center shadow-ambient">
                  <Sparkles className="w-8 h-8 text-primary-foreground" />
                </div>
                <h2 className="text-xl font-bold text-foreground">What do you want to build?</h2>
                <p className="text-sm text-muted-foreground max-w-sm leading-relaxed">
                  Describe your goal and OrchestraAI's multi-agent system will research, plan, write, and review a complete solution.
                </p>
              </motion.div>
            )}

            <AnimatePresence>
              {messages.map((msg, i) => (
                <motion.div
                  key={i}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.3 }}
                  className={`flex ${msg.role === "user" ? "justify-end" : "justify-start"}`}
                >
                  <div className={`max-w-[75%] rounded-2xl px-5 py-4 ${
                    msg.role === "user" ? "gradient-primary text-primary-foreground" : "surface-lowest shadow-ambient"
                  }`}>
                    <p className="text-sm leading-relaxed whitespace-pre-wrap">{msg.content}</p>

                    {/* Agent breakdown */}
                    {msg.role === "ai" && msg.agentOutputs && msg.agentOutputs.length > 0 && (
                      <div className="mt-4 space-y-2">
                        <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wider">Agent Outputs</p>
                        {msg.agentOutputs.map((ao, j) => (
                          <div key={j} className="surface-container-low rounded-xl p-3">
                            <div className="flex items-center gap-2 mb-1">
                              <CheckCircle2 className="w-3.5 h-3.5 text-primary shrink-0" />
                              <span className="text-xs font-semibold text-foreground">{ao.agent_name}</span>
                            </div>
                            <p className="text-xs text-muted-foreground leading-relaxed">{ao.output}</p>
                          </div>
                        ))}
                      </div>
                    )}

                    {msg.role === "ai" && (
                      <div className="flex items-center gap-3 mt-4 pt-3 border-t border-border/20">
                        <button onClick={() => copyText(msg.content)}
                          className="flex items-center gap-1.5 text-xs text-muted-foreground hover:text-foreground transition-colors">
                          <Copy className="w-3 h-3" /> Copy
                        </button>
                        <button onClick={() => {
                          const last = messages.findLast((m) => m.role === "user");
                          if (last) { setInput(last.content); }
                        }}
                          className="flex items-center gap-1.5 text-xs text-muted-foreground hover:text-foreground transition-colors">
                          <RefreshCw className="w-3 h-3" /> Retry
                        </button>
                      </div>
                    )}
                  </div>
                </motion.div>
              ))}
            </AnimatePresence>

            {loading && (
              <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="flex justify-start">
                <div className="surface-lowest shadow-ambient rounded-2xl px-5 py-4 flex items-center gap-3">
                  <Loader2 className="w-4 h-4 text-primary animate-spin" />
                  <span className="text-sm text-muted-foreground">Agents working…</span>
                </div>
              </motion.div>
            )}
            <div ref={bottomRef} />
          </div>

          {/* Input */}
          <div className="px-8 pb-6 shrink-0">
            <div className="surface-lowest rounded-2xl shadow-ambient p-4">
              <textarea
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyDown={handleKeyDown}
                placeholder="Describe your goal… (Ctrl+Enter to send)"
                rows={3}
                className="w-full bg-transparent text-foreground placeholder:text-muted-foreground outline-none resize-none text-sm leading-relaxed"
              />
              <div className="flex items-center justify-between pt-2">
                <span className="text-xs text-muted-foreground">Ctrl+Enter to send</span>
                <button
                  onClick={handleSend}
                  disabled={loading || !input.trim()}
                  className="flex items-center gap-2 px-5 py-2.5 rounded-xl gradient-primary text-primary-foreground text-sm font-medium hover:-translate-y-0.5 hover:shadow-lift transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed disabled:translate-y-0"
                >
                  {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Send className="w-4 h-4" />}
                  {loading ? "Running…" : "Send"}
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* History Panel */}
        <div className="w-[260px] shrink-0 surface-container-low p-6 space-y-4 overflow-auto">
          <h3 className="label-meta">Session History</h3>
          {history.length === 0 ? (
            <p className="text-xs text-muted-foreground">No history yet. Send your first goal.</p>
          ) : (
            <div className="space-y-2">
              {history.map((h, i) => (
                <button
                  key={i}
                  onClick={() => setInput(h.goal)}
                  className="flex items-start gap-3 w-full px-3 py-2.5 rounded-xl text-sm text-muted-foreground hover:text-foreground hover:surface-lowest transition-all text-left"
                >
                  <Clock className="w-3.5 h-3.5 shrink-0 mt-0.5" />
                  <div className="min-w-0">
                    <p className="truncate text-xs font-medium text-foreground">{h.goal}</p>
                    <p className="text-xs text-muted-foreground">{h.timestamp}</p>
                  </div>
                </button>
              ))}
            </div>
          )}
        </div>
      </div>
    </AppLayout>
  );
}
