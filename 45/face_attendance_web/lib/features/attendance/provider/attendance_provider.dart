import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttendanceProvider extends ChangeNotifier {

  // =========================
  // BASE URL
  // =========================
  final String baseUrl =
      'http://localhost:8000';

  // =========================
  // STATES
  // =========================
  bool scanning = false;

  bool isLoading = false;

  // =========================
  // LOGS
  // =========================
  List<Map<String, dynamic>>
  logs = [];

  // =========================
  // START SCANNING
  // =========================
  void startScanning() {

    scanning = true;

    notifyListeners();
  }

  // =========================
  // STOP SCANNING
  // =========================
  void stopScanning() {

    scanning = false;

    notifyListeners();
  }

  // =========================
  // ADD LOG
  // =========================
  void addLog({

    required String rollNo,

    required String studentName,

    required String timestamp,

    required String status,
  }) {

    logs.insert(0, {

      "roll_no": rollNo,

      "student_name": studentName,

      "timestamp": timestamp,

      "status": status,
    });

    notifyListeners();
  }

  // =========================
  // FETCH TODAY ATTENDANCE
  // =========================
  Future<void> fetchTodayAttendance()
  async {

    try {

      isLoading = true;

      notifyListeners();

      final response =
      await http.get(

        Uri.parse(
          '$baseUrl/attendance/today',
        ),
      );

      if (response.statusCode == 200) {

        final data =
        jsonDecode(response.body);

        logs.clear();

        for (var item in data) {

          logs.add({

            "roll_no":
            item["roll_no"],

            "student_name":
            item["student_name"],

            "timestamp":
            item["timestamp"],

            "status":
            "Present",
          });
        }
      }

    } catch (e) {

      debugPrint(
        e.toString(),
      );

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }

  // =========================
  // CLEAR LOGS
  // =========================
  void clearLogs() {

    logs.clear();

    notifyListeners();
  }
}