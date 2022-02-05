import 'package:flutter/cupertino.dart';

class DateClass extends ChangeNotifier {
    DateTime? date;

  void changeDate(DateTime value) {
    date = value;
    notifyListeners();
  }
}
