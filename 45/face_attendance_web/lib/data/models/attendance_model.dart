class AttendanceModel {
  final String studentName;
  final String time;
  final String status;

  AttendanceModel({
    required this.studentName,
    required this.time,
    required this.status,
  });

  factory AttendanceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceModel(
      studentName: json['student_name'],
      time: json['time'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_name': studentName,
      'time': time,
      'status': status,
    };
  }
}