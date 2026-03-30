from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter()

class AuthRequest(BaseModel):
    email: str
    password: str

@router.post("/login")
def login(data: AuthRequest):
    # Simple simulation for demonstration: "user@example.com" / "password"
    if data.email == "user@example.com" and data.password == "password":
        return {"status": "success", "user": {"email": data.email, "name": "Orchestra User"}}
    
    # Also allow any login for now but validate format
    if "@" in data.email and len(data.password) >= 6:
        return {"status": "success", "user": {"email": data.email, "name": "New User"}}
        
    raise HTTPException(status_code=401, detail="Invalid credentials")

@router.post("/signup")
def signup(data: AuthRequest):
    if "@" not in data.email:
        raise HTTPException(status_code=400, detail="Invalid email format")
    if len(data.password) < 6:
        raise HTTPException(status_code=400, detail="Password too short")
        
    return {"status": "success", "user": {"email": data.email, "name": "New Registered User"}}
