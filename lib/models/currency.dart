import 'package:flutter/cupertino.dart';
import 'package:currency_picker/currency_picker.dart';

class CurrencyClass extends ChangeNotifier {
    Currency? currency;

  void changeCurrency(Currency value) {
    currency = value;
    notifyListeners();
  }
}
