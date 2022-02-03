import 'package:budget_app/database/db.dart';
import 'package:budget_app/functions/currency_picker.dart';
import 'package:budget_app/models/account.dart';
import 'package:budget_app/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewAccount extends StatefulWidget {
  const NewAccount({Key? key}) : super(key: key);

  @override
  _NewAccountState createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccount> {
  final _formKey = GlobalKey<FormState>();
  String? name;

  String description = '';
  double? amount;

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
                  'New Account',
                  style: TextStyle(
                    fontSize: 26,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 30),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Name:',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).primaryTextTheme.bodyText1,
                          ),
                        ),
                        TextFormField(
                          onSaved: (String? value) {
                            setState(() {
                              name = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Starting amount of money:',
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
                              amount = double.parse(value.toString());
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Description:',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).primaryTextTheme.bodyText1,
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onSaved: (String? value) {
                            setState(() {
                              description = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Select Currency:',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).primaryTextTheme.bodyText1,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const CurrencyPicker(),
                        const SizedBox(height: 60),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.indigoAccent[700]!),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ))),
                          onPressed: () async {
                            if (_formKey.currentState!.validate() == true &&
                                Provider.of<CurrencyClass>(context,
                                            listen: false)
                                        .currency !=
                                    null) {
                              _formKey.currentState!.save();
                              final acc = Account(
                                  name: name!,
                                  lastLog: DateTime.now(),
                                  description: description,
                                  balance: amount!,
                                  currency: Provider.of<CurrencyClass>(context,
                                          listen: false)
                                      .currency!
                                      .name,
                                  currencySign: Provider.of<CurrencyClass>(
                                          context,
                                          listen: false)
                                      .currency!
                                      .symbol);

                              await AccountsDatabase.instance
                                  .createAnAccount(acc);

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
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
