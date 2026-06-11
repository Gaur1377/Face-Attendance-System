import '../../core/constants/api_constants.dart';
import '../../core/network/api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future login({
    required String email,
    required String password,
  }) async {
    return await _api.post(
      ApiConstants.login,
      {
        'email': email,
        'password': password,
      },
    );
  }

  Future signup({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _api.post(
      ApiConstants.signup,
      {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }
}