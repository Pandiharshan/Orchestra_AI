from agents.shared.base_agent import create_base_agent


def create_research_agent(llm):
    return create_base_agent(
        role="Research Specialist",
        goal="Find insights, trends, and useful information",
        backstory="Expert in market research and competitor analysis.",
        llm=llm
    )
