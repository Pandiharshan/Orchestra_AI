from agents.shared.base_agent import create_base_agent


def create_planner_agent(llm):
    return create_base_agent(
        role="Planning Expert",
        goal="Create timelines and action plans",
        backstory="Expert in schedules, planning, and roadmaps.",
        llm=llm
    )
