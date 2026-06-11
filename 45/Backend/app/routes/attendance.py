from fastapi import (
    APIRouter,
    Depends,
    UploadFile,
    File,
    Form
)

from sqlalchemy import func
from sqlalchemy.orm import Session

from app.core.database import SessionLocal

from app.models.student import Student
from app.models.face import Face
from app.models.attendance import Attendance

import face_recognition
import numpy as np
import pickle

from datetime import (
    date,
    datetime
)

router = APIRouter(
    prefix="/attendance",
    tags=["Attendance"]
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
# MARK ATTENDANCE
# =========================
@router.post("/mark")
async def mark_attendance(

    roll_no: str = Form(...),

    file: UploadFile = File(...),

    db: Session = Depends(get_db)
):

    try:

        # =========================
        # FIND STUDENT
        # =========================
        student = db.query(Student).filter(
            Student.roll_no == roll_no
        ).first()

        if not student:

            return {

                "success": False,

                "message":
                "Invalid Roll Number"
            }

        # =========================
        # GET STUDENT FACE
        # =========================
        face = db.query(Face).filter(
            Face.student_id == student.id
        ).first()

        if not face:

            return {

                "success": False,

                "message":
                "Face Not Registered"
            }

        # =========================
        # READ IMAGE
        # =========================
        image_bytes = await file.read()

        np_array = np.frombuffer(
            image_bytes,
            np.uint8
        )

        image = face_recognition.load_image_file(
            file.file
        )

        # =========================
        # DETECT FACE
        # =========================
        face_locations = face_recognition.face_locations(
            image
        )

        # =========================
        # NO FACE
        # =========================
        if len(face_locations) == 0:

            return {

                "success": False,

                "message":
                "No Face Detected"
            }

        # =========================
        # MULTIPLE FACES
        # =========================
        if len(face_locations) > 1:

            return {

                "success": False,

                "message":
                "Multiple Faces Detected"
            }

        # =========================
        # FACE ENCODING
        # =========================
        face_encodings = face_recognition.face_encodings(
            image,
            face_locations
        )

        uploaded_encoding = face_encodings[0]

        # =========================
        # LOAD SAVED ENCODING
        # =========================
        with open(
            face.encoding_path,
            "rb"
        ) as f:

            saved_encoding = pickle.load(f)

        # =========================
        # FACE DISTANCE
        # =========================
        face_distance = face_recognition.face_distance(
            [saved_encoding],
            uploaded_encoding
        )[0]

        # =========================
        # FACE MATCH
        # =========================
        match = face_recognition.compare_faces(

            [saved_encoding],

            uploaded_encoding,

            tolerance=0.45
        )[0]

        # =========================
        # FACE NOT MATCHED
        # =========================
        if not match:

            return {

                "success": False,

                "message":
                "Face Not Matched With Roll Number"
            }

        # =========================
        # CHECK TODAY ATTENDANCE
        # =========================
        today = date.today()

        already_marked = db.query(
            Attendance
        ).filter(

            Attendance.roll_no ==
            student.roll_no,

            func.date(
                Attendance.timestamp
            ) == today

        ).first()

        # =========================
        # ALREADY MARKED
        # =========================
        if already_marked:

            return {

                "success": False,

                "message":
                "Attendance Already Marked",

                "student_name":
                student.student_name,

                "roll_no":
                student.roll_no
            }

        # =========================
        # SAVE ATTENDANCE
        # =========================
        attendance = Attendance(

            roll_no=
            student.roll_no,

            timestamp=
            datetime.now()
        )

        db.add(attendance)

        db.commit()

        # =========================
        # CONFIDENCE
        # =========================
        confidence = round(
            (1 - face_distance) * 100,
            2
        )

        # =========================
        # SUCCESS
        # =========================
        return {

            "success": True,

            "message":
            "Attendance Marked Successfully",

            "student_name":
            student.student_name,

            "roll_no":
            student.roll_no,

            "course":
            student.course,

            "branch":
            student.branch,

            "timestamp":
            str(attendance.timestamp),

            "confidence":
            confidence
        }

    except Exception as e:

        return {

            "success": False,

            "message":
            str(e)
        }


# =========================
# GET ALL ATTENDANCE
# =========================
@router.get("/all")
def get_all(
    db: Session = Depends(get_db)
):

    records = db.query(
        Attendance
    ).all()

    data = []

    for record in records:

        student = db.query(Student).filter(
            Student.roll_no == record.roll_no
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

            "timestamp":
            str(record.timestamp)
        })

    return {

        "success": True,

        "total_records":
        len(data),

        "attendance":
        data
    }


# =========================
# TODAY ATTENDANCE
# =========================
@router.get("/today")
def today_attendance(
    db: Session = Depends(get_db)
):

    today = date.today()

    attendance = db.query(
        Attendance
    ).filter(

        func.date(
            Attendance.timestamp
        ) == today

    ).all()

    data = []

    for record in attendance:

        student = db.query(Student).filter(
            Student.roll_no == record.roll_no
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

            "timestamp":
            str(record.timestamp)
        })

    return {

        "success": True,

        "total_today_attendance":
        len(data),

        "attendance":
        data
    }