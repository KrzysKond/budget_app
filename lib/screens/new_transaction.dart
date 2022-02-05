import 'package:budget_app/database/db.dart';
import 'package:budget_app/functions/date_picker.dart';
import 'package:budget_app/models/account.dart';
import 'package:budget_app/models/date.dart';
import 'package:budget_app/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewTransaction extends StatefulWidget {
  const NewTransaction({Key? key}) : super(key: key);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  late List<Account?> accounts;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? selectedAccount;
  int? key;
  String? description;
  List<String> accountNames = [];

  String? type;
  double? amount;
  @override
  void initState() {
    refreshAccount();

    super.initState();
  }

  Future refreshAccount() async {
    setState(() => isLoading = true);

    accounts = await AccountsDatabase.instance.readAllAccounts();
    for (int i = 0; i < accounts.length - 1; i++) {
      accountNames.add(accounts[i]!.name);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
            'New Transaction',
            style: TextStyle(
              fontSize: 26,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: Theme.of(context).primaryTextTheme.bodyText1,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Value:',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).primaryTextTheme.bodyText1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(','))
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          setState(() {
                            amount = double.parse(value.toString());
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        "Remember about '-' sign if it is an expenditure",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    const SizedBox(height: 40),
                    Text(
                      'Select account',
                      style: Theme.of(context).primaryTextTheme.bodyText1,
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
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
                                                      child: Text(
                                                          accounts[index]!.name,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                          )),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        selectedAccount =
                                                            accounts[index]!
                                                                .name;
                                                        key=index;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                );
                                              }),
                                        ),
                                );
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: SizedBox(
                            height: 50,
                            width: 200,
                            child: Center(
                              child: Text(
                                selectedAccount != null
                                    ? selectedAccount!
                                    : 'Select an account',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Select date',
                      style: Theme.of(context).primaryTextTheme.bodyText1,
                    ),
                    const SizedBox(height: 20),
                    const Center(child: DatePick()),
                    const SizedBox(height: 20),
                    Text(
                      'Description',
                      style: Theme.of(context).primaryTextTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Description",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.indigoAccent[700]!),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ))),
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              Provider.of<DateClass>(context, listen: false )
                                      .date !=
                                  null && key!=null) {
                            _formKey.currentState!.save();

                            final transaction = Transactions(
                                name: name!,
                                amount: amount!,
                                description: description!,
                                foreignKey: accounts[key!]!.id,
                                time: Provider.of<DateClass>(context,
                                        listen: false)
                                    .date!);
                            await AccountsDatabase.instance
                                .createATransaction(transaction);
                            await AccountsDatabase.instance.updateAccount(
                              Account(
                                id: accounts[key!]!.id,
                                lastLog: DateTime.now(),
                                name: accounts[key!]!.name,
                                balance: accounts[key!]!.balance + amount!,
                                description: accounts[key!]!.description,
                                currency: accounts[key!]!.currency,
                                currencySign: accounts[key!]!.currencySign,
                              ),
                            );

                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                        child: const SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 23,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
