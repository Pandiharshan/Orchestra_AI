from pydantic import BaseModel


class GoalRequest(BaseModel):
    goal: str
