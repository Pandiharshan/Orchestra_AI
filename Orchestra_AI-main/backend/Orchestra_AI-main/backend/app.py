from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from api.routes.execute_goal import router as execute_goal_router
from api.routes.health import router as health_router
from api.routes.logs import router as logs_router

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(execute_goal_router)
app.include_router(health_router)
app.include_router(logs_router)
