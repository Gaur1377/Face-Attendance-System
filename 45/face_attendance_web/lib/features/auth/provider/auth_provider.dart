import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool isLoading = false;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _repository.login(
        email: email,
        password: password,
      );

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _repository.signup(
        name: name,
        email: email,
        password: password,
      );

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();

      return false;
    }
  }
}