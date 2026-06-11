import 'package:flutter/material.dart';

import 'package:face_attendance_web/features/auth/screens/login_screen.dart';
import 'package:face_attendance_web/features/auth/screens/signup_screen.dart';
import 'package:face_attendance_web/features/dashboard/screens/dashboard_screen.dart';
import 'package:face_attendance_web/features/register_face/screens/register_face_screen.dart';
import 'package:face_attendance_web/features/attendance/screens/mark_attendance_screen_new.dart';
import 'package:face_attendance_web/features/records/screens/attendance_records_screen.dart';
import 'package:face_attendance_web/features/export/screens/export_screen.dart';

class AppRoutes {
  static const String login = '/login';

  static const String signup = '/signup';

  static const String dashboard = '/dashboard';

  static const String registerFace =
      '/register-face';

  static const String attendance =
      '/attendance';

  static const String records = '/records';

  static const String export = '/export';

  static Map<String, WidgetBuilder> routes =
      {
    login: (context) =>
        const LoginScreen(),

    signup: (context) =>
        const SignupScreen(),

    dashboard: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return DashboardScreen(userId: args?['userId']);
    },

    registerFace: (context) =>
        const RegisterFaceScreen(),

    attendance: (context) =>
        const MarkAttendanceScreen(cameras: [],),

    records: (context) =>
        const AttendanceRecordsScreen(),

    export: (context) =>
        const ExportScreen(),
  };
}