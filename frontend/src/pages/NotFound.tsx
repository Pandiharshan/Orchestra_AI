import { useLocation, useNavigate } from "react-router-dom";
import { useEffect } from "react";
import { Sparkles } from "lucide-react";

export default function NotFound() {
  const location = useLocation();
  const navigate = useNavigate();

  useEffect(() => {
    console.error("404:", location.pathname);
  }, [location.pathname]);

  return (
    <div className="flex min-h-screen items-center justify-center surface">
      <div className="text-center">
        <div className="w-16 h-16 rounded-2xl gradient-primary flex items-center justify-center mx-auto mb-6 shadow-ambient">
          <Sparkles className="w-8 h-8 text-primary-foreground" />
        </div>
        <h1 className="text-6xl font-bold text-foreground mb-3 tracking-tight">404</h1>
        <p className="text-muted-foreground mb-8">This page doesn't exist.</p>
        <button onClick={() => navigate("/")}
          className="px-6 py-3 rounded-xl gradient-primary text-primary-foreground text-sm font-semibold hover:-translate-y-0.5 hover:shadow-lift transition-all duration-200">
          Back to Dashboard
        </button>
      </div>
    </div>
  );
}
