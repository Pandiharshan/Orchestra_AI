from fastapi import APIRouter
from api.schemas.goal_request import GoalRequest
from services.orchestration_service import run_orchestration
from api.routes.logs import append_log

router = APIRouter()


@router.post("/execute-goal")
def execute_goal(data: GoalRequest):
    append_log({"event": "goal_received", "goal": data.goal})
    result = run_orchestration(data.goal)
    for ao in result.get("agent_outputs", []):
        append_log({"event": "agent_completed", "agent": ao["agent_name"], "goal": data.goal})
    append_log({"event": "orchestration_complete", "goal": data.goal})
    return result
