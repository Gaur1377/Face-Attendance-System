import face_recognition
import numpy as np

def encode_face(image_path: str):
    image = face_recognition.load_image_file(image_path)
    encodings = face_recognition.face_encodings(image)

    if not encodings:
        return None

    return encodings[0].tolist()  # store as list (JSON-friendly)


def compare_faces(known_encodings, unknown_encoding):
    if not known_encodings:
        return None

    results = face_recognition.compare_faces(
        known_encodings, unknown_encoding, tolerance=0.5
    )

    for i, match in enumerate(results):
        if match:
            return i  # return matched index

    return None