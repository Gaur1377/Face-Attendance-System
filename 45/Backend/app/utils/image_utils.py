import os
import uuid

UPLOAD_DIR = "app/static/faces"

def save_image(file):
    if not os.path.exists(UPLOAD_DIR):
        os.makedirs(UPLOAD_DIR)

    filename = f"{uuid.uuid4()}.jpg"
    path = os.path.join(UPLOAD_DIR, filename)

    with open(path, "wb") as f:
        f.write(file.file.read())

    return path