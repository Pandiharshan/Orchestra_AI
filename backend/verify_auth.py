from fastapi import FastAPI, APIRouter
from pydantic import BaseModel

app = FastAPI()
router = APIRouter()

class AuthRequest(BaseModel):
    email: str
    password: str

@router.post("/login")
def login(data: AuthRequest):
    return {"status": "success", "user": {"email": data.email}}

app.include_router(router)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8001)
