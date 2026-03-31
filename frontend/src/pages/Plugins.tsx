import { AppLayout } from "@/components/layout/AppLayout";
import { TopBar } from "@/components/layout/TopBar";
import { motion } from "framer-motion";
import { useState } from "react";
import { Download, ToggleLeft, ToggleRight, Puzzle } from "lucide-react";

type Category = "all" | "productivity" | "ai" | "integrations";

const plugins = [
  { name: "GitHub Sync", desc: "Sync projects with GitHub repos automatically.", category: "integrations" as const, installed: true },
  { name: "Slack Notifications", desc: "Get task updates directly in Slack.", category: "integrations" as const, installed: false },
  { name: "AI Code Review", desc: "Automated code review with AI suggestions.", category: "ai" as const, installed: true },
  { name: "Time Tracker", desc: "Track time spent on tasks and projects.", category: "productivity" as const, installed: false },
  { name: "AI Documentation", desc: "Auto-generate docs from your codebase.", category: "ai" as const, installed: false },
  { name: "Kanban Pro", desc: "Advanced kanban board with swimlanes.", category: "productivity" as const, installed: true },
];

export default function Plugins() {
  const [category, setCategory] = useState<Category>("all");
  const [items, setItems] = useState(plugins);

  const filtered = items.filter((p) => category === "all" || p.category === category);

  const toggle = (name: string) =>
    setItems(items.map((p) => (p.name === name ? { ...p, installed: !p.installed } : p)));

  return (
    <AppLayout>
      <TopBar title="Plugins" />
      <div className="px-8 pb-10">
        <div className="flex gap-2 mb-8">
          {(["all", "productivity", "ai", "integrations"] as Category[]).map((c) => (
            <button
              key={c}
              onClick={() => setCategory(c)}
              className={`px-4 py-2 rounded-xl text-sm font-medium capitalize transition-all duration-200 ${
                category === c ? "surface-lowest shadow-ambient text-foreground" : "text-muted-foreground hover:text-foreground"
              }`}
            >
              {c}
            </button>
          ))}
        </div>

        <div className="grid grid-cols-2 xl:grid-cols-3 gap-5">
          {filtered.map((plugin, i) => (
            <motion.div
              key={plugin.name}
              initial={{ opacity: 0, y: 8 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.05 }}
              className="surface-lowest rounded-2xl p-6 shadow-ambient hover:shadow-lift transition-all duration-200"
            >
              <div className="flex items-start justify-between mb-3">
                <div className="p-2.5 rounded-xl surface-container-low">
                  <Puzzle className="w-5 h-5 text-primary" />
                </div>
                <button onClick={() => toggle(plugin.name)} className="text-primary">
                  {plugin.installed ? <ToggleRight className="w-6 h-6" /> : <ToggleLeft className="w-6 h-6 text-muted-foreground" />}
                </button>
              </div>
              <h3 className="font-semibold text-foreground mb-1">{plugin.name}</h3>
              <p className="text-xs text-muted-foreground leading-relaxed mb-4">{plugin.desc}</p>
              {!plugin.installed && (
                <button
                  onClick={() => toggle(plugin.name)}
                  className="flex items-center gap-2 text-sm font-medium text-primary hover:underline"
                >
                  <Download className="w-3.5 h-3.5" /> Install
                </button>
              )}
            </motion.div>
          ))}
        </div>
      </div>
    </AppLayout>
  );
}
