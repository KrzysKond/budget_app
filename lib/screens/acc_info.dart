import 'package:budget_app/database/db.dart';
import 'package:budget_app/models/account.dart';
import 'package:flutter/material.dart';

class AccInfo extends StatefulWidget {
  const AccInfo({Key? key}) : super(key: key);

  @override
  State<AccInfo> createState() => _AccInfoState();
}

class _AccInfoState extends State<AccInfo> {
  @override
  Widget build(BuildContext context) {
    final acc = ModalRoute.of(context)!.settings.arguments as Account;
    return Scaffold(
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
          'Account info',
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
                        'Are you sure you want to delete the account?',
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
                              Navigator.of(context).pushNamed('/home');
                              await AccountsDatabase.instance
                                  .deleteTransactions(acc.id!);
                              await AccountsDatabase.instance
                                  .deleteAccount(acc.id!);
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
                "${acc.name}'s account",
                style: const TextStyle(
                  fontSize: 40,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            Text(
              'Balance:      ${acc.balance}${acc.currencySign}',
              style: const TextStyle(
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Currency:  ' + acc.currency,
              style: const TextStyle(
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              acc.description!,
              style: const  TextStyle(
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
