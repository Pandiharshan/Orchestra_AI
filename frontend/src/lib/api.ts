const BASE_URL = (import.meta.env.VITE_API_BASE_URL as string) ?? "http://localhost:8000";

async function request<T>(path: string, options?: RequestInit): Promise<T> {
  const res = await fetch(`${BASE_URL}${path}`, {
    headers: { "Content-Type": "application/json" },
    ...options,
  });
  if (!res.ok) {
    const text = await res.text();
    throw new Error(text || `Request failed: ${res.status}`);
  }
  return res.json() as Promise<T>;
}

export interface LogEntry {
  event: string;
  goal?: string;
  agent?: string;
  timestamp: string;
}

export interface AgentOutput {
  agent_name: string;
  output: string;
}

export interface ExecuteGoalResult {
  goal: string;
  final_result: string;
  agent_outputs: AgentOutput[];
}

export interface StatsResult {
  total_goals_executed: number;
  total_agent_runs: number;
  model: string;
  status: string;
}

export const api = {
  health: () =>
    request<{ status: string; message: string }>("/health"),

  login: (email: string, password: string) =>
    request<{ status: string; user: { email: string; name: string } }>("/login", {
      method: "POST",
      body: JSON.stringify({ email, password }),
    }),

  signup: (email: string, password: string) =>
    request<{ status: string; user: { email: string; name: string } }>("/signup", {
      method: "POST",
      body: JSON.stringify({ email, password }),
    }),

  executeGoal: (goal: string) =>
    request<ExecuteGoalResult>("/execute-goal", {
      method: "POST",
      body: JSON.stringify({ goal }),
    }),

  getLogs: () =>
    request<{ app: string; version: string; logs: LogEntry[]; count: number }>("/logs"),

  getStats: () =>
    request<StatsResult>("/stats"),
};
