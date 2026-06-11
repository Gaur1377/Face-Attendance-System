from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.student import Student
# from app.models.face import Face
from app.core.database import SessionLocal
from app.models.user import User

import app.core.session as session


# =========================
# GET CURRENT USER
# =========================
def get_current_user():

    # =========================
    # CHECK LOGIN
    # =========================
    if session.current_logged_in_user_id is None:

        raise HTTPException(
            status_code=401,
            detail="Please login first"
        )

    db: Session = SessionLocal()

    try:

        # =========================
        # FIND USER
        # =========================
        user = db.query(User).filter(
            User.id == session.current_logged_in_user_id
        ).first()

        # =========================
        # USER NOT FOUND
        # =========================
        if not user:

            raise HTTPException(
                status_code=401,
                detail="User not found"
            )

        return user

    finally:
        db.close()





# =========================
# GET STUDENT BY ROLL NO
# =========================
def get_student_by_roll_no(
    roll_no: str
):

    db: Session = SessionLocal()

    try:

        student = db.query(Student).filter(
            Student.roll_no == roll_no
        ).first()

        if not student:

            raise HTTPException(
                status_code=404,
                detail="Student not found"
            )

        return student

    finally:
        db.close()