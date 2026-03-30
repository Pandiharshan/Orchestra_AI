from crewai import Crew, Task, Process

from services.llm_service import get_llm
from agents.research.research_agent import create_research_agent
from agents.planner.planner_agent import create_planner_agent
from agents.writer.writer_agent import create_writer_agent
from agents.coder.coder_agent import create_coder_agent
from agents.reviewer.reviewer_agent import create_reviewer_agent
from agents.conductor.conductor_agent import create_conductor_agent


def run_orchestration(user_goal):
    llm = get_llm()

    research_agent = create_research_agent(llm)
    planner_agent = create_planner_agent(llm)
    writer_agent = create_writer_agent(llm)
    coder_agent = create_coder_agent(llm)
    reviewer_agent = create_reviewer_agent(llm)
    conductor_agent = create_conductor_agent(llm)

    research_task = Task(
        description=f"Research insights and trends for: {user_goal}",
        expected_output="Research summary",
        agent=research_agent
    )

    planner_task = Task(
        description=f"Create a step-by-step plan for: {user_goal}",
        expected_output="Timeline and roadmap",
        agent=planner_agent
    )

    writer_task = Task(
        description=f"Write content and summaries for: {user_goal}",
        expected_output="Written content",
        agent=writer_agent
    )

    coder_task = Task(
        description=f"Suggest code, APIs, or automation for: {user_goal}",
        expected_output="Code ideas",
        agent=coder_agent
    )

    reviewer_task = Task(
        description="Review and improve all previous outputs",
        expected_output="Improved final review",
        agent=reviewer_agent
    )

    crew = Crew(
        agents=[
            research_agent,
            planner_agent,
            writer_agent,
            coder_agent,
            reviewer_agent,
            conductor_agent
        ],
        tasks=[
            research_task,
            planner_task,
            writer_task,
            coder_task,
            reviewer_task
        ],
        process=Process.sequential,
        verbose=True
    )

    result = crew.kickoff()

    return {
        "goal": user_goal,
        "final_result": str(result),
        "agent_outputs": [
            {
                "agent_name": "Research Agent",
                "output": "Research completed"
            },
            {
                "agent_name": "Planner Agent",
                "output": "Planning completed"
            },
            {
                "agent_name": "Writer Agent",
                "output": "Writing completed"
            },
            {
                "agent_name": "Coder Agent",
                "output": "Code suggestions completed"
            },
            {
                "agent_name": "Reviewer Agent",
                "output": "Review completed"
            }
        ]
    }
