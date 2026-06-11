import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DashboardProvider extends ChangeNotifier {

  // =========================
  // API URL
  // =========================
  final String baseUrl =
      'http://127.0.0.1:8000';
  // =========================
  // COUNTS
  // =========================
  int totalStudents = 0;

  int presentToday = 0;

  int absentToday = 0;

  bool isLoading = false;

  // =========================
  // RECENT LOGS
  // =========================
  List<Map<String, dynamic>> recentLogs = [];

  // =========================
  // LOAD DASHBOARD
  // =========================
  Future<void> loadDashboard() async {

    isLoading = true;

    notifyListeners();

    try {

      // =========================
      // STUDENTS
      // =========================
      final studentResponse = await http.get(

        Uri.parse(
          '$baseUrl/student/all',
        ),
      );

      if (studentResponse.statusCode == 200) {

        final studentData =
        jsonDecode(studentResponse.body);

        if (studentData is List) {

          totalStudents =
              studentData.length;
        }

        else if (
        studentData is Map &&
            studentData["students"] != null
        ) {

          totalStudents =
              studentData["students"].length;
        }
      }

      // =========================
      // ATTENDANCE
      // =========================
      final attendanceResponse =
      await http.get(

        Uri.parse(
          '$baseUrl/attendance/today',
        ),
      );

      if (attendanceResponse.statusCode == 200) {

        final attendanceData =
        jsonDecode(attendanceResponse.body);

        List<dynamic> attendance = [];

        if (attendanceData is List) {

          attendance = attendanceData;
        }

        else if (
        attendanceData is Map &&
            attendanceData["attendance"] != null
        ) {

          attendance =
          attendanceData["attendance"];
        }

        presentToday =
            attendance.length;

        absentToday =
            totalStudents - presentToday;

        if (absentToday < 0) {

          absentToday = 0;
        }

        recentLogs =
            attendance.map<Map<String, dynamic>>(

                  (item) {

                return {

                  "student_name":
                  item["student_name"] ?? "",

                  "roll_no":
                  item["roll_no"] ?? "",

                  "timestamp":
                  item["timestamp"] ?? "",
                };
              },
        ).toList();
      }
    }

    catch (e) {

      debugPrint(
        "Dashboard Error: $e",
      );
    }

    isLoading = false;

    notifyListeners();
  }
}