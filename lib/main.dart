import 'package:budget_app/database/db.dart';
import 'package:budget_app/models/currency.dart';
import 'package:budget_app/models/date.dart';
import 'package:budget_app/screens/acc_info.dart';
import 'package:budget_app/screens/new_account.dart';
import 'package:budget_app/screens/new_transaction.dart';
import 'package:budget_app/screens/accounts.dart';
import 'package:budget_app/screens/home.dart';
import 'package:budget_app/screens/stats.dart';
import 'package:budget_app/screens/trans_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(
          create: (context) => CurrencyClass(),
         ),
        ChangeNotifierProvider(
          create: (context) => DateClass(),
        ),
      ],
      
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blueAccent[700],
          backgroundColor: Colors.white,
          secondaryHeaderColor: Colors.purple[900],
          primaryTextTheme: const TextTheme(
            bodyText1: TextStyle(
              color: Colors.black,
              fontSize: 22,
            ),
          ),
          // fontFamily: 'Raleway',
        ),
        routes: {
          '/home': (context) => const Home(),
          '/stats': (context) => const Stats(),
          '/accounts': (context) => const AccountScreen(),
          '/newTransaction': (context) => const NewTransaction(),
          '/newAccount': (context) => const NewAccount(),
          '/accInfo':(context)=> const AccInfo(),
          '/transInfo':(context)=> const TransInfo(),
        },
        home: const Home(),
      ),
    );
  }
}
