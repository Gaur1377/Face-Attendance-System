from pydantic import BaseModel

class AttendanceCreate(BaseModel):
    roll_no: int