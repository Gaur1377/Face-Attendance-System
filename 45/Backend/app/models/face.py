from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey
)

from app.core.database import Base


class Face(Base):

    __tablename__ = "faces"

    id = Column(
        Integer,
        primary_key=True,
        index=True
    )

    student_id = Column(
        Integer,
        ForeignKey("students.id"),
        nullable=False
    )

    image_path = Column(
        String,
        nullable=False
    )

    encoding_path = Column(
        String,
        nullable=False
    )