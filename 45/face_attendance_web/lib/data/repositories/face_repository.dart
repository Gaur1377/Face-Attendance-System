import 'package:dio/dio.dart';

import '../services/face_service.dart';

class FaceRepository {
  final FaceService _service = FaceService();

  Future register(FormData data) async {
    return await _service.registerFace(data);
  }

  Future mark(FormData data) async {
    return await _service.markAttendance(data);
  }
}