from fastapi import APIRouter, Depends

from sqlalchemy.orm import Session

from app.core.database import SessionLocal

from app.models.user import User

from app.schemas.user_schemas import UserCreate, UserLogin



import hashlib


router = APIRouter(
    prefix="/auth",
    tags=["Auth"]
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
# HASH PASSWORD
# =========================
def hash_password(password: str):

    return hashlib.sha256(
        password.encode()
    ).hexdigest()


# =========================
# REGISTER TEACHER
# =========================
@router.post("/register")
def register_teacher(

    teacher: UserCreate,

    db: Session = Depends(get_db)
):

    existing_teacher = db.query(User).filter(
        User.email == teacher.email
    ).first()

    if existing_teacher:

        return {
            "message":
            "Teacher already exists"
        }
    try:
        
        new_teacher = User(

            name=teacher.name,

            email=teacher.email,

            subject=teacher.subject,

            password=hash_password(
                teacher.password
            )
        )

        db.add(new_teacher)

        db.commit()

        db.refresh(new_teacher)

        return {

            "message":
            "Teacher registered successfully"
    }
    except Exception as e:

        return {
            "message":
            f"Error: {str(e)}"
        }


# =========================
# LOGIN TEACHER
# =========================
@router.post("/login")
def login_teacher(

    teacher: UserLogin,

    db: Session = Depends(get_db)
):

    existing_teacher  = db.query(User).filter(
        User.email == teacher.email
    ).first()

    if not existing_teacher:

        return {
            "message":
            "Teacher not found"
        }

    if existing_teacher.password != hash_password(teacher.password):

        return {
            "message":
            "Wrong password"
        }

    return {

        "message":
        "Login successful",
        
        "user_id": existing_teacher.id,

        "teacher": {

            "id":
            existing_teacher.id,

            "name":
            existing_teacher.name,

            "email":
            existing_teacher.email,

            "subject":
            existing_teacher.subject
        }
    }