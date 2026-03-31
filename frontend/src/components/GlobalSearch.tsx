import { useState } from "react";
import { Search, X, FileText, FolderKanban, CheckSquare, Sparkles } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

const recentSearches = ["Dashboard API", "Auth module", "Sprint 3 tasks"];

const mockResults = {
  tasks: [
    { title: "Implement login flow", type: "task" },
    { title: "Fix sidebar animation", type: "task" },
  ],
  projects: [
    { title: "OrchestraAI Core", type: "project" },
    { title: "Mobile App v2", type: "project" },
  ],
  files: [
    { title: "auth-service.ts", type: "file" },
    { title: "README.md", type: "file" },
  ],
};

interface GlobalSearchProps {
  open: boolean;
  onClose: () => void;
}

export function GlobalSearch({ open, onClose }: GlobalSearchProps) {
  const [query, setQuery] = useState("");

  const hasQuery = query.length > 0;

  const iconMap: Record<string, React.ReactNode> = {
    task: <CheckSquare className="w-4 h-4 text-muted-foreground" />,
    project: <FolderKanban className="w-4 h-4 text-muted-foreground" />,
    file: <FileText className="w-4 h-4 text-muted-foreground" />,
  };

  return (
    <AnimatePresence>
      {open && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-50 flex items-start justify-center pt-[15vh]"
          onClick={onClose}
        >
          <div className="fixed inset-0 bg-foreground/10 backdrop-blur-sm" />
          <motion.div
            initial={{ opacity: 0, y: -20, scale: 0.98 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: -20, scale: 0.98 }}
            transition={{ duration: 0.2 }}
            className="relative w-full max-w-[600px] surface-lowest rounded-2xl shadow-lift overflow-hidden"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Search Input */}
            <div className="flex items-center gap-3 px-5 py-4">
              <Search className="w-5 h-5 text-muted-foreground" />
              <input
                autoFocus
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder="Search tasks, projects, files…"
                className="flex-1 bg-transparent text-foreground placeholder:text-muted-foreground outline-none text-base"
              />
              <button onClick={onClose} className="p-1 rounded-lg hover:bg-muted transition-colors">
                <X className="w-4 h-4 text-muted-foreground" />
              </button>
            </div>

            <div className="px-5 pb-5 max-h-[400px] overflow-auto">
              {!hasQuery && (
                <div>
                  <p className="label-meta mb-3">Recent Searches</p>
                  <div className="flex flex-wrap gap-2">
                    {recentSearches.map((s) => (
                      <button
                        key={s}
                        onClick={() => setQuery(s)}
                        className="px-3 py-1.5 rounded-lg surface-container text-sm text-muted-foreground hover:text-foreground transition-colors"
                      >
                        {s}
                      </button>
                    ))}
                  </div>

                  <div className="flex items-center gap-2 mt-5 px-3 py-3 rounded-xl surface-container-low">
                    <Sparkles className="w-4 h-4 text-primary" />
                    <span className="text-sm text-muted-foreground">Try: "Show me unfinished tasks for Sprint 3"</span>
                  </div>
                </div>
              )}

              {hasQuery && (
                <div className="space-y-5">
                  {Object.entries(mockResults).map(([category, items]) => (
                    <div key={category}>
                      <p className="label-meta mb-2 capitalize">{category}</p>
                      <div className="space-y-1">
                        {items.map((item) => (
                          <button
                            key={item.title}
                            className="flex items-center gap-3 w-full px-3 py-2.5 rounded-xl hover:surface-container-low transition-colors text-left"
                          >
                            {iconMap[item.type]}
                            <span className="text-sm text-foreground">{item.title}</span>
                          </button>
                        ))}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
