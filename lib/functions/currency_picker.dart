import 'package:budget_app/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:provider/provider.dart';

class CurrencyPicker extends StatefulWidget {
  const CurrencyPicker({Key? key}) : super(key: key);
  @override
  _CurrencyPickerState createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends State<CurrencyPicker> {
  String? currentCurrency;
  String? currentCurrencyTag;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        side: MaterialStateProperty.all(
          BorderSide(width: 3, color: Colors.indigoAccent[700]!),
        ),
      ),
      onPressed: () {
        showCurrencyPicker(
          context: context,
          showFlag: true,
          showCurrencyName: true,
          showCurrencyCode: true,
          favorite: ['PLN'],
          onSelect: (Currency currency) {
            setState(() {
              currentCurrencyTag = currency.symbol;
              currentCurrency = currency.name;
              Provider.of<CurrencyClass>(context, listen: false).changeCurrency(currency);
            });
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: SizedBox(
          height: 60,
          width: 200,
          child: Center(
            child: Text(
              currentCurrency != null ? currentCurrency! : 'Select Currency',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
