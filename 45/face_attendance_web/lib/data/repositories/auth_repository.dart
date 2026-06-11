import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _service = AuthService();

  Future login({
    required String email,
    required String password,
  }) async {
    return await _service.login(
      email: email,
      password: password,
    );
  }

  Future signup({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _service.signup(
      name: name,
      email: email,
      password: password,
    );
  }
}