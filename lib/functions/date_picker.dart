import 'dart:io';

import 'package:budget_app/models/date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DatePick extends StatefulWidget {
  const DatePick({Key? key}) : super(key: key);
  @override
  _DatePickState createState() => _DatePickState();
}

class _DatePickState extends State<DatePick> {
  DateTime? date;
  TimeOfDay? time;
  String? getDate;
  String getText() {
    if (date == null) {
      return 'Select date';
    } else {
      return '${date!.month}/${date!.day}/${date!.year}';
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().month - 1),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    sleep(const Duration(milliseconds: 100));
    final newTime = await showTimePicker(
        context: context, initialTime: time ?? TimeOfDay.now());

    if (newDate == null && newTime == null) return;
    setState(() {
      date = newDate;
      time = newTime;
      getDate = date.toString();
      Provider.of<DateClass>(context, listen: false).changeDate(DateTime(date!.year, date!.month, date!.day, time!.hour, time!.minute));
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        pickDate(context);
      },
      child: SizedBox(
        height: 50,
        width: 150,
        child: Center(
          child: Text(
            getText(),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
