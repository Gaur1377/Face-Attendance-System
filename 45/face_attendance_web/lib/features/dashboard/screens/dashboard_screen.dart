import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../shared/widgets/sidebar.dart';

import '../widgets/attendance_chart.dart';
import '../widgets/recent_log_table.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {

  final int userId;

  const DashboardScreen({
    super.key,
    required this.userId,
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  // =========================
  // COUNTS
  // =========================
  int totalStudents = 0;

  int presentToday = 0;

  int absentToday = 0;

  bool isLoading = true;

  // =========================
  // RECENT LOGS
  // =========================
  List<Map<String, dynamic>>
  recentLogs = [];

  // =========================
  // BASE URL
  // =========================
  final String baseUrl =

  kIsWeb

      ? 'http://localhost:8000'

      : 'http://10.0.2.2:8000';

  @override
  void initState() {

    super.initState();

    loadDashboardData();
  }

  // =========================
  // LOAD DASHBOARD
  // =========================
  Future<void> loadDashboardData() async {

    try {

      // =========================
      // STUDENTS API
      // =========================
      final studentResponse =
      await http.get(

        Uri.parse(
          '$baseUrl/student/all',
        ),
      );

      // =========================
      // ATTENDANCE API
      // =========================
      final attendanceResponse =
      await http.get(

        Uri.parse(
          '$baseUrl/attendance/today',
        ),
      );

      // =========================
      // STUDENTS
      // =========================
      if (studentResponse.statusCode ==
          200) {

        final studentData =
        jsonDecode(
          studentResponse.body,
        );

        // LIST RESPONSE
        if (studentData is List) {

          totalStudents =
              studentData.length;
        }

        // MAP RESPONSE
        else if (studentData is Map) {

          if (studentData["students"]
          is List) {

            totalStudents =
                studentData["students"]
                    .length;
          }

          else if (studentData["data"]
          is List) {

            totalStudents =
                studentData["data"]
                    .length;
          }

          else if (studentData["total"]
          != null) {

            totalStudents =
                int.tryParse(
                  studentData["total"]
                      .toString(),
                ) ??
                    0;
          }
        }
      }

      // =========================
      // ATTENDANCE
      // =========================
      if (attendanceResponse.statusCode ==
          200) {

        final attendanceData =
        jsonDecode(
          attendanceResponse.body,
        );

        List<dynamic> attendance =
        [];

        // LIST RESPONSE
        if (attendanceData is List) {

          attendance =
              attendanceData;
        }

        // MAP RESPONSE
        else if (attendanceData is Map) {

          if (attendanceData["attendance"]
          is List) {

            attendance =
            attendanceData["attendance"];
          }

          else if (attendanceData["data"]
          is List) {

            attendance =
            attendanceData["data"];
          }
        }

        // =========================
        // PRESENT
        // =========================
        presentToday =
            attendance.length;

        // =========================
        // ABSENT
        // =========================
        absentToday =
            totalStudents -
                presentToday;

        if (absentToday < 0) {

          absentToday = 0;
        }

        // =========================
        // RECENT LOGS
        // =========================
        recentLogs =
            attendance.map<Map<String, dynamic>>(

                  (item) {

                return {

                  "roll_no":
                  item["roll_no"]
                      ?.toString() ??
                      "",

                  "student_name":
                  item["student_name"]
                      ?.toString() ??
                      "Unknown",

                  "timestamp":
                  item["timestamp"]
                      ?.toString() ??
                      "",

                  "status":
                  item["status"]
                      ?.toString() ??
                      "Present",
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

    if (mounted) {

      setState(() {

        isLoading = false;
      });
    }
  }

  // =========================
  // HEADER
  // =========================
  Widget dashboardHeader() {

    return Text(

      'Dashboard',

      style: TextStyle(

        fontSize:
        MediaQuery.of(context)
            .size
            .width <
            600

            ? 24

            : 32,

        fontWeight:
        FontWeight.bold,
      ),
    );
  }

  // =========================
  // MOBILE CARDS
  // =========================
  Widget mobileCards() {

    return Column(

      children: [

        StatCard(

          title:
          "Total Students",

          value:
          totalStudents.toString(),

          icon:
          Icons.people,
        ),

        const SizedBox(
          height: 15,
        ),

        StatCard(

          title:
          "Present Today",

          value:
          presentToday.toString(),

          icon:
          Icons.check_circle,
        ),

        const SizedBox(
          height: 15,
        ),

        StatCard(

          title:
          "Absent Today",

          value:
          absentToday.toString(),

          icon:
          Icons.cancel,
        ),
      ],
    );
  }

  // =========================
  // DESKTOP CARDS
  // =========================
  Widget desktopCards() {

    return Row(

      children: [

        Expanded(

          child: StatCard(

            title:
            "Total Students",

            value:
            totalStudents.toString(),

            icon:
            Icons.people,
          ),
        ),

        const SizedBox(
          width: 20,
        ),

        Expanded(

          child: StatCard(

            title:
            "Present Today",

            value:
            presentToday.toString(),

            icon:
            Icons.check_circle,
          ),
        ),

        const SizedBox(
          width: 20,
        ),

        Expanded(

          child: StatCard(

            title:
            "Absent Today",

            value:
            absentToday.toString(),

            icon:
            Icons.cancel,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Colors.grey.shade100,

      body: SafeArea(

        child:
        isLoading

            ? const Center(

          child:
          CircularProgressIndicator(),
        )

            : LayoutBuilder(

          builder:
              (
              context,
              constraints,
              ) {

            final isMobile =
                constraints.maxWidth <
                    900;

            // =========================
            // MOBILE
            // =========================
            if (isMobile) {

              return SingleChildScrollView(

                child: Padding(

                  padding:
                  const EdgeInsets.all(
                    16,
                  ),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      dashboardHeader(),

                      const SizedBox(
                        height: 20,
                      ),

                      mobileCards(),

                      const SizedBox(
                        height: 20,
                      ),

                      AttendanceChart(

                        totalStudents:
                        totalStudents,

                        presentToday:
                        presentToday,

                        absentToday:
                        absentToday,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      RecentLogTable(

                        logs:
                        recentLogs,
                      ),
                    ],
                  ),
                ),
              );
            }

            // =========================
            // DESKTOP
            // =========================
            return Row(

              children: [

                const Sidebar(),

                Expanded(

                  child:
                  SingleChildScrollView(

                    child: Padding(

                      padding:
                      const EdgeInsets.all(
                        20,
                      ),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          dashboardHeader(),

                          const SizedBox(
                            height: 30,
                          ),

                          desktopCards(),

                          const SizedBox(
                            height: 30,
                          ),

                          AttendanceChart(

                            totalStudents:
                            totalStudents,

                            presentToday:
                            presentToday,

                            absentToday:
                            absentToday,
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          RecentLogTable(

                            logs:
                            recentLogs,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}