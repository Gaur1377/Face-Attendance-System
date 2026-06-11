# Face Attendance System

## Overview

The Face Attendance System is a smart attendance management application that uses facial recognition technology to automatically detect and identify individuals. Once a face is recognized, the system marks attendance and stores the record with the date and time, reducing manual effort and improving accuracy.

## Features

* Real-time face detection
* Face recognition using stored facial data
* Automatic attendance marking
* Attendance records with timestamp
* User-friendly interface
* Secure and efficient attendance management

## Technologies Used

* Python
* OpenCV
* Face Recognition Library
* NumPy
* Pandas
* SQLite Database

## Project Structure
Face-Attendance-System/
│
├── backend/
│   ├── database/
│   │   └── attendance.db
│   ├── images/
│   │   └── registered_faces/
│   ├── attendance.py
│   ├── face_recognition.py
│   ├── api.py
│   ├── requirements.txt
│   └── main.py
│
├── frontend/
│   ├── lib/
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   └── attendance_screen.dart
│   │   ├── services/
│   │   │   └── api_service.dart
│   │   ├── models/
│   │   │   └── attendance_model.dart
│   │   ├── widgets/
│   │   └── main.dart
│   │
│   ├── assets/
│   └── pubspec.yaml
│
└──  README.md

## Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/Face-Attendance-System.git
```

2. Navigate to the project directory:

```bash
cd Face-Attendance-System
```

3. Install required dependencies:

```bash
pip install -r requirements.txt
```

## Usage

1. Add user images to the `images` folder.
2. Run the application:

```bash
python main.py
```

3. The system will:

   * Detect faces through the camera.
   * Recognize registered users.
   * Automatically mark attendance.
   * Save attendance records with date and time.

## Benefits

* Eliminates manual attendance tracking.
* Improves attendance accuracy.
* Saves time and administrative effort.
* Provides secure identity verification.

## Future Enhancements

* Cloud database integration
* Web dashboard for attendance reports
* Mobile application support
* Email notifications
* Multi-camera support

## Author

Gaurav Kumar

