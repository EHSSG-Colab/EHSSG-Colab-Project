import 'package:flutter/material.dart';

class MalariaProvider extends ChangeNotifier {
  // Initiate empty list of malaria cases
  List<Malaria> cases = [];

  // Initiate
  MalariaProvider() {
    init();
  }

  Future<void> init() async {
    await fetchCases();
  }

  Future<void> fetchCases() async {
    final List<Map<String, dynamic>> localMalariaCases =
        await DatabaseHelper().getAllMalaria();
  }
}
