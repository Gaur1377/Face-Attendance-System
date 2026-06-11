from app.models.attendance import Attendance

def get_attendance_data(db):
    records = db.query(Attendance).all()

    data = []
    for r in records:
        data.append([r.user_id, str(r.timestamp)])

    return data