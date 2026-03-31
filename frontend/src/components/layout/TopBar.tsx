import { Search, Bell } from "lucide-react";
import { useState } from "react";
import { motion } from "framer-motion";
import { GlobalSearch } from "../GlobalSearch";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/lib/auth";

interface TopBarProps {
  title?: string;
  children?: React.ReactNode;
}

function getGreeting(): string {
  const hour = new Date().getHours();
  if (hour < 12) return "Good morning";
  if (hour < 17) return "Good afternoon";
  return "Good evening";
}

export function TopBar({ title, children }: TopBarProps) {
  const [searchOpen, setSearchOpen] = useState(false);
  const navigate = useNavigate();
  const { user } = useAuth();
  const displayName = user?.user_metadata?.full_name || user?.user_metadata?.name || user?.email?.split("@")[0] || "Developer";

  return (
    <>
      <motion.header
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.4, ease: "easeOut" }}
        className="flex items-center justify-between px-8 py-5"
      >
        <div>
          {title ? (
            <h1 className="text-2xl font-bold text-foreground">{title}</h1>
          ) : (
            <div>
              <p className="text-sm text-muted-foreground">{getGreeting()}</p>
              <h1 className="text-2xl font-bold text-foreground">Welcome back, {displayName}</h1>
            </div>
          )}
        </div>
        <div className="flex items-center gap-3">
          {children}
          <motion.button
            whileHover={{ y: -1 }}
            whileTap={{ scale: 0.97 }}
            onClick={() => setSearchOpen(true)}
            className="flex items-center gap-2 px-4 py-2.5 rounded-xl surface-container-low text-sm text-muted-foreground hover:text-foreground neu-raised-sm hover:neu-raised transition-all duration-200"
          >
            <Search className="w-4 h-4" />
            <span className="hidden md:inline">Search…</span>
            <kbd className="hidden md:inline text-xs surface-container px-1.5 py-0.5 rounded-md ml-2 neu-pressed">⌘K</kbd>
          </motion.button>
          <motion.button
            whileHover={{ y: -1 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => navigate("/notifications")}
            className="relative p-2.5 rounded-xl surface-container-low text-muted-foreground hover:text-foreground neu-raised-sm hover:neu-raised transition-all duration-200"
          >
            <Bell className="w-[18px] h-[18px]" />
            <motion.span
              animate={{ scale: [1, 1.3, 1] }}
              transition={{ duration: 2, repeat: Infinity }}
              className="absolute top-2 right-2 w-2 h-2 rounded-full bg-primary"
            />
          </motion.button>
        </div>
      </motion.header>
      <GlobalSearch open={searchOpen} onClose={() => setSearchOpen(false)} />
    </>
  );
}
