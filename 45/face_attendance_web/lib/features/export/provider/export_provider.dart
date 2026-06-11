import 'package:flutter/material.dart';

class ExportProvider extends ChangeNotifier {
  bool exportingCsv = false;

  bool exportingPdf = false;

  Future exportCsv() async {
    exportingCsv = true;
    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 2),
    );

    exportingCsv = false;
    notifyListeners();
  }

  Future exportPdf() async {
    exportingPdf = true;
    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 2),
    );

    exportingPdf = false;
    notifyListeners();
  }
}