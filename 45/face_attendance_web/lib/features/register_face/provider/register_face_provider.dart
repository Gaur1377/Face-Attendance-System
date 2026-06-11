import 'package:flutter/material.dart';

class RegisterFaceProvider extends ChangeNotifier {
  bool isCapturing = false;

  void startCapture() {
    isCapturing = true;
    notifyListeners();
  }

  void stopCapture() {
    isCapturing = false;
    notifyListeners();
  }
}