import 'dart:ui';
import 'package:budget_app/database/db.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/models/account.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late List<Account?> accounts;

  bool isLoading = false;
  @override
  void dispose() {
    AccountsDatabase.instance.close;
    super.dispose();
  }

  @override
  void initState() {
    refreshAccount();

    super.initState();
  }

  Future refreshAccount() async {
    setState(() => isLoading = true);

    accounts = await AccountsDatabase.instance.readAllAccounts();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
              child: accounts.isEmpty == true
                  ? const Text(
                      'You have not created any accounts, go to menu to create one',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    )
                  : Column(
                      children: [
                        const Center(
                          child: Text(
                            'Your accounts',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: accounts.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/accInfo', arguments: accounts[index]);
                              },
                              child: SizedBox(
                                height: 150,
                                child: Card(
                                  color: Colors.grey[200],
                                  elevation: 10,
                                  child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                    Text(
                                      accounts[index]!.name,
                                      style: const TextStyle(
                                        fontSize: 28,
                                      ),
                                    ),
                                    Text(
                                      accounts[index]!.balance.toString() + accounts[index]!.currencySign,
                                      style: const TextStyle(
                                        fontSize: 28,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ),
          );
  }
}
