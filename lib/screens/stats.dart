import 'package:budget_app/database/db.dart';
import 'package:budget_app/models/account.dart';
import 'package:budget_app/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  bool isLoading = false;
  late List<Account?> accounts;
  late List<Transactions?> transactions;
  double bufor = 0;
  double first = 0;
  List<double> amounts = [];

  Future refresh() async {
    setState(() => isLoading = true);

    accounts = await AccountsDatabase.instance.readAllAccounts();
    transactions = await AccountsDatabase.instance
        .readAllTransactions(accounts.isNotEmpty ? accounts[0]!.id! : 0);
    if (transactions.isNotEmpty) {
    for (int i = transactions.length; i >= 0; i--) {
      if (i == 0) {
        amounts.add(accounts[0]!.balance);
      } else if (i == transactions.length) {
        first = accounts[0]!.balance;
        for (int i = 0; i < transactions.length; i++) {
          first = first - transactions[i]!.amount;
        }
        amounts.add(first);
      } else {
        bufor += transactions[i]!.amount;
        amounts.add(bufor);
      }
    }
    setState(() => isLoading = false);
  }
  }
  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  child: Center(
                    child: Text('Statistics of your balance in time',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                        )),
                  ),
                ),
                const SizedBox(height: 30),
                SfSparkLineChart(
                    trackball: const SparkChartTrackball(
                        activationMode: SparkChartActivationMode.tap),
                    marker: const SparkChartMarker(
                        displayMode: SparkChartMarkerDisplayMode.all),
                    labelDisplayMode: SparkChartLabelDisplayMode.all,
                    data: amounts),
              ],
            ),
          ));
  }
}
