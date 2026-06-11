import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MarkAttendanceScreen extends StatefulWidget {

  const MarkAttendanceScreen({
    super.key,
    required List<dynamic> cameras,
  });

  @override
  State<MarkAttendanceScreen> createState() =>
      _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState
    extends State<MarkAttendanceScreen> {

  // =========================
  // BACKEND URL
  // =========================
  final String baseUrl =

  kIsWeb

      ? 'http://localhost:8000'

      : 'http://10.0.2.2:8000';

  // =========================
  // CONTROLLERS
  // =========================
  final TextEditingController
  rollNoController =
  TextEditingController();

  CameraController? controller;

  // =========================
  // STATES
  // =========================
  bool isCameraReady = false;

  bool isLoading = false;

  bool cameraError = false;

  String cameraMessage = '';

  // =========================
  // DASHBOARD
  // =========================
  int totalStudents = 0;

  int presentToday = 0;

  int absentToday = 0;

  // =========================
  // LOGS
  // =========================
  List<Map<String, dynamic>>
  attendanceLogs = [];

  @override
  void initState() {

    super.initState();

    initializeCamera();

    loadDashboard();
  }

  // =========================
  // INITIALIZE CAMERA
  // =========================
  Future<void> initializeCamera() async {

    try {

      final cameras =
      await availableCameras();

      if (cameras.isEmpty) {

        setState(() {

          cameraError = true;

          cameraMessage =
          "No Camera Found";
        });

        return;
      }

      controller = CameraController(

        cameras.first,

        ResolutionPreset.medium,

        enableAudio: false,
      );

      await controller!.initialize();

      if (!mounted) return;

      setState(() {

        isCameraReady = true;

        cameraError = false;
      });
    }

    catch (e) {

      debugPrint(
        "Camera Error: $e",
      );

      if (!mounted) return;

      setState(() {

        cameraError = true;

        cameraMessage =
        e.toString();
      });
    }
  }

  // =========================
  // LOAD DASHBOARD
  // =========================
  Future<void> loadDashboard() async {

    try {

      // =========================
      // STUDENTS
      // =========================
      final studentResponse =
      await http.get(

        Uri.parse(
          '$baseUrl/student/all',
        ),
      );

      if (studentResponse.statusCode ==
          200) {

        final studentData =
        jsonDecode(
          studentResponse.body,
        );

        if (studentData is Map &&
            studentData["students"] !=
                null) {

          totalStudents =
              studentData["students"]
                  .length;
        }

        else if (studentData is List) {

          totalStudents =
              studentData.length;
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

      if (attendanceResponse.statusCode ==
          200) {

        final attendanceData =
        jsonDecode(
          attendanceResponse.body,
        );

        List<dynamic> attendance =
        [];

        if (attendanceData is Map &&
            attendanceData["attendance"] !=
                null) {

          attendance =
          attendanceData["attendance"];
        }

        else if (attendanceData is List) {

          attendance =
              attendanceData;
        }

        presentToday =
            attendance.length;

        attendanceLogs =
            attendance.map<Map<String, dynamic>>(

                  (item) {

                return {

                  "student_name":
                  item["student_name"] ??
                      "Unknown",

                  "roll_no":
                  item["roll_no"] ?? "",

                  "timestamp":
                  item["timestamp"] ?? "",

                  "status":
                  item["status"] ??
                      "Present",
                };
              },
            ).toList();

        absentToday =
            totalStudents -
                presentToday;

        if (absentToday < 0) {

          absentToday = 0;
        }
      }

      if (mounted) {

        setState(() {});
      }
    }

    catch (e) {

      debugPrint(
        "Dashboard Error: $e",
      );
    }
  }

  // =========================
  // MARK ATTENDANCE
  // =========================
  Future<void> captureAttendance() async {

    // =========================
    // VALIDATION
    // =========================
    if (rollNoController.text
        .trim()
        .isEmpty) {

      showMessage(
        "Enter Roll Number",
      );

      return;
    }

    // =========================
    // CAMERA CHECK
    // =========================
    if (controller == null ||
        !controller!
            .value
            .isInitialized) {

      showMessage(
        "Camera Not Ready",
      );

      return;
    }

    setState(() {

      isLoading = true;
    });

    try {

      // =========================
      // WAIT FOR FRESH FRAME
      // =========================
      await Future.delayed(

        const Duration(
          milliseconds: 500,
        ),
      );

      // =========================
      // TAKE PICTURE
      // =========================
      final XFile image =
      await controller!
          .takePicture();

      // =========================
      // IMAGE BYTES
      // =========================
      final bytes =
      await image.readAsBytes();

      // =========================
      // EMPTY CHECK
      // =========================
      if (bytes.isEmpty) {

        showMessage(
          "Failed To Capture Image",
        );

        setState(() {

          isLoading = false;
        });

        return;
      }

      // =========================
      // REQUEST
      // =========================
      var request =
      http.MultipartRequest(

        "POST",

        Uri.parse(
          "$baseUrl/attendance/mark",
        ),
      );

      // =========================
      // ROLL NO
      // =========================
      request.fields["roll_no"] =
          rollNoController.text.trim();

      // =========================
      // IMAGE
      // =========================
      request.files.add(

        http.MultipartFile.fromBytes(

          "file",

          bytes,

          filename:
          "attendance_${DateTime.now().millisecondsSinceEpoch}.jpg",
        ),
      );

      // =========================
      // SEND
      // =========================
      final response =
      await request.send();

      final responseBody =
      await response.stream
          .bytesToString();

      debugPrint(responseBody);

      final data =
      jsonDecode(responseBody);

      // =========================
      // SUCCESS
      // =========================
      if (response.statusCode == 200 &&
          data["success"] == true) {

        setState(() {

          attendanceLogs.insert(0, {

            "student_name":
            data["student_name"] ?? "",

            "roll_no":
            data["roll_no"] ?? "",

            "timestamp":
            data["timestamp"] ?? "",

            "status":
            "Present",
          });

          presentToday++;

          absentToday =
              totalStudents -
                  presentToday;

          if (absentToday < 0) {

            absentToday = 0;
          }
        });

        rollNoController.clear();

        showMessage(

          data["message"] ??
              "Attendance Marked",
        );
      }

      // =========================
      // FAILED
      // =========================
      else {

        showMessage(

          data["detail"] ??
              data["message"] ??
              "Face Not Matched",
        );
      }
    }

    catch (e) {

      debugPrint(
        "Attendance Error: $e",
      );

      showMessage(
        "Attendance Failed",
      );
    }

    if (mounted) {

      setState(() {

        isLoading = false;
      });
    }
  }

  // =========================
  // MESSAGE
  // =========================
  void showMessage(
      String message,
      ) {

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content: Text(
          message,
        ),
      ),
    );
  }

  @override
  void dispose() {

    controller?.dispose();

    rollNoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Colors.grey.shade100,

      body: SafeArea(

        child: SingleChildScrollView(

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

                "Face Attendance System",

                style: TextStyle(

                  fontSize: 30,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // =========================
              // CARDS
              // =========================
              Wrap(

                spacing: 20,

                runSpacing: 20,

                children: [

                  buildCard(
                    "Total Students",
                    totalStudents.toString(),
                  ),

                  buildCard(
                    "Present",
                    presentToday.toString(),
                  ),

                  buildCard(
                    "Absent",
                    absentToday.toString(),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              LayoutBuilder(

                builder:
                    (
                    context,
                    constraints,
                    ) {

                  // =========================
                  // MOBILE
                  // =========================
                  if (constraints.maxWidth <
                      900) {

                    return Column(

                      children: [

                        buildCameraSection(),

                        const SizedBox(
                          height: 20,
                        ),

                        buildLogsSection(),
                      ],
                    );
                  }

                  // =========================
                  // DESKTOP
                  // =========================
                  return Row(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Expanded(

                        flex: 2,

                        child:
                        buildCameraSection(),
                      ),

                      const SizedBox(
                        width: 20,
                      ),

                      Expanded(

                        child:
                        buildLogsSection(),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // CARD
  // =========================
  Widget buildCard(
      String title,
      String value,
      ) {

    return Container(

      width: 220,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Column(

        children: [

          Text(

            title,

            style: const TextStyle(
              fontSize: 18,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Text(

            value,

            style: const TextStyle(

              fontSize: 28,

              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // CAMERA SECTION
  // =========================
  Widget buildCameraSection() {

    return Container(

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Column(

        children: [

          TextField(

            controller:
            rollNoController,

            decoration:
            const InputDecoration(

              labelText:
              "Enter Roll Number",

              border:
              OutlineInputBorder(),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          SizedBox(

            height: 400,

            width: double.infinity,

            child: ClipRRect(

              borderRadius:
              BorderRadius.circular(
                16,
              ),

              child:
              isCameraReady

                  ? CameraPreview(
                controller!,
              )

                  : Container(

                color:
                Colors.grey.shade200,

                child: Center(

                  child: Column(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      Icon(

                        cameraError
                            ? Icons.videocam_off
                            : Icons.camera_alt,

                        size: 80,

                        color:
                        Colors.red,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Text(

                        cameraError
                            ? "Camera Not Available"
                            : "Loading Camera",

                        style:
                        const TextStyle(

                          fontSize: 18,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        cameraMessage,
                        textAlign:
                        TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          SizedBox(

            width: double.infinity,

            height: 55,

            child: ElevatedButton(

              onPressed:
              isLoading
                  ? null
                  : captureAttendance,

              child:
              isLoading

                  ? const SizedBox(

                width: 25,

                height: 25,

                child:
                CircularProgressIndicator(),
              )

                  : const Text(

                "Capture Attendance",

                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // LOGS SECTION
  // =========================
  Widget buildLogsSection() {

    return Container(

      height: 650,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          const Text(

            "Attendance Logs",

            style: TextStyle(

              fontSize: 24,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Expanded(

            child:
            attendanceLogs.isEmpty

                ? const Center(

              child: Text(
                "No Attendance Yet",
              ),
            )

                : ListView.builder(

              itemCount:
              attendanceLogs.length,

              itemBuilder:
                  (context, index) {

                final log =
                attendanceLogs[index];

                return Card(

                  child: ListTile(

                    leading:
                    const Icon(
                      Icons.person,
                    ),

                    title: Text(

                      log["student_name"]
                          ?.toString() ??
                          "",
                    ),

                    subtitle: Text(

                      "Roll No: ${log["roll_no"]?.toString() ?? ""}",
                    ),

                    trailing: SizedBox(

                      width: 120,

                      child: Text(

                        log["timestamp"]
                            ?.toString() ??
                            "",

                        overflow:
                        TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}