import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../shared/widgets/sidebar.dart';

import '../widgets/filter_bar.dart';
import '../widgets/records_table.dart';

class AttendanceRecordsScreen
    extends StatefulWidget {

  const AttendanceRecordsScreen({
    super.key,
  });

  @override
  State<AttendanceRecordsScreen>
  createState() =>
      _AttendanceRecordsScreenState();
}

class _AttendanceRecordsScreenState
    extends State<AttendanceRecordsScreen> {

  final String baseUrl =
      'http://127.0.0.1:8000';

  List<Map<String, dynamic>>
  records = [];

  List<Map<String, dynamic>>
  filteredRecords = [];

  bool isLoading = true;

  final TextEditingController
  searchController =
  TextEditingController();

  String selectedCourse = "All";

  String selectedBranch = "All";

  @override
  void initState() {

    super.initState();

    loadRecords();
  }

  // =========================
  // LOAD RECORDS
  // =========================
  Future<void> loadRecords() async {

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

        if (data is Map &&
            data["attendance"] != null) {

          records =
              List<Map<String, dynamic>>
                  .from(
                data["attendance"],
              );
        }

        else if (data is List) {

          records =
              List<Map<String, dynamic>>
                  .from(data);
        }

        filteredRecords =
            List.from(records);
      }
    }

    catch (e) {

      debugPrint(
        "Records Error: $e",
      );
    }

    setState(() {

      isLoading = false;
    });
  }

  // =========================
  // FILTER RECORDS
  // =========================
  void filterRecords() {

    final query =
    searchController.text
        .toLowerCase();

    setState(() {

      filteredRecords =
          records.where((record) {

            final name =
            record["student_name"]
                .toString()
                .toLowerCase();

            final rollNo =
            record["roll_no"]
                .toString()
                .toLowerCase();

            final course =
            record["course"]
                .toString();

            final branch =
            record["branch"]
                .toString();

            final matchesSearch =
                name.contains(query) ||
                    rollNo.contains(query);

            final matchesCourse =
                selectedCourse == "All" ||
                    course ==
                        selectedCourse;

            final matchesBranch =
                selectedBranch == "All" ||
                    branch ==
                        selectedBranch;

            return matchesSearch &&
                matchesCourse &&
                matchesBranch;
          }).toList();
    });
  }

  // =========================
  // COURSES
  // =========================
  List<String> getCourses() {

    final courses =
    records
        .map(
          (e) =>
          e["course"]
              .toString(),
        )
        .toSet()
        .toList();

    courses.sort();

    return [
      "All",
      ...courses,
    ];
  }

  // =========================
  // BRANCHES
  // =========================
  List<String> getBranches() {

    final branches =
    records
        .map(
          (e) =>
          e["branch"]
              .toString(),
        )
        .toSet()
        .toList();

    branches.sort();

    return [
      "All",
      ...branches,
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Colors.grey.shade100,

      body: SafeArea(

        child: Row(

          children: [

            const Sidebar(),

            Expanded(

              child: Padding(

                padding:
                const EdgeInsets.all(20),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Text(

                      'Attendance Records',

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
                    // FILTER BAR
                    // =========================
                    FilterBar(

                      searchController:
                      searchController,

                      selectedCourse:
                      selectedCourse,

                      selectedBranch:
                      selectedBranch,

                      courses:
                      getCourses(),

                      branches:
                      getBranches(),

                      onSearch: (value) {

                        filterRecords();
                      },

                      onCourseChanged:
                          (value) {

                        selectedCourse =
                        value!;

                        filterRecords();
                      },

                      onBranchChanged:
                          (value) {

                        selectedBranch =
                        value!;

                        filterRecords();
                      },

                      onRefresh: () {

                        setState(() {

                          isLoading = true;
                        });

                        loadRecords();
                      },
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // =========================
                    // TABLE
                    // =========================
                    Expanded(

                      child:
                      isLoading

                          ? const Center(

                        child:
                        CircularProgressIndicator(),
                      )

                          : RecordsTable(

                        records:
                        filteredRecords,
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