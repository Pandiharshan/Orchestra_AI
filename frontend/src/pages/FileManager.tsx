import { AppLayout } from "@/components/layout/AppLayout";
import { TopBar } from "@/components/layout/TopBar";
import { motion } from "framer-motion";
import { useState } from "react";
import {
  Upload,
  FolderOpen,
  FileText,
  Image,
  FileCode,
  Grid3X3,
  List,
  ChevronRight,
  Eye,
} from "lucide-react";

type ViewMode = "grid" | "list";

const folders = [
  { name: "Source Code", count: 24 },
  { name: "Documents", count: 12 },
  { name: "Designs", count: 8 },
  { name: "Assets", count: 15 },
];

const files = [
  { name: "auth-service.ts", type: "code", size: "4.2 KB", modified: "2 hours ago" },
  { name: "README.md", type: "doc", size: "2.1 KB", modified: "5 hours ago" },
  { name: "hero-banner.png", type: "image", size: "340 KB", modified: "1 day ago" },
  { name: "api-schema.json", type: "code", size: "8.7 KB", modified: "2 days ago" },
  { name: "design-spec.pdf", type: "doc", size: "1.2 MB", modified: "3 days ago" },
  { name: "logo.svg", type: "image", size: "12 KB", modified: "1 week ago" },
];

const typeIcons: Record<string, React.ElementType> = {
  code: FileCode,
  doc: FileText,
  image: Image,
};

export default function FileManager() {
  const [view, setView] = useState<ViewMode>("grid");
  const [selectedFile, setSelectedFile] = useState<string | null>(null);

  const selected = files.find((f) => f.name === selectedFile);

  return (
    <AppLayout>
      <TopBar title="Files">
        <div className="flex items-center gap-2">
          <button onClick={() => setView("grid")} className={`p-2 rounded-lg transition-colors ${view === "grid" ? "surface-lowest shadow-ambient" : "text-muted-foreground hover:text-foreground"}`}>
            <Grid3X3 className="w-4 h-4" />
          </button>
          <button onClick={() => setView("list")} className={`p-2 rounded-lg transition-colors ${view === "list" ? "surface-lowest shadow-ambient" : "text-muted-foreground hover:text-foreground"}`}>
            <List className="w-4 h-4" />
          </button>
        </div>
        <button className="flex items-center gap-2 px-4 py-2.5 rounded-xl gradient-primary text-primary-foreground text-sm font-medium hover:-translate-y-0.5 hover:shadow-lift transition-all duration-200">
          <Upload className="w-4 h-4" /> Upload
        </button>
      </TopBar>

      <div className="flex px-8 pb-10 gap-8">
        {/* Folder Tree */}
        <div className="w-[200px] shrink-0 space-y-2">
          <p className="label-meta mb-3">Folders</p>
          {folders.map((folder) => (
            <button key={folder.name} className="flex items-center gap-2 w-full px-3 py-2.5 rounded-xl text-sm text-muted-foreground hover:text-foreground hover:surface-container-low transition-all text-left">
              <FolderOpen className="w-4 h-4" />
              <span className="flex-1">{folder.name}</span>
              <span className="text-xs surface-container px-1.5 py-0.5 rounded-md">{folder.count}</span>
              <ChevronRight className="w-3 h-3" />
            </button>
          ))}
        </div>

        {/* File Grid/List */}
        <div className="flex-1">
          {view === "grid" ? (
            <div className="grid grid-cols-3 gap-4">
              {files.map((file, i) => {
                const Icon = typeIcons[file.type] || FileText;
                return (
                  <motion.div
                    key={file.name}
                    initial={{ opacity: 0, y: 8 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: i * 0.04 }}
                    onClick={() => setSelectedFile(file.name)}
                    className={`surface-lowest rounded-2xl p-5 shadow-ambient hover:shadow-lift transition-all duration-200 cursor-pointer ${selectedFile === file.name ? "ring-2 ring-primary/20" : ""}`}
                  >
                    <Icon className="w-8 h-8 text-primary/60 mb-3" />
                    <h4 className="text-sm font-medium text-foreground truncate">{file.name}</h4>
                    <p className="text-xs text-muted-foreground mt-1">{file.size} · {file.modified}</p>
                  </motion.div>
                );
              })}
            </div>
          ) : (
            <div className="space-y-1">
              {files.map((file, i) => {
                const Icon = typeIcons[file.type] || FileText;
                return (
                  <motion.div
                    key={file.name}
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    transition={{ delay: i * 0.03 }}
                    onClick={() => setSelectedFile(file.name)}
                    className={`flex items-center gap-4 px-4 py-3 rounded-xl hover:surface-container-low transition-all cursor-pointer ${selectedFile === file.name ? "surface-lowest shadow-ambient" : ""}`}
                  >
                    <Icon className="w-4 h-4 text-primary/60" />
                    <span className="flex-1 text-sm font-medium text-foreground">{file.name}</span>
                    <span className="text-xs text-muted-foreground">{file.size}</span>
                    <span className="text-xs text-muted-foreground">{file.modified}</span>
                  </motion.div>
                );
              })}
            </div>
          )}
        </div>

        {/* Preview Panel */}
        {selected && (
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            className="w-[260px] shrink-0 surface-lowest rounded-2xl p-6 shadow-ambient h-fit"
          >
            <div className="flex items-center gap-2 mb-4">
              <Eye className="w-4 h-4 text-muted-foreground" />
              <span className="label-meta">Preview</span>
            </div>
            <div className="w-full h-32 rounded-xl surface-container-low flex items-center justify-center mb-4">
              <FileText className="w-10 h-10 text-muted-foreground/40" />
            </div>
            <h4 className="text-sm font-semibold text-foreground mb-2">{selected.name}</h4>
            <div className="space-y-2 text-xs text-muted-foreground">
              <p>Size: {selected.size}</p>
              <p>Type: {selected.type}</p>
              <p>Modified: {selected.modified}</p>
            </div>
          </motion.div>
        )}
      </div>
    </AppLayout>
  );
}
