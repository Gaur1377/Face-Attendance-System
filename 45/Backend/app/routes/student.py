from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.database import SessionLocal

from app.models.student import Student
from app.models.face import Face
from app.models.attendance import Attendance


router = APIRouter(
    prefix="/student",
    tags=["Student"]
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
# GET ALL STUDENTS
# =========================
@router.get("/all")
def get_students(
    db: Session = Depends(get_db)
):

    students = db.query(Student).all()

    data = []

    for student in students:

        face = db.query(Face).filter(
            Face.student_id == student.id
        ).first()

        attendance_count = db.query(
            Attendance
        ).filter(
            Attendance.roll_no == student.roll_no
        ).count()

        data.append({

            "id":
            student.id,

            "roll_no":
            student.roll_no,

            "student_name":
            student.student_name,

            "email":
            student.email,

            "course":
            student.course,

            "branch":
            student.branch,

            "face_registered":
            True if face else False,

            "attendance_count":
            attendance_count
        })

    return {

        "total_students":
        len(data),

        "students":
        data
    }


# =========================
# GET SINGLE STUDENT
# =========================
@router.get("/{roll_no}")
def get_student(

    roll_no: str,

    db: Session = Depends(get_db)
):

    student = db.query(Student).filter(
        Student.roll_no == roll_no
    ).first()

    if not student:

        return {
            "error":
            "Student not found"
        }

    face = db.query(Face).filter(
        Face.student_id == student.id
    ).first()

    attendance = db.query(
        Attendance
    ).filter(
        Attendance.roll_no == roll_no
    ).all()

    attendance_data = []

    for record in attendance:

        attendance_data.append({

            "attendance_id":
            record.id,

            "timestamp":
            record.timestamp,

            "status":
            record.status
        })

    return {

        "id":
        student.id,

        "roll_no":
        student.roll_no,

        "student_name":
        student.student_name,

        "email":
        student.email,

        "course":
        student.course,

        "branch":
        student.branch,

        "face_registered":
        True if face else False,

        "total_attendance":
        len(attendance_data),

        "attendance_records":
        attendance_data
    }