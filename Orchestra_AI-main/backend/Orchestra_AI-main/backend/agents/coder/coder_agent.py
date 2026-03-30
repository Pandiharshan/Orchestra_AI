from agents.shared.base_agent import create_base_agent


def create_coder_agent(llm):
    return create_base_agent(
        role="Code Generator",
        goal="Generate scripts and technical suggestions",
        backstory="Expert in Python, APIs, automation, and development.",
        llm=llm
    )
