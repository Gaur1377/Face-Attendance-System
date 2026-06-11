import 'package:dio/dio.dart';
import 'dio_client.dart';

class ApiService {
  Future<Response> get(String endpoint) async {
    return await DioClient.dio.get(endpoint);
  }

  Future<Response> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    return await DioClient.dio.post(
      endpoint,
      data: data,
    );
  }

  Future<Response> postFormData(
    String endpoint,
    FormData data,
  ) async {
    return await DioClient.dio.post(
      endpoint,
      data: data,
    );
  }
}