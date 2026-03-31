# OrchestraAI

**Multi-Agent AI Development Assistant**

OrchestraAI is a full-stack web application that transforms a single development goal into a complete, production-ready solution using a 5-agent AI pipeline. A conductor AI delegates tasks to specialized agents — Research, Planner, Writer, Coder, and Reviewer — working sequentially to deliver high-quality, structured output.

---

## 🌐 Live Demo

**Frontend (Vercel):** _Coming soon_
**Backend (Render):** _Coming soon_

---

## 🖼 Screenshots

### 🔐 Login Page
![Login Page](https://raw.githubusercontent.com/Pandiharshan/Orchestra_AI/main/screenshots/Screenshot%202026-03-31%20162418.png)

### 🏠 Dashboard
![Dashboard](https://raw.githubusercontent.com/Pandiharshan/Orchestra_AI/main/screenshots/Screenshot%202026-03-31%20162433.png)

---

## ⚡ Key Features

- **Google OAuth & Email Auth** — Secure authentication via Supabase (Google login + email/password)
- **Multi-Agent AI Pipeline** — 5 specialized agents: Research, Planner, Writer, Coder, Reviewer
- **Real-Time AI Workspace** — Submit any development goal and get a complete structured response
- **Live Agent Logs** — Track every agent execution in real time on the Dashboard
- **Analytics** — Charts showing goal execution history and agent activity over time
- **Task Manager** — Kanban board to create, move, and track tasks
- **Project Tracker** — Create and manage projects with progress tracking
- **Notifications** — Live feed of agent and system events from the backend
- **Settings** — Live model info, dark mode toggle, notification preferences
- **Protected Routes** — All pages require authentication, auto-redirect to login

---

## 🛠 Technology Stack

**Frontend**
- React 18 with TypeScript
- Vite for build tooling
- Tailwind CSS — Warm Minimal Luxury design system
- Framer Motion for animations
- Supabase JS for authentication
- Recharts for analytics charts
- React Router v6

**Backend**
- Python with FastAPI
- Uvicorn ASGI server
- LangChain + Groq (llama-3.3-70b-versatile)
- 5-agent orchestration pipeline
- python-dotenv for config

**Auth & Database**
- Supabase (Google OAuth + Email/Password)

**Deployment**
- Frontend: Vercel
- Backend: Render

---

## 🚀 Local Development Setup

### Prerequisites
- Node.js v18+
- Python 3.10+
- Supabase account (free)
- Groq API key (free at console.groq.com)

### 1. Clone the repository

```bash
git clone https://github.com/Pandiharshan/Orchestra_AI.git
cd Orchestra_AI
```

### 2. Frontend setup

```bash
cd frontend
npm install
```

Create `frontend/.env`:

```env
VITE_API_BASE_URL=http://localhost:8000
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

Start frontend:

```bash
npm run dev
```

Frontend runs at: **http://localhost:8080**

### 3. Backend setup

```bash
cd backend
pip install -r requirements.txt
```

Create `backend/.env`:

```env
GROQ_API_KEY=your_groq_api_key
```

Start backend:

```bash
python -m uvicorn app:app --reload --port 8000
```

Backend runs at: **http://localhost:8000**

---

## 📋 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Backend health check |
| POST | `/login` | Email login |
| POST | `/signup` | Email signup |
| POST | `/execute-goal` | Run 5-agent AI pipeline |
| GET | `/logs` | Get execution logs |
| GET | `/stats` | Get usage statistics |

---

## 🏗 Architecture

```
Frontend (React + Vite)
        ↓
Supabase Auth (Google OAuth / Email)
        ↓
FastAPI Backend (Python)
        ↓
LangChain + Groq LLM
        ↓
5-Agent Pipeline:
  Research → Planner → Writer → Coder → Reviewer
```

---

## 🚢 Deployment

**Frontend → Vercel**
**Backend → Render**

See deployment guide below.

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License.

---

## 👨‍💻 Development Team

- **Pandi Harshan K** — Full Stack Developer — [GitHub](https://github.com/Pandiharshan)

---

## 🙏 Acknowledgments

- Groq for ultra-fast LLM inference
- Supabase for authentication infrastructure
- LangChain for agent orchestration
- React and Vite communities
- Tailwind CSS for utility-first styling

---

*Built with modern web technologies and a multi-agent AI architecture for scalable, intelligent development assistance.*
