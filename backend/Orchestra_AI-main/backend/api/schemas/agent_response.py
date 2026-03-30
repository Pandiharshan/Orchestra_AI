from pydantic import BaseModel


class AgentResponse(BaseModel):
    agent_name: str
    output: str
