from fastapi import APIRouter
from core.constants import APP_NAME, APP_VERSION
import datetime

router = APIRouter()

# In-memory log store — appended to by execute-goal route
execution_logs: list[dict] = []


def append_log(entry: dict):
    execution_logs.append({**entry, "timestamp": datetime.datetime.utcnow().isoformat()})
    # Keep last 100 entries
    if len(execution_logs) > 100:
        execution_logs.pop(0)


@router.get("/logs")
def get_logs():
    return {
        "app": APP_NAME,
        "version": APP_VERSION,
        "logs": execution_logs,
        "count": len(execution_logs),
    }


@router.get("/stats")
def get_stats():
    total_goals = len(execution_logs)
    agents_run = total_goals * 5  # 5 agents per goal
    return {
        "total_goals_executed": total_goals,
        "total_agent_runs": agents_run,
        "model": "llama-3.3-70b-versatile",
        "status": "operational",
    }
