from agents.shared.base_agent import create_base_agent


def create_conductor_agent(llm):
    return create_base_agent(
        role="Conductor Agent",
        goal="Coordinate all agents and merge outputs",
        backstory="Expert project manager who orchestrates multiple teams.",
        llm=llm
    )
