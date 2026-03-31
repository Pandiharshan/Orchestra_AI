import { AppLayout } from "@/components/layout/AppLayout";
import { TopBar } from "@/components/layout/TopBar";
import { motion } from "framer-motion";
import { useState, useEffect } from "react";
import { Moon, Sun, Cpu, Bell, Loader2 } from "lucide-react";
import { api, type StatsResult } from "@/lib/api";

export default function SettingsPage() {
  const [darkMode, setDarkMode] = useState(false);
  const [notifPrefs, setNotifPrefs] = useState({ email: true, push: true, ai: true });
  const [backendInfo, setBackendInfo] = useState<StatsResult | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.getStats()
      .then(setBackendInfo)
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    if (darkMode) document.documentElement.classList.add("dark");
    else document.documentElement.classList.remove("dark");
  }, [darkMode]);

  const toggleNotif = (key: keyof typeof notifPrefs) =>
    setNotifPrefs((prev) => ({ ...prev, [key]: !prev[key] }));

  return (
    <AppLayout>
      <TopBar title="Settings" />
      <div className="px-8 pb-10 max-w-2xl space-y-6">

        {/* Theme */}
        <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
          className="surface-lowest rounded-2xl p-6 shadow-ambient">
          <div className="flex items-center gap-3 mb-5">
            {darkMode ? <Moon className="w-5 h-5 text-primary" /> : <Sun className="w-5 h-5 text-primary" />}
            <h3 className="text-sm font-semibold text-foreground">Theme</h3>
          </div>
          <div className="flex items-center justify-between">
            <p className="text-sm text-muted-foreground">Dark mode</p>
            <button onClick={() => setDarkMode(!darkMode)}
              className={`w-12 h-7 rounded-full transition-colors duration-200 relative ${darkMode ? "bg-primary" : "bg-muted"}`}>
              <span className={`absolute top-1 w-5 h-5 rounded-full surface-lowest shadow-sm transition-transform duration-200 ${darkMode ? "translate-x-6" : "translate-x-1"}`} />
            </button>
          </div>
        </motion.div>

        {/* AI Model — live from backend */}
        <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }}
          className="surface-lowest rounded-2xl p-6 shadow-ambient">
          <div className="flex items-center gap-3 mb-5">
            <Cpu className="w-5 h-5 text-primary" />
            <h3 className="text-sm font-semibold text-foreground">AI Model</h3>
          </div>
          {loading ? (
            <div className="flex items-center gap-2 text-muted-foreground">
              <Loader2 className="w-4 h-4 animate-spin" />
              <span className="text-sm">Loading from backend…</span>
            </div>
          ) : (
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-semibold text-foreground">{backendInfo?.model ?? "Unknown"}</p>
                <p className="text-xs text-muted-foreground mt-0.5">Active model via Groq API</p>
              </div>
              <span className={`text-xs font-semibold px-3 py-1.5 rounded-lg ${backendInfo?.status === "operational" ? "bg-primary/10 text-primary" : "bg-muted text-muted-foreground"}`}>
                {backendInfo?.status ?? "—"}
              </span>
            </div>
          )}
        </motion.div>

        {/* Notifications */}
        <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.15 }}
          className="surface-lowest rounded-2xl p-6 shadow-ambient">
          <div className="flex items-center gap-3 mb-5">
            <Bell className="w-5 h-5 text-primary" />
            <h3 className="text-sm font-semibold text-foreground">Notifications</h3>
          </div>
          <div className="space-y-4">
            {(Object.keys(notifPrefs) as (keyof typeof notifPrefs)[]).map((key) => (
              <div key={key} className="flex items-center justify-between">
                <p className="text-sm text-muted-foreground capitalize">{key} notifications</p>
                <button onClick={() => toggleNotif(key)}
                  className={`w-12 h-7 rounded-full transition-colors duration-200 relative ${notifPrefs[key] ? "bg-primary" : "bg-muted"}`}>
                  <span className={`absolute top-1 w-5 h-5 rounded-full surface-lowest shadow-sm transition-transform duration-200 ${notifPrefs[key] ? "translate-x-6" : "translate-x-1"}`} />
                </button>
              </div>
            ))}
          </div>
        </motion.div>

        {/* Backend Info */}
        <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }}
          className="surface-lowest rounded-2xl p-6 shadow-ambient">
          <h3 className="text-sm font-semibold text-foreground mb-4">Backend Info</h3>
          {loading ? (
            <Loader2 className="w-4 h-4 animate-spin text-muted-foreground" />
          ) : (
            <div className="space-y-2 text-sm text-muted-foreground">
              <div className="flex justify-between">
                <span>Total goals executed</span>
                <span className="font-medium text-foreground">{backendInfo?.total_goals_executed ?? 0}</span>
              </div>
              <div className="flex justify-between">
                <span>Total agent runs</span>
                <span className="font-medium text-foreground">{backendInfo?.total_agent_runs ?? 0}</span>
              </div>
              <div className="flex justify-between">
                <span>API endpoint</span>
                <span className="font-medium text-foreground">{import.meta.env.VITE_API_BASE_URL ?? "http://localhost:8000"}</span>
              </div>
            </div>
          )}
        </motion.div>
      </div>
    </AppLayout>
  );
}
