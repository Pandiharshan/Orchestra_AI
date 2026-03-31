import { AppLayout } from "@/components/layout/AppLayout";
import { TopBar } from "@/components/layout/TopBar";
import { motion, AnimatePresence } from "framer-motion";
import { useState } from "react";
import { Plus, GripVertical, X } from "lucide-react";

type TaskStatus = "todo" | "in-progress" | "done";
type FilterType = "all" | "in-progress" | "done";

interface Task {
  id: string;
  title: string;
  priority: "high" | "medium" | "low";
  deadline: string;
  status: TaskStatus;
}

const columns: { key: TaskStatus; label: string }[] = [
  { key: "todo", label: "To Do" },
  { key: "in-progress", label: "In Progress" },
  { key: "done", label: "Done" },
];

const priorityColors = {
  high: "bg-destructive/10 text-destructive",
  medium: "bg-secondary text-secondary-foreground",
  low: "bg-muted text-muted-foreground",
};

let nextId = 1;

export default function Tasks() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [filter, setFilter] = useState<FilterType>("all");
  const [showAdd, setShowAdd] = useState(false);
  const [newTitle, setNewTitle] = useState("");
  const [newPriority, setNewPriority] = useState<Task["priority"]>("medium");
  const [newDeadline, setNewDeadline] = useState("");

  const filtered = filter === "all" ? tasks : tasks.filter((t) => t.status === filter);
  const total = tasks.length;
  const done = tasks.filter((t) => t.status === "done").length;

  const addTask = () => {
    if (!newTitle.trim()) return;
    setTasks((prev) => [
      ...prev,
      { id: String(nextId++), title: newTitle.trim(), priority: newPriority, deadline: newDeadline || "No deadline", status: "todo" },
    ]);
    setNewTitle(""); setNewDeadline(""); setNewPriority("medium"); setShowAdd(false);
  };

  const moveTask = (id: string, status: TaskStatus) =>
    setTasks((prev) => prev.map((t) => (t.id === id ? { ...t, status } : t)));

  const deleteTask = (id: string) =>
    setTasks((prev) => prev.filter((t) => t.id !== id));

  return (
    <AppLayout>
      <TopBar title="Tasks">
        <button onClick={() => setShowAdd(true)}
          className="flex items-center gap-2 px-4 py-2.5 rounded-xl gradient-primary text-primary-foreground text-sm font-medium hover:-translate-y-0.5 hover:shadow-lift transition-all duration-200">
          <Plus className="w-4 h-4" /> Add Task
        </button>
      </TopBar>

      <div className="px-8 pb-10">
        <AnimatePresence>
          {showAdd && (
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
              className="fixed inset-0 z-50 flex items-center justify-center bg-foreground/10 backdrop-blur-sm"
              onClick={() => setShowAdd(false)}>
              <motion.div initial={{ opacity: 0, y: -20, scale: 0.97 }} animate={{ opacity: 1, y: 0, scale: 1 }}
                exit={{ opacity: 0, y: -20, scale: 0.97 }} transition={{ duration: 0.2 }}
                className="surface-lowest rounded-2xl p-8 shadow-lift w-full max-w-md"
                onClick={(e) => e.stopPropagation()}>
                <div className="flex items-center justify-between mb-6">
                  <h3 className="text-lg font-bold text-foreground">New Task</h3>
                  <button onClick={() => setShowAdd(false)} className="text-muted-foreground hover:text-foreground transition-colors">
                    <X className="w-5 h-5" />
                  </button>
                </div>
                <div className="space-y-4">
                  <div>
                    <label className="label-meta block mb-2">Title</label>
                    <input autoFocus value={newTitle} onChange={(e) => setNewTitle(e.target.value)}
                      onKeyDown={(e) => e.key === "Enter" && addTask()} placeholder="Task title…"
                      className="w-full px-4 py-3 rounded-xl surface-container-low text-sm text-foreground placeholder:text-muted-foreground outline-none focus:ring-1 focus:ring-primary/20 transition-all" />
                  </div>
                  <div>
                    <label className="label-meta block mb-2">Priority</label>
                    <div className="flex gap-2">
                      {(["high", "medium", "low"] as Task["priority"][]).map((p) => (
                        <button key={p} onClick={() => setNewPriority(p)}
                          className={`px-4 py-2 rounded-xl text-sm font-medium capitalize transition-all duration-200 ${newPriority === p ? "gradient-primary text-primary-foreground" : "surface-container-low text-muted-foreground hover:text-foreground"}`}>
                          {p}
                        </button>
                      ))}
                    </div>
                  </div>
                  <div>
                    <label className="label-meta block mb-2">Deadline</label>
                    <input type="date" value={newDeadline} onChange={(e) => setNewDeadline(e.target.value)}
                      className="w-full px-4 py-3 rounded-xl surface-container-low text-sm text-foreground outline-none focus:ring-1 focus:ring-primary/20 transition-all" />
                  </div>
                  <button onClick={addTask}
                    className="w-full py-3 rounded-xl gradient-primary text-primary-foreground text-sm font-semibold hover:-translate-y-0.5 hover:shadow-lift transition-all duration-200">
                    Add Task
                  </button>
                </div>
              </motion.div>
            </motion.div>
          )}
        </AnimatePresence>

        <div className="flex items-center justify-between mb-8">
          <div className="flex gap-2">
            {(["all", "in-progress", "done"] as FilterType[]).map((f) => (
              <button key={f} onClick={() => setFilter(f)}
                className={`px-4 py-2 rounded-xl text-sm font-medium capitalize transition-all duration-200 ${filter === f ? "surface-lowest shadow-ambient text-foreground" : "text-muted-foreground hover:text-foreground"}`}>
                {f}
              </button>
            ))}
          </div>
          <div className="flex items-center gap-3">
            <span className="text-sm text-muted-foreground">{done}/{total} completed</span>
            <div className="w-24 h-1.5 rounded-full bg-muted overflow-hidden">
              <div className="h-full rounded-full gradient-primary transition-all duration-500"
                style={{ width: total > 0 ? `${(done / total) * 100}%` : "0%" }} />
            </div>
          </div>
        </div>

        {tasks.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-24 gap-4">
            <div className="w-16 h-16 rounded-2xl surface-container-low flex items-center justify-center">
              <Plus className="w-8 h-8 text-muted-foreground/40" />
            </div>
            <p className="text-sm text-muted-foreground">No tasks yet. Click "Add Task" to create one.</p>
          </div>
        ) : (
          <div className="grid grid-cols-3 gap-6">
            {columns.map((col) => (
              <div key={col.key}>
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-sm font-semibold text-foreground">{col.label}</h3>
                  <span className="text-xs text-muted-foreground surface-container px-2 py-0.5 rounded-md">
                    {tasks.filter((t) => t.status === col.key).length}
                  </span>
                </div>
                <div className="space-y-3">
                  <AnimatePresence>
                    {filtered.filter((t) => t.status === col.key).map((task, i) => (
                      <motion.div key={task.id} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, scale: 0.95 }} transition={{ delay: i * 0.04 }}
                        className="surface-lowest rounded-2xl p-4 shadow-ambient hover:shadow-lift transition-all duration-200 group">
                        <div className="flex items-start gap-2">
                          <GripVertical className="w-4 h-4 text-muted-foreground/40 mt-0.5 opacity-0 group-hover:opacity-100 transition-opacity shrink-0" />
                          <div className="flex-1 min-w-0">
                            <h4 className="text-sm font-medium text-foreground mb-2 truncate">{task.title}</h4>
                            <div className="flex items-center gap-2 flex-wrap">
                              <span className={`text-xs font-semibold uppercase tracking-wider px-2 py-0.5 rounded-md ${priorityColors[task.priority]}`}>
                                {task.priority}
                              </span>
                              <span className="text-xs text-muted-foreground">{task.deadline}</span>
                            </div>
                            <div className="flex gap-2 mt-3 opacity-0 group-hover:opacity-100 transition-opacity flex-wrap">
                              {columns.filter((c) => c.key !== task.status).map((c) => (
                                <button key={c.key} onClick={() => moveTask(task.id, c.key)}
                                  className="text-xs text-primary hover:underline">→ {c.label}</button>
                              ))}
                              <button onClick={() => deleteTask(task.id)}
                                className="text-xs text-destructive hover:underline ml-auto">Delete</button>
                            </div>
                          </div>
                        </div>
                      </motion.div>
                    ))}
                  </AnimatePresence>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </AppLayout>
  );
}
