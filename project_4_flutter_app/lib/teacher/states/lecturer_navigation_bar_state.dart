import 'package:flutter/material.dart';

class LecturerNavigationBarState extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setIndex(int index) {
    if (_index != index) {
      _index = index;
      notifyListeners();
    }
  }
}
