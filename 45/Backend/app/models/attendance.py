from sqlalchemy import (
    Column,
    Integer,
    String,
    DateTime
)

from datetime import datetime

from app.core.database import Base


class Attendance(Base):

    __tablename__ = "attendance"

    id = Column(
        Integer,
        primary_key=True,
        index=True
    )

    roll_no = Column(String)

    student_name = Column(String)

    timestamp = Column(
        DateTime,
        default=datetime.utcnow
    )

    status = Column(
        String,
        default="Present"
    )