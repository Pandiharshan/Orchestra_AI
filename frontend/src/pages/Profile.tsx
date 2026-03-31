import { AppLayout } from "@/components/layout/AppLayout";
import { TopBar } from "@/components/layout/TopBar";
import { motion } from "framer-motion";
import { User, Mail, Zap, CreditCard, LogOut } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/lib/auth";

export default function Profile() {
  const navigate = useNavigate();
  const { user, logout } = useAuth();

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  const displayName = user?.user_metadata?.full_name || user?.user_metadata?.name || user?.email?.split("@")[0] || "Guest";
  const displayEmail = user?.email || "Not signed in";

  return (
    <AppLayout>
      <TopBar title="Profile" />
      <div className="px-8 pb-10 max-w-2xl">
        <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
          className="surface-lowest rounded-2xl p-8 shadow-ambient mb-8">
          <div className="flex items-center gap-6">
            <div className="w-20 h-20 rounded-2xl gradient-primary flex items-center justify-center">
              <User className="w-8 h-8 text-primary-foreground" />
            </div>
            <div className="flex-1">
              <h2 className="text-xl font-bold text-foreground">{displayName}</h2>
              <div className="flex items-center gap-2 mt-1">
                <Mail className="w-3.5 h-3.5 text-muted-foreground" />
                <span className="text-sm text-muted-foreground">{displayEmail}</span>
              </div>
            </div>
          </div>
        </motion.div>

        <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }}
          className="surface-lowest rounded-2xl p-6 shadow-ambient mb-8">
          <div className="flex items-center gap-3 mb-4">
            <CreditCard className="w-5 h-5 text-primary" />
            <h3 className="text-sm font-semibold text-foreground">Account</h3>
          </div>
          <div className="flex items-center justify-between">
            <div>
              <p className="text-lg font-bold text-foreground">OrchestraAI</p>
              <p className="text-sm text-muted-foreground">Multi-agent development assistant</p>
            </div>
            <div className="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-primary/10 text-primary text-xs font-semibold">
              <Zap className="w-3 h-3" /> Active
            </div>
          </div>
        </motion.div>

        <button onClick={handleLogout}
          className="flex items-center gap-2 px-5 py-3 rounded-xl text-sm font-medium text-destructive hover:bg-destructive/5 transition-colors">
          <LogOut className="w-4 h-4" /> Sign Out
        </button>
      </div>
    </AppLayout>
  );
}
