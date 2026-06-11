import 'package:flutter/material.dart';

class RecordsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> records = [
    {
      'name': 'Arjun Kumar',
      'date': '10 May 2026',
      'status': 'Present',
      'percentage': '92%',
    },
    {
      'name': 'Sneha Nair',
      'date': '10 May 2026',
      'status': 'Late',
      'percentage': '88%',
    },
  ];

  String selectedFilter = 'All';

  void changeFilter(String value) {
    selectedFilter = value;
    notifyListeners();
  }
}