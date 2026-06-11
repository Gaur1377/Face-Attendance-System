import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';

import 'features/auth/provider/auth_provider.dart';
import 'features/dashboard/provider/dashboard_provider.dart';
import 'features/register_face/provider/register_face_provider.dart';
import 'features/attendance/provider/attendance_provider.dart';
import 'features/records/provider/records_provider.dart';
import 'features/export/provider/export_provider.dart';

import 'features/auth/screens/splash_screen.dart';

import 'routes/app_routes.dart';

// =========================
// GLOBAL CAMERA LIST
// =========================
List<CameraDescription> globalCameras = [];

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // =========================
  // CAMERA INIT
  // =========================
  if (!kIsWeb) {

    try {

      globalCameras =
      await availableCameras();

      debugPrint(
        "✓ Cameras Found: ${globalCameras.length}",
      );
    }

    catch (e) {

      debugPrint(
        "Camera Error: $e",
      );
    }
  }

  // =========================
  // WEB CAMERA
  // =========================
  else {

    try {

      globalCameras =
      await availableCameras();

      debugPrint(
        "✓ Web Cameras Found: ${globalCameras.length}",
      );
    }

    catch (e) {

      debugPrint(
        """
WEB CAMERA ERROR

Possible reasons:
1. Browser permission denied
2. Camera already in use
3. Browser does not support camera
4. HTTP instead of HTTPS
5. Unsupported Flutter web renderer

Error:
$e
""",
      );
    }
  }

  // =========================
  // RUN APP
  // =========================
  runApp(
    const FaceAttendanceApp(),
  );
}

class FaceAttendanceApp
    extends StatelessWidget {

  const FaceAttendanceApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [

        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => DashboardProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => RegisterFaceProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => AttendanceProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => RecordsProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => ExportProvider(),
        ),
      ],

      child: MaterialApp(

        debugShowCheckedModeBanner:
        false,

        title: 'Face Attendance',

        theme: AppTheme.lightTheme,

        // =========================
        // IMPORTANT
        // =========================
        builder: (context, child) {

          return MediaQuery(

            data: MediaQuery.of(context).copyWith(

              textScaler:
              const TextScaler.linear(1.0),
            ),

            child: child!,
          );
        },

        // =========================
        // ROUTES
        // =========================
        routes:
        AppRoutes.routes,

        // =========================
        // HOME
        // =========================
        home: const SplashScreen(),
      ),
    );
  }
}