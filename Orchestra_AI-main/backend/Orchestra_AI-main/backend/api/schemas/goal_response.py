from pydantic import BaseModel
from typing import List
from api.schemas.agent_response import AgentResponse


class GoalResponse(BaseModel):
    goal: str
    final_result: str
    agent_outputs: List[AgentResponse]
