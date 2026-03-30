from fastapi import APIRouter

router = APIRouter()


@router.get("/logs")
def get_logs():
    return {
        "logs": [
            "Research Agent started",
            "Planner Agent finished",
            "Writer Agent completed"
        ]
    }
