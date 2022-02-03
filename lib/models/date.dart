import 'package:flutter/cupertino.dart';
import 'package:currency_picker/currency_picker.dart';

class DateClass extends ChangeNotifier {
    DateTime? date;

  void changeDate(DateTime value) {
    date = value;
    notifyListeners();
  }
}
