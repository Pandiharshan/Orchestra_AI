import { AppLayout } from "@/components/layout/AppLayout";
import { TopBar } from "@/components/layout/TopBar";
import { motion } from "framer-motion";
import { useEffect, useState } from "react";
import { TrendingUp, Zap, Target, Lightbulb, Loader2 } from "lucide-react";
import {
  BarChart, Bar, LineChart, Line,
  XAxis, YAxis, CartesianGrid, Tooltip,
  ResponsiveContainer,
} from "recharts";
import { api, type LogEntry, type StatsResult } from "@/lib/api";

const DAYS = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

function buildDailyChart(logs: LogEntry[]) {
  const counts: Record<string, number> = {};
  DAYS.forEach((d) => (counts[d] = 0));
  logs.forEach((l) => {
    if (l.event === "orchestration_complete" && l.timestamp) {
      const day = DAYS[new Date(l.timestamp).getDay() === 0 ? 6 : new Date(l.timestamp).getDay() - 1];
      counts[day] = (counts[day] || 0) + 1;
    }
  });
  return DAYS.map((name) => ({ name, completed: counts[name] }));
}

function buildWeeklyChart(logs: LogEntry[]) {
  const weeks: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };
  const now = Date.now();
  logs.forEach((l) => {
    if (l.event === "agent_completed" && l.timestamp) {
      const diffDays = Math.floor((now - new Date(l.timestamp).getTime()) / 86400000);
      const week = Math.min(3, Math.floor(diffDays / 7));
      weeks[3 - week] = (weeks[3 - week] || 0) + 1;
    }
  });
  return [0, 1, 2, 3].map((i) => ({ name: `Week ${i + 1}`, usage: weeks[i] }));
}

export default function Analytics() {
  const [stats, setStats] = useState<StatsResult | null>(null);
  const [logs, setLogs] = useState<LogEntry[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([api.getStats(), api.getLogs()])
      .then(([s, l]) => {
        setStats(s);
        setLogs(l.logs);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  const dailyData = buildDailyChart(logs);
  const weeklyData = buildWeeklyChart(logs);

  const insights = stats
    ? [
        `${stats.total_goals_executed} goal${stats.total_goals_executed !== 1 ? "s" : ""} executed through the multi-agent pipeline.`,
        `${stats.total_agent_runs} total agent runs completed using ${stats.model}.`,
        stats.total_goals_executed > 0
          ? "Each goal runs through 5 specialized agents: Research, Planner, Writer, Coder, Reviewer."
          : "Submit your first goal in AI Workspace to see live analytics here.",
      ]
    : ["Loading insights from backend…"];

  return (
    <AppLayout>
      <TopBar title="Analytics" />
      <div className="px-8 pb-10">
        {/* Stat Cards */}
        <div className="grid grid-cols-3 gap-5 mb-10">
          <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
            className="surface-lowest rounded-2xl p-6 shadow-ambient">
            <div className="flex items-center gap-3 mb-3">
              <div className="p-2.5 rounded-xl surface-container-low">
                <Target className="w-5 h-5 text-primary" />
              </div>
              <span className="label-meta">Goals Executed</span>
            </div>
            {loading ? <Loader2 className="w-5 h-5 animate-spin text-muted-foreground" /> : (
              <>
                <p className="text-4xl font-bold text-foreground">{stats?.total_goals_executed ?? 0}</p>
                <p className="text-xs text-muted-foreground mt-2 flex items-center gap-1">
                  <TrendingUp className="w-3 h-3" /> All time
                </p>
              </>
            )}
          </motion.div>

          <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }}
            className="surface-lowest rounded-2xl p-6 shadow-ambient">
            <div className="flex items-center gap-3 mb-3">
              <div className="p-2.5 rounded-xl surface-container-low">
                <Zap className="w-5 h-5 text-primary" />
              </div>
              <span className="label-meta">Agent Runs</span>
            </div>
            {loading ? <Loader2 className="w-5 h-5 animate-spin text-muted-foreground" /> : (
              <>
                <p className="text-4xl font-bold text-foreground">{stats?.total_agent_runs ?? 0}</p>
                <p className="text-xs text-muted-foreground mt-2">5 agents per goal</p>
              </>
            )}
          </motion.div>

          <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }}
            className="surface-lowest rounded-2xl p-6 shadow-ambient">
            <div className="flex items-center gap-3 mb-3">
              <div className="p-2.5 rounded-xl surface-container-low">
                <TrendingUp className="w-5 h-5 text-primary" />
              </div>
              <span className="label-meta">Log Entries</span>
            </div>
            {loading ? <Loader2 className="w-5 h-5 animate-spin text-muted-foreground" /> : (
              <>
                <p className="text-4xl font-bold text-foreground">{logs.length}</p>
                <p className="text-xs text-muted-foreground mt-2">From /logs endpoint</p>
              </>
            )}
          </motion.div>
        </div>

        <div className="grid grid-cols-3 gap-8">
          <div className="col-span-2 space-y-8">
            <div className="surface-lowest rounded-2xl p-6 shadow-ambient">
              <h3 className="text-sm font-semibold text-foreground mb-1">Goals Completed by Day</h3>
              <p className="text-xs text-muted-foreground mb-6">Based on live execution logs</p>
              <ResponsiveContainer width="100%" height={240}>
                <BarChart data={dailyData}>
                  <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
                  <XAxis dataKey="name" tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }} />
                  <YAxis allowDecimals={false} tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }} />
                  <Tooltip
                    contentStyle={{ background: "hsl(var(--surface-container-lowest))", border: "none", borderRadius: "12px", boxShadow: "0 8px 32px hsl(var(--shadow-ambient)/0.08)" }}
                    labelStyle={{ color: "hsl(var(--foreground))", fontWeight: 600 }}
                  />
                  <Bar dataKey="completed" fill="hsl(var(--primary))" radius={[6, 6, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>

            <div className="surface-lowest rounded-2xl p-6 shadow-ambient">
              <h3 className="text-sm font-semibold text-foreground mb-1">Agent Activity by Week</h3>
              <p className="text-xs text-muted-foreground mb-6">Total agent completions per week</p>
              <ResponsiveContainer width="100%" height={240}>
                <LineChart data={weeklyData}>
                  <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
                  <XAxis dataKey="name" tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }} />
                  <YAxis allowDecimals={false} tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }} />
                  <Tooltip
                    contentStyle={{ background: "hsl(var(--surface-container-lowest))", border: "none", borderRadius: "12px", boxShadow: "0 8px 32px hsl(var(--shadow-ambient)/0.08)" }}
                    labelStyle={{ color: "hsl(var(--foreground))", fontWeight: 600 }}
                  />
                  <Line type="monotone" dataKey="usage" stroke="hsl(var(--primary))" strokeWidth={2}
                    dot={{ r: 4, fill: "hsl(var(--primary))" }} />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </div>

          <div>
            <h3 className="text-sm font-semibold text-foreground mb-4">Insights</h3>
            <div className="space-y-4">
              {insights.map((insight, i) => (
                <motion.div key={i} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.3 + i * 0.1 }}
                  className="surface-lowest rounded-2xl p-5 shadow-ambient">
                  <div className="flex items-start gap-3">
                    <Lightbulb className="w-4 h-4 text-primary mt-0.5 shrink-0" />
                    <p className="text-sm text-foreground leading-relaxed">{insight}</p>
                  </div>
                </motion.div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </AppLayout>
  );
}
