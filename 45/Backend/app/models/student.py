from sqlalchemy import Column, Integer, String

from app.core.database import Base


class Student(Base):

    __tablename__ = "students"

    id = Column(
        Integer,
        primary_key=True,
        index=True
    )

    roll_no = Column(
        String,
        unique=True,
        index=True
    )

    student_name = Column(String)

    email = Column(String)

    course = Column(String)

    branch = Column(String)