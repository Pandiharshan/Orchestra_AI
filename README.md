# OrchestraAI

**Multi-Agent AI Development Assistant**

OrchestraAI transforms a single development goal into a complete, production-ready solution using a 5-agent AI pipeline — Research, Planner, Writer, Coder, and Reviewer — powered by Groq's ultra-fast LLM inference.

---

##  Live Demo

**App:** https://orchestraai-iota.vercel.app/login

---

##  Screenshots

###  Login Page
![Login](https://raw.githubusercontent.com/Pandiharshan/Orchestra_AI/main/screenshots/Screenshot%202026-03-31%20162418.png)

###  Dashboard
![Dashboard](https://raw.githubusercontent.com/Pandiharshan/Orchestra_AI/main/screenshots/Screenshot%202026-03-31%20162433.png)

---

##  Features

- Google OAuth & Email authentication via Supabase
- 5-agent AI pipeline: Research → Planner → Writer → Coder → Reviewer
- Real-time AI Workspace — submit any goal, get a complete structured response
- Live agent execution logs on Dashboard
- Analytics with real-time charts from backend data
- Task Manager with Kanban board
- Project Tracker with progress tracking
- Notifications feed from live backend events
- Protected routes — all pages require authentication

---

##  Tech Stack

**Frontend** — React 18, TypeScript, Vite, Tailwind CSS, Framer Motion, Supabase JS, Recharts

**Backend** — Python, FastAPI, Uvicorn, LangChain, Groq (llama-3.3-70b-versatile)

**Auth** — Supabase (Google OAuth + Email/Password)

**Deployment** — Vercel (frontend) + Render (backend)

---

##  API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| POST | `/login` | Email login |
| POST | `/signup` | Email signup |
| POST | `/execute-goal` | Run AI agent pipeline |
| GET | `/logs` | Execution logs |
| GET | `/stats` | Usage statistics |

---
