from pydantic import BaseModel, EmailStr, Field

# 👉 Request model (Create User)
class UserCreate(BaseModel):

    name: str

    email: str

    subject: str

    password: str


class UserLogin(BaseModel):

    email: str

    password: str

# 👉 Response model (Send back to frontend)
class UserResponse(BaseModel):
    id: int
    name: str
    subject: str
    email: EmailStr

    class Config:
        from_attributes = True   # for SQLAlchemy (Pydantic v2)