class ApiConstants {
  // Web Application URL
  static const String baseUrl =
      'http://127.0.0.1:8000';

  // Auth APIs
  static const String login =
      '$baseUrl/auth/login';

  static const String signup =
      '$baseUrl/auth/signup';

  // Face APIs
  static const String registerFace =
      '$baseUrl/register-face';

  static const String markAttendance =
      '$baseUrl/mark-attendance';

  // Attendance APIs
  static const String attendanceRecords =
      '$baseUrl/attendance-records';

  // Export APIs
  static const String exportCsv =
      '$baseUrl/export-csv';

  static const String exportPdf =
      '$baseUrl/export-pdf';
}