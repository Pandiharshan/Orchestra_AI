import { AppLayout } from "@/components/layout/AppLayout";
import { TopBar } from "@/components/layout/TopBar";
import { motion, AnimatePresence } from "framer-motion";
import { useState, useEffect } from "react";
import { Check, Trash2, Loader2 } from "lucide-react";
import { api, type LogEntry } from "@/lib/api";

type Category = "all" | "system" | "agent" | "goal";

interface Notification {
  id: string;
  title: string;
  desc: string;
  time: string;
  category: Category;
  read: boolean;
}

function logToNotification(log: LogEntry, index: number): Notification {
  const categoryMap: Record<string, Category> = {
    goal_received: "goal",
    agent_completed: "agent",
    orchestration_complete: "system",
  };
  const titleMap: Record<string, string> = {
    goal_received: "New goal submitted",
    agent_completed: `${log.agent ?? "Agent"} completed`,
    orchestration_complete: "Orchestration complete",
  };
  const descMap: Record<string, string> = {
    goal_received: `Goal: "${log.goal ?? ""}"`,
    agent_completed: `${log.agent ?? "Agent"} finished processing "${log.goal ?? ""}"`,
    orchestration_complete: `All agents finished for: "${log.goal ?? ""}"`,
  };
  const d = new Date(log.timestamp);
  const time = isNaN(d.getTime()) ? "—" : d.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });

  return {
    id: String(index),
    title: titleMap[log.event] ?? log.event,
    desc: descMap[log.event] ?? "",
    time,
    category: categoryMap[log.event] ?? "system",
    read: false,
  };
}

export default function Notifications() {
  const [category, setCategory] = useState<Category>("all");
  const [items, setItems] = useState<Notification[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.getLogs()
      .then((res) => {
        setItems(res.logs.map((l, i) => logToNotification(l, i)).reverse());
      })
      .catch(() => setItems([]))
      .finally(() => setLoading(false));
  }, []);

  const filtered = items.filter((n) => category === "all" || n.category === category);
  const markAllRead = () => setItems((prev) => prev.map((n) => ({ ...n, read: true })));
  const toggleRead = (id: string) => setItems((prev) => prev.map((n) => n.id === id ? { ...n, read: !n.read } : n));
  const clearAll = () => setItems([]);

  return (
    <AppLayout>
      <TopBar title="Notifications">
        <button onClick={markAllRead} className="text-sm text-primary hover:underline">Mark all as read</button>
        <button onClick={clearAll} className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-destructive transition-colors">
          <Trash2 className="w-3.5 h-3.5" /> Clear all
        </button>
      </TopBar>

      <div className="px-8 pb-10">
        <div className="flex gap-2 mb-8">
          {(["all", "system", "agent", "goal"] as Category[]).map((c) => (
            <button key={c} onClick={() => setCategory(c)}
              className={`px-4 py-2 rounded-xl text-sm font-medium capitalize transition-all duration-200 ${category === c ? "surface-lowest shadow-ambient text-foreground" : "text-muted-foreground hover:text-foreground"}`}>
              {c}
            </button>
          ))}
        </div>

        {loading ? (
          <div className="flex items-center gap-3 text-muted-foreground py-12 justify-center">
            <Loader2 className="w-5 h-5 animate-spin" />
            <span className="text-sm">Loading from backend…</span>
          </div>
        ) : (
          <div className="space-y-2 max-w-3xl">
            <AnimatePresence>
              {filtered.map((n, i) => (
                <motion.div key={n.id} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, x: -20 }} transition={{ delay: i * 0.03 }}
                  onClick={() => toggleRead(n.id)}
                  className={`flex items-start gap-4 px-5 py-4 rounded-2xl cursor-pointer transition-all duration-200 ${n.read ? "hover:surface-container-low" : "surface-lowest shadow-ambient"}`}>
                  <div className={`w-2 h-2 rounded-full mt-2 shrink-0 ${n.read ? "bg-muted" : "bg-primary"}`} />
                  <div className="flex-1 min-w-0">
                    <h4 className={`text-sm font-medium ${n.read ? "text-muted-foreground" : "text-foreground"}`}>{n.title}</h4>
                    <p className="text-xs text-muted-foreground mt-0.5 truncate">{n.desc}</p>
                  </div>
                  <span className="text-xs text-muted-foreground shrink-0">{n.time}</span>
                  {!n.read && <Check className="w-4 h-4 text-muted-foreground hover:text-primary shrink-0 mt-0.5" />}
                </motion.div>
              ))}
            </AnimatePresence>
            {filtered.length === 0 && (
              <p className="text-sm text-muted-foreground text-center py-12">
                {items.length === 0 ? "No notifications yet. Run a goal in AI Workspace to generate activity." : "No notifications in this category."}
              </p>
            )}
          </div>
        )}
      </div>
    </AppLayout>
  );
}
