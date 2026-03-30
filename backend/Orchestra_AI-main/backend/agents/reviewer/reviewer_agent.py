from agents.shared.base_agent import create_base_agent


def create_reviewer_agent(llm):
    return create_base_agent(
        role="Quality Reviewer",
        goal="Review and improve all outputs",
        backstory="Expert in checking clarity, quality, and completeness.",
        llm=llm
    )
