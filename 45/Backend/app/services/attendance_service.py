from datetime import date

from app.models.attendance import Attendance
from app.models.face import Face


def mark_attendance(
    db,
    roll_no: int
):

    # =========================
    # TODAY DATE
    # =========================
    today = date.today()

    # =========================
    # FIND STUDENT
    # =========================
    student = db.query(Face).filter(
        Face.roll_no == roll_no
    ).first()

    # =========================
    # STUDENT NOT FOUND
    # =========================
    if not student:

        return {
            "error": "Student not found"
        }

    # =========================
    # CHECK TODAY ATTENDANCE
    # =========================
    existing = db.query(Attendance).filter(
        Attendance.roll_no == roll_no
    ).all()

    for record in existing:

        if record.timestamp.date() == today:

            return {
                "message":
                "Attendance already marked today"
            }

    # =========================
    # SAVE ATTENDANCE
    # =========================
    new_record = Attendance(

        roll_no=student.roll_no,

        student_name=student.student_name,

        email=student.email,

        course=student.course,

        branch=student.branch
    )

    db.add(new_record)

    db.commit()

    db.refresh(new_record)

    # =========================
    # RESPONSE
    # =========================
    return {

        "message":
        "Attendance marked successfully",

        "student": {

            "roll_no":
            new_record.roll_no,

            "student_name":
            new_record.student_name,

            "email":
            new_record.email,

            "course":
            new_record.course,

            "branch":
            new_record.branch,

            "timestamp":
            new_record.timestamp
        }
    }