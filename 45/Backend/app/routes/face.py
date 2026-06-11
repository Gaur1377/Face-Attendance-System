import os
import pickle

from fastapi import (
    APIRouter,
    UploadFile,
    File,
    Form,
    Depends,
    HTTPException
)

from sqlalchemy.orm import Session

from app.core.database import SessionLocal

from app.models.student import Student
from app.models.face import Face

import face_recognition


router = APIRouter(
    prefix="/face",
    tags=["Face"]
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
# REGISTER FACE
# =========================
@router.post("/register")
async def register_face(

    roll_no: str = Form(...),

    name: str = Form(...),

    email: str = Form(...),

    course: str = Form(...),

    branch: str = Form(...),

    file: UploadFile = File(...),

    db: Session = Depends(get_db)
):

    # =========================
    # CHECK EXISTING STUDENT
    # =========================
    existing_student = db.query(
        Student
    ).filter(
        Student.roll_no == roll_no
    ).first()

    if existing_student:

        raise HTTPException(
            status_code=400,
            detail="Student already exists"
        )

    # =========================
    # CREATE FOLDERS
    # =========================
    os.makedirs(
        "uploads/faces",
        exist_ok=True
    )

    os.makedirs(
        "uploads/encodings",
        exist_ok=True
    )

    # =========================
    # SAVE IMAGE
    # =========================
    file_path = f"uploads/faces/{roll_no}.jpg"

    contents = await file.read()

    with open(file_path, "wb") as f:

        f.write(contents)

    # =========================
    # FACE ENCODING
    # =========================
    image = face_recognition.load_image_file(
        file_path
    )

    encodings = face_recognition.face_encodings(
        image
    )

    if len(encodings) == 0:

        os.remove(file_path)

        raise HTTPException(
            status_code=400,
            detail="No face detected"
        )

    encoding = encodings[0]

    # =========================
    # SAVE ENCODING
    # =========================
    encoding_path = (
        f"uploads/encodings/{roll_no}.pkl"
    )

    with open(encoding_path, "wb") as f:

        pickle.dump(encoding, f)

    # =========================
    # SAVE STUDENT
    # =========================
    student = Student(

        roll_no=roll_no,

        student_name=name,

        email=email,

        course=course,

        branch=branch
    )

    db.add(student)

    db.commit()

    db.refresh(student)

    # =========================
    # SAVE FACE
    # =========================
    face = Face(

        student_id=student.id,

        image_path=file_path,

        encoding_path=encoding_path
    )

    db.add(face)

    db.commit()

    return {

        "message":
        "Student Face Registered Successfully"
    }