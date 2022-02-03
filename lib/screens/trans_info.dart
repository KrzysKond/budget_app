import 'package:budget_app/database/db.dart';
import 'package:budget_app/models/account.dart';
import 'package:budget_app/models/transactions.dart';
import 'package:flutter/material.dart';


class TransInfo extends StatefulWidget {
  const TransInfo({Key? key}) : super(key: key);

  @override
  _TransInfoState createState() => _TransInfoState();
}

class _TransInfoState extends State<TransInfo> {
  bool loading = false;
  late List<Account?> accounts;

  @override
  void initState() {
    refreshAccount();
    super.initState();
  }

  Future refreshAccount() async {
    setState(() => loading = true);

    accounts = await AccountsDatabase.instance.readAllAccounts();

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final transaction =
        ModalRoute.of(context)!.settings.arguments as Transactions;
    return loading == true
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              toolbarHeight: 80,
              leading: TextButton(
                child: Icon(
                  Icons.arrow_back,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              title: Text(
                'Transaction info',
                style: TextStyle(
                  fontSize: 26,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              actions: [
                TextButton(
                  child: const Icon(
                    Icons.delete,
                    size: 40,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text(
                              'Are you sure you want to delete the transaction',
                              style: TextStyle(
                                fontSize: 21,
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'No',
                                    style: TextStyle(fontSize: 18),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    await AccountsDatabase.instance
                                        .deleteTransaction(transaction.id!);
                                    await AccountsDatabase.instance
                                        .updateAccount(
                                      Account(
                                        lastLog: DateTime.now(),
                                        id: accounts[0]!.id,
                                        name: accounts[0]!.name,
                                        balance: accounts[0]!.balance -
                                            transaction.amount,
                                        description: accounts[0]!.description,
                                        currency: accounts[0]!.currency,
                                        currencySign: accounts[0]!.currencySign,
                                      ),
                                    );
                                    Navigator.of(context)
                                        .pushReplacementNamed('/home');
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(fontSize: 18),
                                  ))
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      transaction.name,
                      style: const TextStyle(
                        fontSize: 40,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const Text(
                        'Value:',
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          transaction.amount.toString() + accounts[0]!.currencySign,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Text(
                        'Date:',
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${transaction.time.month.toString()}/${transaction.time.day.toString()}/${transaction.time.year.toString()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    transaction.description,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          );
  }
}
