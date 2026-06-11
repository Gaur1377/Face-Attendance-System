from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.database import SessionLocal

from app.models.attendance import Attendance
from app.models.student import Student
from app.models.face import Face

router = APIRouter(
    prefix="/report",
    tags=["Report"]
)


# =========================
# DATABASE
# =========================
def get_db():

    db = SessionLocal()

    try:
        yield db

    finally:
        db.close()


# =========================
# EXPORT REPORT
# =========================
@router.get("/export")
def export(
    db: Session = Depends(get_db)
):

    records = db.query(
        Attendance
    ).all()

    data = []

    for record in records:

        # =========================
        # FIND STUDENT
        # =========================
        student = db.query(Student).filter(
            Student.roll_no == record.roll_no
        ).first()

        face = None

        # =========================
        # FIND FACE
        # =========================
        if student:

            face = db.query(Face).filter(
                Face.student_id == student.id
            ).first()

        data.append({

            "attendance_id":
            record.id,

            "roll_no":
            record.roll_no,

            "student_name":
            student.student_name
            if student else None,

            "email":
            student.email
            if student else None,

            "course":
            student.course
            if student else None,

            "branch":
            student.branch
            if student else None,

            "image_path":
            face.image_path
            if face else None,

            "timestamp":
            record.timestamp
        })

    return {

        "total_records":
        len(data),

        "report":
        data
    }