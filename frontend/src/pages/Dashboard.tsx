import { AppLayout } from "@/components/layout/AppLayout";
import { TopBar } from "@/components/layout/TopBar";
import { motion } from "framer-motion";
import { useEffect, useState } from "react";
import { CheckSquare, FolderKanban, Sparkles, ArrowRight, Plus, Zap, Loader2 } from "lucide-react";
import { api, type LogEntry } from "@/lib/api";
import { useNavigate } from "react-router-dom";

const container = {
  hidden: { opacity: 0 },
  show: { opacity: 1, transition: { staggerChildren: 0.08, delayChildren: 0.1 } },
};
const item = {
  hidden: { opacity: 0, y: 12 },
  show: { opacity: 1, y: 0, transition: { duration: 0.4, ease: [0.22, 1, 0.36, 1] } },
};

export default function Dashboard() {
  const [logs, setLogs] = useState<LogEntry[]>([]);
  const [logsLoading, setLogsLoading] = useState(true);
  const [backendStatus, setBackendStatus] = useState<"checking" | "online" | "offline">("checking");
  const navigate = useNavigate();

  useEffect(() => {
    api.health()
      .then(() => setBackendStatus("online"))
      .catch(() => setBackendStatus("offline"));

    api.getLogs()
      .then((res) => setLogs(res.logs))
      .catch(() => setLogs([]))
      .finally(() => setLogsLoading(false));
  }, []);

  const stats = [
    {
      label: "Backend Status",
      value: backendStatus === "checking" ? "…" : backendStatus === "online" ? "Online" : "Offline",
      change: backendStatus === "online" ? "Connected" : "Check backend",
      icon: CheckSquare,
      color: backendStatus === "online" ? "text-primary" : "text-destructive",
    },
    {
      label: "Agent Logs",
      value: logsLoading ? "…" : String(logs.length),
      change: "From /logs endpoint",
      icon: FolderKanban,
      color: "text-primary",
    },
    {
      label: "AI Workspace",
      value: "Ready",
      change: "Multi-agent system",
      icon: Sparkles,
      color: "text-primary",
    },
  ];

  const quickActions = [
    { label: "New AI Goal", icon: Plus, action: () => navigate("/ai"), variant: "primary" as const },
    { label: "View Projects", icon: FolderKanban, action: () => navigate("/projects"), variant: "secondary" as const },
    { label: "AI Workspace", icon: Sparkles, action: () => navigate("/ai"), variant: "muted" as const },
  ];

  return (
    <AppLayout>
      <TopBar />
      <div className="px-8 pb-10">
        <motion.div variants={container} initial="hidden" animate="show" className="grid grid-cols-3 gap-5 mb-10">
          {stats.map((stat) => (
            <motion.div
              key={stat.label}
              variants={item}
              whileHover={{ y: -3, transition: { duration: 0.2 } }}
              className="surface-lowest rounded-2xl p-6 neu-raised hover:neu-hover transition-all duration-200"
            >
              <div className="flex items-start justify-between mb-4">
                <div className="p-2.5 rounded-xl surface-container-low neu-raised-sm">
                  <stat.icon className={`w-5 h-5 ${stat.color}`} />
                </div>
              </div>
              <p className="text-3xl font-bold text-foreground mb-1">{stat.value}</p>
              <p className="label-meta">{stat.label}</p>
              <p className="text-xs text-muted-foreground mt-2">{stat.change}</p>
            </motion.div>
          ))}
        </motion.div>

        <div className="grid grid-cols-3 gap-8">
          <motion.div variants={container} initial="hidden" animate="show" className="col-span-2 space-y-5">
            <div className="flex items-center justify-between">
              <h2 className="text-lg font-bold text-foreground">Agent Activity Logs</h2>
              <motion.button whileHover={{ x: 4 }} onClick={() => navigate("/ai")}
                className="text-sm text-primary flex items-center gap-1 transition-all">
                Open AI <ArrowRight className="w-3.5 h-3.5" />
              </motion.button>
            </div>

            <div className="surface-lowest rounded-2xl p-5 neu-raised min-h-[160px]">
              {logsLoading ? (
                <div className="flex items-center gap-3 text-muted-foreground">
                  <Loader2 className="w-4 h-4 animate-spin" />
                  <span className="text-sm">Loading logs from backend…</span>
                </div>
              ) : logs.length === 0 ? (
                <p className="text-sm text-muted-foreground">No logs yet. Run a goal in AI Workspace to see agent activity.</p>
              ) : (
                <div className="space-y-1">
                  {logs.map((log, i) => (
                    <motion.div key={i} variants={item}
                      className="flex items-center gap-3 px-3 py-2.5 rounded-xl hover:surface-container-low transition-colors">
                      <motion.div
                        animate={{ scale: [1, 1.3, 1] }}
                        transition={{ duration: 2, repeat: Infinity, delay: i * 0.4 }}
                        className="w-2 h-2 rounded-full bg-primary/50 shrink-0"
                      />
                      <p className="text-sm text-foreground">
                        <span className="font-medium">{log.event.replace(/_/g, " ")}</span>
                        {log.goal && <span className="text-muted-foreground"> — {log.goal}</span>}
                        {log.agent && <span className="text-muted-foreground"> · {log.agent}</span>}
                      </p>
                    </motion.div>
                  ))}
                </div>
              )}
            </div>

            <motion.div variants={item} className="rounded-2xl p-5 surface-container-low neu-raised-sm">
              <div className="flex items-center gap-2 mb-2">
                <div className={`w-2 h-2 rounded-full ${
                  backendStatus === "online" ? "bg-primary animate-pulse" :
                  backendStatus === "offline" ? "bg-destructive" : "bg-muted-foreground"
                }`} />
                <span className="label-meta">Backend</span>
              </div>
              <p className="text-sm text-foreground">
                {backendStatus === "checking" && "Checking connection…"}
                {backendStatus === "online" && "Connected to OrchestraAI backend on port 8000."}
                {backendStatus === "offline" && "Backend offline. Run: uvicorn app:app --reload in /backend"}
              </p>
            </motion.div>
          </motion.div>

          <motion.div variants={container} initial="hidden" animate="show" className="space-y-5">
            <h2 className="text-lg font-bold text-foreground">Quick Actions</h2>
            <div className="space-y-3">
              {quickActions.map((action) => (
                <motion.button
                  key={action.label}
                  variants={item}
                  whileHover={{ y: -3, transition: { duration: 0.2 } }}
                  whileTap={{ scale: 0.97 }}
                  onClick={action.action}
                  className={`flex items-center gap-3 w-full px-5 py-4 rounded-2xl font-medium text-sm transition-all duration-200 hover:neu-hover ${
                    action.variant === "primary" ? "gradient-primary text-primary-foreground neu-raised" :
                    action.variant === "secondary" ? "bg-secondary text-secondary-foreground neu-raised" :
                    "bg-muted text-foreground neu-raised"
                  }`}
                >
                  <action.icon className="w-5 h-5" />
                  {action.label}
                </motion.button>
              ))}
            </div>

            <motion.div variants={item} whileHover={{ y: -2 }}
              className="rounded-2xl p-5 surface-container-low neu-raised-sm hover:neu-raised transition-all duration-200">
              <div className="flex items-center gap-2 mb-3">
                <motion.div animate={{ rotate: [0, 15, -15, 0] }} transition={{ duration: 3, repeat: Infinity }}>
                  <Zap className="w-4 h-4 text-primary" />
                </motion.div>
                <span className="label-meta">AI Insight</span>
              </div>
              <p className="text-sm text-foreground leading-relaxed">
                Describe any development goal in AI Workspace and the multi-agent system will handle research, planning, writing, and code review automatically.
              </p>
              <motion.button whileHover={{ x: 4 }} onClick={() => navigate("/ai")}
                className="mt-3 text-sm font-medium text-primary hover:underline">
                Try it now →
              </motion.button>
            </motion.div>
          </motion.div>
        </div>
      </div>
    </AppLayout>
  );
}
