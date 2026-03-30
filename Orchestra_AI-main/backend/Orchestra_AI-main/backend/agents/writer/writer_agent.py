from agents.shared.base_agent import create_base_agent


def create_writer_agent(llm):
    return create_base_agent(
        role="Content Writer",
        goal="Write polished content and summaries",
        backstory="Expert in blogs, reports, emails, and announcements.",
        llm=llm
    )
