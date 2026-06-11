import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../shared/widgets/sidebar.dart';
import '../widgets/export_card.dart';
import '../widgets/report_table.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() =>
      _ExportScreenState();
}

class _ExportScreenState
    extends State<ExportScreen> {

  // =========================
  // BACKEND URL
  // =========================
  final String baseUrl =
      'http://127.0.0.1:8000';

  // =========================
  // REPORT DATA
  // =========================
  List<Map<String, dynamic>>
  reportData = [];

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    loadReports();
  }

  // =========================
  // LOAD REPORTS
  // =========================
  Future<void> loadReports() async {

    try {

      final response =
      await http.get(

        Uri.parse(
          '$baseUrl/attendance/all',
        ),
      );

      if (response.statusCode == 200) {

        final data =
        jsonDecode(response.body);

        List attendanceList = [];

        // =========================
        // HANDLE MAP RESPONSE
        // =========================
        if (data is Map &&
            data["attendance"] != null) {

          attendanceList =
          data["attendance"];
        }

        // =========================
        // HANDLE LIST RESPONSE
        // =========================
        else if (data is List) {

          attendanceList = data;
        }

        // =========================
        // GROUP STUDENTS
        // =========================
        Map<String, int>
        attendanceCount = {};

        for (var item
        in attendanceList) {

          String rollNo =
          item["roll_no"]
              .toString();

          attendanceCount[rollNo] =
              (attendanceCount[rollNo] ?? 0) + 1;
        }

        // =========================
        // BUILD REPORT
        // =========================
        List<Map<String, dynamic>>
        tempReport = [];

        for (var item
        in attendanceList) {

          String rollNo =
          item["roll_no"]
              .toString();

          bool alreadyExists =
          tempReport.any(
                (e) =>
            e["roll_no"] ==
                rollNo,
          );

          if (!alreadyExists) {

            int total =
                attendanceCount[rollNo] ?? 0;

            String status =
            total >= 10
                ? "Good"
                : total >= 5
                ? "Average"
                : "Low";

            tempReport.add({

              "roll_no":
              rollNo,

              "student_name":
              item["student_name"] ??
                  "",

              "course":
              item["course"] ?? "",

              "branch":
              item["branch"] ?? "",

              "attendance":
              total,

              "status":
              status,
            });
          }
        }

        setState(() {

          reportData = tempReport;

          isLoading = false;
        });
      }
    }

    catch (e) {

      debugPrint(
        "Report Error: $e",
      );

      setState(() {

        isLoading = false;
      });
    }
  }

  // =========================
  // EXPORT CSV
  // =========================
  Future<void> exportCSV() async {

    try {

      final response =
      await http.get(

        Uri.parse(
          '$baseUrl/report/export/csv',
        ),
      );

      if (response.statusCode == 200) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "CSV Export Successful",
            ),
          ),
        );
      }
    }

    catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // =========================
  // EXPORT PDF
  // =========================
  Future<void> exportPDF() async {

    try {

      final response =
      await http.get(

        Uri.parse(
          '$baseUrl/report/export/pdf',
        ),
      );

      if (response.statusCode == 200) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "PDF Export Successful",
            ),
          ),
        );
      }
    }

    catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Colors.grey.shade100,

      body: SafeArea(

        child: Row(

          children: [

            // =========================
            // SIDEBAR
            // =========================
            const Sidebar(),

            // =========================
            // MAIN CONTENT
            // =========================
            Expanded(

              child: Padding(

                padding:
                const EdgeInsets.all(20),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    // =========================
                    // TITLE
                    // =========================
                    const Text(

                      'Export Reports',

                      style: TextStyle(

                        fontSize: 32,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // =========================
                    // EXPORT CARDS
                    // =========================
                    LayoutBuilder(

                      builder:
                          (
                          context,
                          constraints,
                          ) {

                        if (constraints.maxWidth <
                            800) {

                          return Column(

                            children: [

                              ExportCard(

                                title:
                                'Export CSV',

                                icon:
                                Icons.table_chart,

                                onPressed:
                                exportCSV,
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              ExportCard(

                                title:
                                'Export PDF',

                                icon:
                                Icons.picture_as_pdf,

                                onPressed:
                                exportPDF,
                              ),
                            ],
                          );
                        }

                        return Row(

                          children: [

                            Expanded(

                              child:
                              ExportCard(

                                title:
                                'Export CSV',

                                icon:
                                Icons.table_chart,

                                onPressed:
                                exportCSV,
                              ),
                            ),

                            const SizedBox(
                              width: 20,
                            ),

                            Expanded(

                              child:
                              ExportCard(

                                title:
                                'Export PDF',

                                icon:
                                Icons.picture_as_pdf,

                                onPressed:
                                exportPDF,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // =========================
                    // REPORT TABLE
                    // =========================
                    Expanded(

                      child:
                      isLoading

                          ? const Center(

                        child:
                        CircularProgressIndicator(),
                      )

                          : ReportTable(

                        reportData:
                        reportData,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}