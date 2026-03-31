import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Sparkles, ArrowRight, ArrowLeft, Code, Palette, GraduationCap } from "lucide-react";
import { useNavigate } from "react-router-dom";

const slides = [
  {
    title: "Welcome to OrchestraAI",
    description: "Your multi-agent development assistant. One input, complete solutions.",
  },
  {
    title: "AI-Powered Workflow",
    description: "A conductor AI delegates tasks to specialized agents — code, review, and optimization happen automatically.",
  },
  {
    title: "Built for Developers",
    description: "Manage projects, track tasks, and leverage AI — all in one beautifully crafted workspace.",
  },
];

const roles = [
  { id: "developer", label: "Developer", icon: Code },
  { id: "designer", label: "Designer", icon: Palette },
  { id: "student", label: "Student", icon: GraduationCap },
];

export default function Onboarding() {
  const [step, setStep] = useState(0);
  const [selectedRole, setSelectedRole] = useState<string | null>(null);
  const navigate = useNavigate();
  const isLast = step === slides.length;

  return (
    <div className="min-h-screen surface flex items-center justify-center p-6">
      <div className="w-full max-w-[520px]">
        {/* Logo */}
        <div className="flex items-center gap-3 justify-center mb-12">
          <div className="w-10 h-10 rounded-xl gradient-primary flex items-center justify-center">
            <Sparkles className="w-5 h-5 text-primary-foreground" />
          </div>
          <span className="text-2xl font-bold text-foreground tracking-tight">OrchestraAI</span>
        </div>

        {/* Progress */}
        <div className="flex gap-2 justify-center mb-10">
          {[...slides, null].map((_, i) => (
            <div
              key={i}
              className={`h-1 rounded-full transition-all duration-300 ${
                i <= step ? "w-8 gradient-primary" : "w-4 bg-muted"
              }`}
            />
          ))}
        </div>

        <AnimatePresence mode="wait">
          {!isLast ? (
            <motion.div
              key={step}
              initial={{ opacity: 0, x: 40 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -40 }}
              transition={{ duration: 0.3 }}
              className="text-center"
            >
              {/* Illustration placeholder */}
              <div className="w-48 h-48 mx-auto rounded-3xl surface-container-low flex items-center justify-center mb-8">
                <Sparkles className="w-16 h-16 text-primary/20" />
              </div>
              <h2 className="text-2xl font-bold text-foreground mb-3">{slides[step].title}</h2>
              <p className="text-sm text-muted-foreground leading-relaxed max-w-sm mx-auto">{slides[step].description}</p>
            </motion.div>
          ) : (
            <motion.div
              key="role"
              initial={{ opacity: 0, x: 40 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -40 }}
              className="text-center"
            >
              <h2 className="text-2xl font-bold text-foreground mb-3">How do you work?</h2>
              <p className="text-sm text-muted-foreground mb-8">We'll tailor your experience</p>
              <div className="flex gap-4 justify-center">
                {roles.map((role) => (
                  <button
                    key={role.id}
                    onClick={() => setSelectedRole(role.id)}
                    className={`flex flex-col items-center gap-3 px-8 py-6 rounded-2xl transition-all duration-200 ${
                      selectedRole === role.id
                        ? "surface-lowest shadow-lift ring-2 ring-primary/20"
                        : "surface-container-low hover:surface-lowest hover:shadow-ambient"
                    }`}
                  >
                    <role.icon className={`w-6 h-6 ${selectedRole === role.id ? "text-primary" : "text-muted-foreground"}`} />
                    <span className="text-sm font-medium text-foreground">{role.label}</span>
                  </button>
                ))}
              </div>
            </motion.div>
          )}
        </AnimatePresence>

        {/* Navigation */}
        <div className="flex items-center justify-between mt-12">
          <button
            onClick={() => step > 0 && setStep(step - 1)}
            className={`flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground transition-colors ${step === 0 ? "invisible" : ""}`}
          >
            <ArrowLeft className="w-4 h-4" /> Back
          </button>

          <button
            onClick={() => navigate("/login")}
            className="text-sm text-muted-foreground hover:text-foreground transition-colors"
          >
            Skip
          </button>

          <button
            onClick={() => (isLast ? navigate("/login") : setStep(step + 1))}
            className="flex items-center gap-2 px-6 py-3 rounded-xl gradient-primary text-primary-foreground text-sm font-semibold hover:-translate-y-0.5 hover:shadow-lift transition-all duration-200"
          >
            {isLast ? "Get Started" : "Next"} <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      </div>
    </div>
  );
}
