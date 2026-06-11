import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecentLogTable extends StatefulWidget {
  final List<Map<String, dynamic>> logs;

  const RecentLogTable({
    super.key,
    required this.logs,
  });

  @override
  State<RecentLogTable> createState() =>
      _RecentLogTableState();
}

class _RecentLogTableState
    extends State<RecentLogTable> {

  // =========================
  // LOGS
  // =========================
  List<Map<String, dynamic>>
  attendanceLogs = [];

  bool isLoading = true;

  // =========================
  // BACKEND URL
  // =========================
  final String baseUrl =
      'http://127.0.0.1:8000';

  @override
  void initState() {

    super.initState();

    // =========================
    // USE PASSED LOGS FIRST
    // =========================
    if (widget.logs.isNotEmpty) {

      attendanceLogs =
          List<Map<String, dynamic>>
              .from(widget.logs);

      isLoading = false;
    }

    else {

      fetchAttendanceLogs();
    }
  }

  // =========================
  // FETCH LOGS FROM BACKEND
  // =========================
  Future<void> fetchAttendanceLogs() async {

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

        List<dynamic> logs = [];

        // =========================
        // HANDLE MAP RESPONSE
        // =========================
        if (data is Map) {

          if (data["attendance"] != null &&
              data["attendance"] is List) {

            logs = data["attendance"];
          }

          else if (data["data"] != null &&
              data["data"] is List) {

            logs = data["data"];
          }
        }

        // =========================
        // HANDLE LIST RESPONSE
        // =========================
        else if (data is List) {

          logs = data;
        }

        // =========================
        // SAFE CONVERSION
        // =========================
        attendanceLogs =
            logs.map<Map<String, dynamic>>(

                  (item) {

                return {

                  "student_name":
                  item["student_name"]
                      ?.toString() ??
                      "Unknown",

                  "roll_no":
                  item["roll_no"]
                      ?.toString() ??
                      "",

                  "status":
                  item["status"]
                      ?.toString() ??
                      "Present",

                  "timestamp":
                  item["timestamp"]
                      ?.toString() ??
                      "",

                  "time":
                  item["time"]
                      ?.toString() ??
                      item["timestamp"]
                          ?.toString() ??
                      "",
                };
              },
            ).toList();

        if (mounted) {

          setState(() {

            isLoading = false;
          });
        }
      }

      else {

        if (mounted) {

          setState(() {

            isLoading = false;
          });
        }
      }
    }

    catch (e) {

      debugPrint(
        "RecentLog Error: $e",
      );

      if (mounted) {

        setState(() {

          isLoading = false;
        });
      }
    }
  }

  // =========================
  // STATUS COLOR
  // =========================
  Color getStatusColor(
      String status,
      ) {

    switch (
    status.toLowerCase()
    ) {

      case "present":
        return Colors.green;

      case "late":
        return Colors.orange;

      case "absent":
        return Colors.red;

      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),

        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withOpacity(
              0.05,
            ),

            blurRadius: 10,

            offset:
            const Offset(0, 4),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          // =========================
          // TITLE
          // =========================
          const Text(

            'Recent Attendance Logs',

            style: TextStyle(

              fontSize: 24,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // =========================
          // LOADING
          // =========================
          if (isLoading)

            const Center(

              child:
              CircularProgressIndicator(),
            )

          // =========================
          // EMPTY
          // =========================
          else if (attendanceLogs.isEmpty)

            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(40),

              alignment:
              Alignment.center,

              child: const Text(

                "No Attendance Found",

                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )

          // =========================
          // TABLE
          // =========================
          else

            SizedBox(

              width: double.infinity,

              child:
              SingleChildScrollView(

                scrollDirection:
                Axis.horizontal,

                child: DataTable(

                  columnSpacing: 30,

                  headingRowColor:
                  WidgetStateProperty.all(
                    Colors.grey.shade200,
                  ),

                  columns: const [

                    DataColumn(
                      label:
                      Text("Roll No"),
                    ),

                    DataColumn(
                      label:
                      Text("Student"),
                    ),

                    DataColumn(
                      label:
                      Text("Status"),
                    ),

                    DataColumn(
                      label:
                      Text("Time"),
                    ),
                  ],

                  rows:
                  attendanceLogs.map(

                        (log) {

                      final status =
                          log["status"]
                              .toString();

                      return DataRow(

                        cells: [

                          DataCell(

                            Text(
                              log["roll_no"]
                                  .toString(),
                            ),
                          ),

                          DataCell(

                            Text(
                              log["student_name"]
                                  .toString(),
                            ),
                          ),

                          DataCell(

                            Container(

                              padding:
                              const EdgeInsets.symmetric(

                                horizontal:
                                12,

                                vertical:
                                6,
                              ),

                              decoration:
                              BoxDecoration(

                                color:
                                getStatusColor(
                                  status,
                                ).withOpacity(
                                  0.15,
                                ),

                                borderRadius:
                                BorderRadius.circular(
                                  20,
                                ),
                              ),

                              child: Text(

                                status,

                                style: TextStyle(

                                  color:
                                  getStatusColor(
                                    status,
                                  ),

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          DataCell(

                            Text(
                              log["time"]
                                  .toString(),
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}