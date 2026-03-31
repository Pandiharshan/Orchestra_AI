import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Sparkles, Eye, EyeOff, Loader2 } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { Checkbox } from "@/components/ui/checkbox";
import { supabase } from "@/lib/supabase/client";
import { toast } from "sonner";

export default function Login() {
  const [isSignup, setIsSignup] = useState(false);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPw, setConfirmPw] = useState("");
  const [showPw, setShowPw] = useState(false);
  const [showConfirmPw, setShowConfirmPw] = useState(false);
  const [focusedField, setFocusedField] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (isSignup && password !== confirmPw) {
      toast.error("Passwords do not match");
      return;
    }
    setLoading(true);
    try {
      if (isSignup) {
        const { error } = await supabase.auth.signUp({ email, password });
        if (error) throw error;
        toast.success("Account created! Check your email to confirm.");
      } else {
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;
        navigate("/");
      }
    } catch (err: unknown) {
      toast.error(err instanceof Error ? err.message : "Authentication failed");
    } finally {
      setLoading(false);
    }
  };

  const handleGoogle = async () => {
    setGoogleLoading(true);
    const { error } = await supabase.auth.signInWithOAuth({
      provider: "google",
      options: {
        redirectTo: window.location.origin,
      },
    });
    if (error) {
      toast.error(error.message);
      setGoogleLoading(false);
    }
  };

  const inputClass = (field: string) =>
    `w-full px-4 py-3 rounded-xl text-sm text-foreground placeholder:text-muted-foreground outline-none transition-all duration-200 ${
      focusedField === field
        ? "surface-lowest neu-pressed ring-1 ring-primary/20"
        : "surface-container-low neu-pressed"
    }`;

  return (
    <div className="min-h-screen surface flex">
      {/* Left branding panel */}
      <motion.div
        initial={{ opacity: 0, x: -40 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.7, ease: [0.22, 1, 0.36, 1] }}
        className="hidden lg:flex lg:w-[45%] gradient-primary relative overflow-hidden items-end p-16"
      >
        <motion.div
          animate={{ scale: [1, 1.1, 1], opacity: [0.2, 0.3, 0.2] }}
          transition={{ duration: 8, repeat: Infinity, ease: "easeInOut" }}
          className="absolute top-[-20%] right-[-10%] w-[500px] h-[500px] rounded-full bg-accent/20 blur-[120px]"
        />
        <div className="relative z-10 max-w-md">
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.3 }}
            className="flex items-center gap-3 mb-12">
            <div className="w-12 h-12 rounded-xl bg-primary-foreground/15 backdrop-blur-sm flex items-center justify-center">
              <Sparkles className="w-6 h-6 text-primary-foreground" />
            </div>
            <span className="text-2xl font-bold text-primary-foreground tracking-[-0.02em]">OrchestraAI</span>
          </motion.div>
          <motion.h1 initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.5, ease: [0.22, 1, 0.36, 1] }}
            className="text-[3.5rem] leading-[1.1] font-bold text-primary-foreground tracking-[-0.02em] mb-6">
            Where ideas<br />become reality.
          </motion.h1>
          <motion.p initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.7 }}
            className="text-primary-foreground/70 text-lg leading-relaxed">
            A multi-agent development assistant that transforms a single input into a complete, production-ready solution.
          </motion.p>
        </div>
      </motion.div>

      {/* Right form panel */}
      <div className="flex-1 flex items-center justify-center p-6 relative">
        <motion.div
          animate={{ scale: [1, 1.05, 1], opacity: [0.25, 0.35, 0.25] }}
          transition={{ duration: 6, repeat: Infinity, ease: "easeInOut" }}
          className="absolute top-1/4 right-1/4 w-[600px] h-[600px] rounded-full blur-[160px] pointer-events-none"
          style={{ background: "radial-gradient(circle, hsl(var(--accent) / 0.4), transparent 70%)" }}
        />

        <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2, ease: [0.22, 1, 0.36, 1] }}
          className="w-full max-w-[440px] relative z-10">

          {/* Mobile logo */}
          <div className="flex items-center gap-3 justify-center mb-10 lg:hidden">
            <div className="w-11 h-11 rounded-xl gradient-primary flex items-center justify-center">
              <Sparkles className="w-5 h-5 text-primary-foreground" />
            </div>
            <span className="text-2xl font-bold text-foreground tracking-[-0.02em]">OrchestraAI</span>
          </div>

          <div className="surface-lowest rounded-2xl p-10 neu-raised">
            <AnimatePresence mode="wait">
              <motion.div key={isSignup ? "signup" : "signin"}
                initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -12 }} transition={{ duration: 0.25 }}>

                <h2 className="text-xl font-bold text-foreground mb-1 tracking-[-0.02em]">
                  {isSignup ? "Create account" : "Welcome back"}
                </h2>
                <p className="text-sm text-muted-foreground mb-8 leading-relaxed">
                  {isSignup ? "Start building with AI" : "Sign in to continue"}
                </p>

                {/* Google OAuth */}
                <motion.button
                  type="button"
                  onClick={handleGoogle}
                  disabled={googleLoading}
                  whileHover={{ y: -2 }} whileTap={{ scale: 0.98 }}
                  className="w-full flex items-center justify-center gap-3 px-4 py-3 rounded-xl surface-container-low text-sm font-medium text-foreground neu-raised-sm hover:neu-hover transition-all duration-200 mb-6 disabled:opacity-70"
                >
                  {googleLoading ? (
                    <Loader2 className="w-4 h-4 animate-spin" />
                  ) : (
                    <svg className="w-4 h-4" viewBox="0 0 24 24">
                      <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 01-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z" fill="#4285F4" />
                      <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853" />
                      <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18A10.96 10.96 0 001 12c0 1.77.42 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05" />
                      <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335" />
                    </svg>
                  )}
                  Continue with Google
                </motion.button>

                {/* Divider */}
                <div className="flex items-center gap-4 mb-6">
                  <div className="flex-1 h-px bg-muted" />
                  <span className="text-xs text-muted-foreground">or</span>
                  <div className="flex-1 h-px bg-muted" />
                </div>

                {/* Email/password form */}
                <form onSubmit={handleSubmit} className="space-y-5">
                  <div>
                    <label className="label-meta block mb-2">Email</label>
                    <input type="email" value={email} onChange={(e) => setEmail(e.target.value)}
                      placeholder="you@example.com" required
                      onFocus={() => setFocusedField("email")} onBlur={() => setFocusedField(null)}
                      className={inputClass("email")} />
                  </div>

                  <div>
                    <label className="label-meta block mb-2">Password</label>
                    <div className="relative">
                      <input type={showPw ? "text" : "password"} value={password}
                        onChange={(e) => setPassword(e.target.value)} placeholder="••••••••" required
                        onFocus={() => setFocusedField("pw")} onBlur={() => setFocusedField(null)}
                        className={`${inputClass("pw")} pr-10`} />
                      <button type="button" onClick={() => setShowPw(!showPw)}
                        className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground transition-colors">
                        {showPw ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                      </button>
                    </div>
                  </div>

                  <AnimatePresence>
                    {isSignup && (
                      <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: "auto" }}
                        exit={{ opacity: 0, height: 0 }} transition={{ duration: 0.25 }}>
                        <label className="label-meta block mb-2">Confirm Password</label>
                        <div className="relative">
                          <input type={showConfirmPw ? "text" : "password"} value={confirmPw}
                            onChange={(e) => setConfirmPw(e.target.value)} placeholder="••••••••"
                            onFocus={() => setFocusedField("cpw")} onBlur={() => setFocusedField(null)}
                            className={`${inputClass("cpw")} pr-10`} />
                          <button type="button" onClick={() => setShowConfirmPw(!showConfirmPw)}
                            className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground transition-colors">
                            {showConfirmPw ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                          </button>
                        </div>
                      </motion.div>
                    )}
                  </AnimatePresence>

                  {!isSignup && (
                    <div className="flex items-center justify-between">
                      <label className="flex items-center gap-2.5 text-sm text-muted-foreground cursor-pointer">
                        <Checkbox className="border-muted-foreground/30 data-[state=checked]:bg-primary data-[state=checked]:border-primary" />
                        Remember me
                      </label>
                      <button type="button" className="text-sm text-primary hover:opacity-80 transition-opacity">
                        Forgot password?
                      </button>
                    </div>
                  )}

                  <motion.button type="submit" disabled={loading}
                    whileHover={!loading ? { y: -2, scale: 1.01 } : {}}
                    whileTap={!loading ? { scale: 0.97 } : {}}
                    className="w-full py-3.5 rounded-xl gradient-primary text-primary-foreground text-sm font-semibold neu-raised hover:neu-hover transition-all duration-200 flex items-center justify-center gap-2 disabled:opacity-70 disabled:cursor-not-allowed">
                    {loading && <Loader2 className="w-4 h-4 animate-spin" />}
                    {loading ? "Please wait…" : isSignup ? "Create Account" : "Sign In"}
                  </motion.button>
                </form>
              </motion.div>
            </AnimatePresence>
          </div>

          <p className="text-center text-sm text-muted-foreground mt-8">
            {isSignup ? "Already have an account?" : "Don't have an account?"}{" "}
            <button onClick={() => setIsSignup(!isSignup)}
              className="text-primary font-medium hover:opacity-80 transition-opacity">
              {isSignup ? "Sign in" : "Sign up"}
            </button>
          </p>
        </motion.div>
      </div>
    </div>
  );
}
