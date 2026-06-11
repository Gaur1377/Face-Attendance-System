import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_service.dart';

class FaceService {
  final ApiService _api = ApiService();

  Future registerFace(FormData data) async {
    return await _api.postFormData(
      ApiConstants.registerFace,
      data,
    );
  }

  Future markAttendance(FormData data) async {
    return await _api.postFormData(
      ApiConstants.markAttendance,
      data,
    );
  }
}