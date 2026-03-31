import { useLocation, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import {
  LayoutDashboard,
  FolderKanban,
  Sparkles,
  CheckSquare,
  BarChart3,
  FolderOpen,
  Bell,
  User,
  Settings,
  Puzzle,
} from "lucide-react";

const navItems = [
  { title: "Dashboard", url: "/", icon: LayoutDashboard },
  { title: "Projects", url: "/projects", icon: FolderKanban },
  { title: "AI Workspace", url: "/ai", icon: Sparkles },
  { title: "Tasks", url: "/tasks", icon: CheckSquare },
  { title: "Analytics", url: "/analytics", icon: BarChart3 },
  { title: "Files", url: "/files", icon: FolderOpen },
  { title: "Plugins", url: "/plugins", icon: Puzzle },
];

const bottomItems = [
  { title: "Notifications", url: "/notifications", icon: Bell },
  { title: "Profile", url: "/profile", icon: User },
  { title: "Settings", url: "/settings", icon: Settings },
];

export function AppSidebar() {
  const location = useLocation();
  const navigate = useNavigate();

  const isActive = (path: string) =>
    path === "/" ? location.pathname === "/" : location.pathname.startsWith(path);

  const renderNavButton = (item: typeof navItems[0]) => {
    const active = isActive(item.url);
    return (
      <motion.button
        key={item.url}
        onClick={() => navigate(item.url)}
        whileHover={{ x: 4, transition: { duration: 0.15 } }}
        whileTap={{ scale: 0.97 }}
        className={`flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-all duration-200 relative ${
          active
            ? "surface-lowest neu-raised-sm text-foreground"
            : "text-muted-foreground hover:text-foreground"
        }`}
      >
        <item.icon className="w-[18px] h-[18px]" />
        <span>{item.title}</span>
      </motion.button>
    );
  };

  return (
    <motion.aside
      initial={{ x: -20, opacity: 0 }}
      animate={{ x: 0, opacity: 1 }}
      transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
      className="w-[240px] min-h-screen surface-container flex flex-col py-8 px-4 shrink-0"
    >
      {/* Logo */}
      <div className="flex items-center gap-3 px-3 mb-10">
        <motion.div
          whileHover={{ rotate: 5, scale: 1.05 }}
          transition={{ type: "spring", stiffness: 300 }}
          className="w-8 h-8 rounded-lg gradient-primary flex items-center justify-center neu-raised-sm"
        >
          <Sparkles className="w-4 h-4 text-primary-foreground" />
        </motion.div>
        <span className="text-lg font-bold tracking-tight text-foreground">OrchestraAI</span>
      </div>

      {/* Main Nav */}
      <nav className="flex-1 flex flex-col gap-1">
        {navItems.map(renderNavButton)}
      </nav>

      {/* Bottom Nav */}
      <div className="flex flex-col gap-1 pt-4">
        {bottomItems.map(renderNavButton)}
      </div>
    </motion.aside>
  );
}
