import 'package:budget_app/database/db.dart';
import 'package:budget_app/models/account.dart';
import 'package:budget_app/models/transactions.dart';
import 'package:budget_app/screens/accounts.dart';
import 'package:budget_app/screens/stats.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Account?> accounts;

  bool isLoading = false;

  final globalKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

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
    List widgets = const [Balance(), Stats(), AccountScreen()];

    return isLoading == true
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            key: globalKey,
            backgroundColor: Theme.of(context).backgroundColor,
            drawer: Drawer(
              child: ListView(
                children: [
                  DrawerElement(
                      icon: Icon(Icons.add,
                          size: 60, color: Theme.of(context).primaryColor),
                      label: 'Add a transaction',
                      onPressed: () {
                        globalKey.currentState!.openEndDrawer();
                        Navigator.pushNamed(context, '/newTransaction');
                      }),
                  DrawerElement(
                      icon: Icon(Icons.add_box_outlined,
                          size: 60, color: Theme.of(context).primaryColor),
                      label: 'Add an account',
                      onPressed: () {
                        globalKey.currentState!.openEndDrawer();
                        Navigator.pushNamed(context, '/newAccount');
                      }),
                ],
              ),
            ),
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.menu,
                    color: Theme.of(context).primaryColor, size: 40),
                onPressed: () {
                  globalKey.currentState!.openDrawer();
                },
              ),
              title: Text(
                accounts.isEmpty == true
                    ? 'Create an account'
                    : accounts[0]!.name,
                style: TextStyle(
                  color: Colors.blueAccent[700],
                  fontSize: 24,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: accounts.isEmpty == true
                                ? const Center(
                                    child: Text(
                                      'Create an account',
                                      style: TextStyle(
                                        fontSize: 21,
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 300,
                                    width: 200,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: accounts.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            elevation: 15,
                                            child: ListTile(
                                              title: Center(
                                                child:
                                                    Text(accounts[index]!.name,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                        )),
                                              ),
                                              onTap: () async {
                                                await AccountsDatabase.instance
                                                    .updateAccount(
                                                  Account(
                                                    id: accounts[index]!.id,
                                                    lastLog: DateTime.now(),
                                                    name: accounts[index]!.name,
                                                    balance: accounts[index]!
                                                        .balance,
                                                    description:
                                                        accounts[index]!
                                                            .description,
                                                    currency: accounts[index]!
                                                        .currency,
                                                    currencySign:
                                                        accounts[index]!
                                                            .currencySign,
                                                  ),
                                                );
                                                Navigator.of(context).pushReplacementNamed('/home');
                                              },
                                            ),
                                          );
                                        }),
                                  ),
                          );
                        });
                  },
                  icon: Icon(
                    Icons.account_circle_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 40,
                  ),
                )
              ],
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.account_balance),
                  label: 'Turnovers',
                ),
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.stacked_line_chart),
                  label: 'Statistics',
                ),
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.person),
                  label: 'Accounts',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            body: widgets[_selectedIndex],
          );
  }
}

class Balance extends StatefulWidget {
  const Balance({
    Key? key,
  }) : super(key: key);

  @override
  State<Balance> createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  late List<Transactions?> transactions;
  late List<Account?> accounts;
  bool isLoading = false;
  @override
  void initState() {
    refreshAccount();
    super.initState();
  }

  Future refreshAccount() async {
    setState(() => isLoading = true);

    accounts = await AccountsDatabase.instance.readAllAccounts();
    transactions = await AccountsDatabase.instance
        .readAllTransactions(accounts.isNotEmpty ? accounts[0]!.id! : 0);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 20,
                  color: Theme.of(context).primaryColor,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            'Your Balance: ',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            accounts.isNotEmpty
                                ? accounts[0]!.balance.toString() +
                                    accounts[0]!.currencySign
                                : '0',
                            style: const TextStyle(
                                fontSize: 50, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    const Text(
                      'Transactions:',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          return Element(
                            tittle: transactions[index]!.name,
                            account: 'maks',
                            type: 'income',
                            amount: transactions[index]!.amount,
                            currencySign: accounts[0]!.currencySign,
                            onTap: () {
                              Navigator.pushNamed(context, '/transInfo',
                                  arguments: Transactions(
                                    id: transactions[index]!.id,
                                    name: transactions[index]!.name,
                                    amount: transactions[index]!.amount,
                                    description:
                                        transactions[index]!.description,
                                    time: transactions[index]!.time,
                                    foreignKey: transactions[index]!.foreignKey,
                                  ));
                            },
                          );
                        }),
                  ],
                ),
              ],
            ),
          );
  }
}

// ignore: must_be_immutable
class Element extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  // final description;
  final String account;
  final String type;
  final double amount;
  final String tittle;
  final String currencySign;
  final VoidCallback onTap;
  String? description;
  Element({
    Key? key,
    this.description,
    required this.tittle,
    required this.account,
    required this.type,
    required this.currencySign,
    required this.amount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.black)),
          elevation: 20,
          color: Colors.white,
          child: ListTile(
            title: Text(
              tittle,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            trailing: Text(
              amount.toString() + currencySign,
              style: TextStyle(
                fontSize: 30,
                color: amount >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerElement extends StatelessWidget {
  final String label;
  final Icon icon;
  final VoidCallback onPressed;
  const DrawerElement(
      {Key? key,
      required this.icon,
      required this.label,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
