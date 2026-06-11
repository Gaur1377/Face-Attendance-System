import '../services/attendance_service.dart';

class AttendanceRepository {
  final AttendanceService _service =
      AttendanceService();

  Future getAttendanceRecords() async {
    return await _service.getAttendanceRecords();
  }
}