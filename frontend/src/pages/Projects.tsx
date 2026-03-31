import { AppLayout } from "@/components/layout/AppLayout";
import { TopBar } from "@/components/layout/TopBar";
import { motion, AnimatePresence } from "framer-motion";
import { useState } from "react";
import { Plus, ArrowUpDown, X } from "lucide-react";

type Filter = "all" | "active" | "completed";
type Sort = "date" | "name";

interface Project {
  id: string;
  name: string;
  status: "active" | "completed";
  progress: number;
  updated: string;
}

let nextId = 1;

export default function Projects() {
  const [projects, setProjects] = useState<Project[]>([]);
  const [filter, setFilter] = useState<Filter>("all");
  const [sort, setSort] = useState<Sort>("date");
  const [showAdd, setShowAdd] = useState(false);
  const [newName, setNewName] = useState("");

  const filtered = projects
    .filter((p) => filter === "all" || p.status === filter)
    .sort((a, b) => sort === "name" ? a.name.localeCompare(b.name) : 0);

  const addProject = () => {
    if (!newName.trim()) return;
    setProjects((prev) => [
      ...prev,
      { id: String(nextId++), name: newName.trim(), status: "active", progress: 0, updated: "Just now" },
    ]);
    setNewName(""); setShowAdd(false);
  };

  const updateProgress = (id: string, progress: number) => {
    setProjects((prev) => prev.map((p) =>
      p.id === id ? { ...p, progress, status: progress === 100 ? "completed" : "active", updated: "Just now" } : p
    ));
  };

  return (
    <AppLayout>
      <TopBar title="Projects">
        <button onClick={() => setShowAdd(true)}
          className="flex items-center gap-2 px-4 py-2.5 rounded-xl gradient-primary text-primary-foreground text-sm font-medium hover:-translate-y-0.5 hover:shadow-lift transition-all duration-200">
          <Plus className="w-4 h-4" /> Create Project
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
                  <h3 className="text-lg font-bold text-foreground">New Project</h3>
                  <button onClick={() => setShowAdd(false)} className="text-muted-foreground hover:text-foreground transition-colors">
                    <X className="w-5 h-5" />
                  </button>
                </div>
                <div className="space-y-4">
                  <div>
                    <label className="label-meta block mb-2">Project Name</label>
                    <input autoFocus value={newName} onChange={(e) => setNewName(e.target.value)}
                      onKeyDown={(e) => e.key === "Enter" && addProject()} placeholder="Project name…"
                      className="w-full px-4 py-3 rounded-xl surface-container-low text-sm text-foreground placeholder:text-muted-foreground outline-none focus:ring-1 focus:ring-primary/20 transition-all" />
                  </div>
                  <button onClick={addProject}
                    className="w-full py-3 rounded-xl gradient-primary text-primary-foreground text-sm font-semibold hover:-translate-y-0.5 hover:shadow-lift transition-all duration-200">
                    Create Project
                  </button>
                </div>
              </motion.div>
            </motion.div>
          )}
        </AnimatePresence>

        <div className="flex items-center justify-between mb-8">
          <div className="flex gap-2">
            {(["all", "active", "completed"] as Filter[]).map((f) => (
              <button key={f} onClick={() => setFilter(f)}
                className={`px-4 py-2 rounded-xl text-sm font-medium capitalize transition-all duration-200 ${filter === f ? "surface-lowest shadow-ambient text-foreground" : "text-muted-foreground hover:text-foreground"}`}>
                {f}
              </button>
            ))}
          </div>
          <button onClick={() => setSort(sort === "date" ? "name" : "date")}
            className="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground transition-colors">
            <ArrowUpDown className="w-4 h-4" /> Sort by {sort}
          </button>
        </div>

        {projects.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-24 gap-4">
            <div className="w-16 h-16 rounded-2xl surface-container-low flex items-center justify-center">
              <Plus className="w-8 h-8 text-muted-foreground/40" />
            </div>
            <p className="text-sm text-muted-foreground">No projects yet. Click "Create Project" to start.</p>
          </div>
        ) : (
          <div className="grid grid-cols-2 xl:grid-cols-3 gap-5">
            {filtered.map((project, i) => (
              <motion.div key={project.id} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.05 }}
                className="surface-lowest rounded-2xl p-6 shadow-ambient hover:shadow-lift transition-all duration-200 cursor-pointer group">
                <div className="flex items-start justify-between mb-4">
                  <h3 className="font-semibold text-foreground group-hover:text-primary transition-colors">{project.name}</h3>
                  <span className={`text-xs font-semibold uppercase tracking-wider px-2.5 py-1 rounded-lg ${project.status === "active" ? "bg-primary/10 text-primary" : "bg-tertiary/10 text-tertiary"}`}>
                    {project.status}
                  </span>
                </div>
                <div className="mb-3">
                  <div className="flex justify-between text-xs text-muted-foreground mb-1.5">
                    <span>Progress</span>
                    <span className="font-medium text-foreground">{project.progress}%</span>
                  </div>
                  <div className="w-full h-1.5 rounded-full bg-muted overflow-hidden">
                    <div className="h-full rounded-full gradient-primary transition-all duration-500"
                      style={{ width: `${project.progress}%` }} />
                  </div>
                </div>
                <input type="range" min={0} max={100} value={project.progress}
                  onChange={(e) => updateProgress(project.id, Number(e.target.value))}
                  className="w-full accent-primary mb-2" />
                <p className="text-xs text-muted-foreground">Updated {project.updated}</p>
              </motion.div>
            ))}
          </div>
        )}
      </div>
    </AppLayout>
  );
}
