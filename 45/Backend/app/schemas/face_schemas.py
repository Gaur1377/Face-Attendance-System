from pydantic import (
    BaseModel,
    EmailStr
)

from typing import (
    List,
    Optional
)


# =========================
# FACE REGISTER REQUEST
# =========================
class FaceCreate(BaseModel):

    roll_no: int

    student_name: str

    email: EmailStr

    course: str

    branch: str

    

# =========================
# FACE RESPONSE
# =========================
class FaceResponse(BaseModel):

    roll_no: int

    student_name: str

    email: EmailStr

    course: str

    branch: str

    image_path: str

    encoding: List[float]

    class Config:
        from_attributes = True


# =========================
# FACE MATCH REQUEST
# =========================
class FaceMatchRequest(BaseModel):

    encoding: Optional[
        List[float]
    ] = None


# =========================
# FACE MATCH RESPONSE
# =========================
class FaceMatchResponse(BaseModel):

    matched: bool

    student: Optional[dict] = None

    message: str