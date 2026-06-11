import 'package:camera/camera.dart';

class CameraHelper {
  static Future<List<CameraDescription>> getCameras() async {
    return await availableCameras();
  }
}