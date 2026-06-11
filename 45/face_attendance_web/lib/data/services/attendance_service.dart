import '../../core/constants/api_constants.dart';
import '../../core/network/api_service.dart';

class AttendanceService {
  final ApiService _api = ApiService();

  Future getAttendanceRecords() async {
    return await _api.get(
      ApiConstants.attendanceRecords,
    );
  }
}