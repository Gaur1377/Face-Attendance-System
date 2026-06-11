from fastapi import FastAPI
from app.core.database import Base, engine

from app.routes import auth, student, face, attendance, report
from fastapi.middleware.cors import CORSMiddleware


# Create Tables

# Base.metadata.create_all(bind=engine)

app = FastAPI()
# Base.metadata.drop_all(bind=engine)
Base.metadata.create_all(bind=engine)


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(student.router)
app.include_router(face.router)
app.include_router(attendance.router)
app.include_router(report.router)

@app.get("/")
def root():
    return {"message": "API Running"}