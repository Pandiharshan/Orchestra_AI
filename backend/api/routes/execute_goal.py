from fastapi import APIRouter
from api.schemas.goal_request import GoalRequest
from services.orchestration_service import run_orchestration

router = APIRouter()


@router.post("/execute-goal")
def execute_goal(data: GoalRequest):
    return run_orchestration(data.goal)
