import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';
import 'widgets/chart.dart';
import 'widgets/transaction_list.dart';
import 'widgets/new_transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ));
    return MaterialApp(
      title: 'Personal Expenses',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Colors.amber,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _transactions = <Transaction>[
    Transaction(
      id: 't1',
      title: 'New shoes',
      amount: 99.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'New Jacket',
      amount: 59.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'Phone',
      amount: 1559.99,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  List<Transaction> get _recentTransactions => _transactions
      .where((tran) =>
          tran.date.isAfter(DateTime.now().subtract(const Duration(days: 7))))
      .toList();

  bool _showChart = false;

  void _addNewTransaction(String title, double amount, DateTime date) =>
      setState(() => _transactions.add(
            Transaction(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: title,
              amount: amount,
              date: date,
            ),
          ));

  void _deleteTransaction(String id) {
    setState(() => _transactions.removeWhere((tran) => tran.id == id));
  }

  void _onSwitchPressed(bool value) => setState(() => _showChart = value);

  void _onShowNewTransactionModal(BuildContext context) => showModalBottomSheet(
      context: context, builder: (_) => NewTransaction(_addNewTransaction));

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar;
    if (Platform.isAndroid) {
      appBar = CupertinoNavigationBar(
        middle: const Text('Personal Expenses'),
        trailing: CupertinoButton(
          onPressed: () => _onShowNewTransactionModal(context),
          child: const Icon(CupertinoIcons.add),
        ),
      );
    } else {
      appBar = AppBar(
        title: const Text('Personal Expenses'),
        actions: [
          IconButton(
              onPressed: () => _onShowNewTransactionModal(context),
              icon: const Icon(Icons.add)),
        ],
      );
    }

    const chartHeight = 40.0;
    var heightWithOffset = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;
    if (isLandscape) {
      heightWithOffset -= chartHeight;
    }

    final appBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          if (isLandscape)
            SizedBox(
              height: chartHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart',
                      style: Theme.of(context).textTheme.headline6),
                  Platform.isIOS
                      ? Switch(value: _showChart, onChanged: _onSwitchPressed)
                      : CupertinoSwitch(
                          value: _showChart, onChanged: _onSwitchPressed)
                ],
              ),
            ),
          if (isLandscape)
            _showChart
                ? SizedBox(
                    height: heightWithOffset, child: Chart(_recentTransactions))
                : SizedBox(
                    height: heightWithOffset,
                    child: TransactionList(_transactions, _deleteTransaction)),
          if (!isLandscape) ...[
            SizedBox(
              height: heightWithOffset * 0.3,
              child: Chart(_recentTransactions),
            ),
            SizedBox(
              height: heightWithOffset * 0.7,
              child: TransactionList(_transactions, _deleteTransaction),
            )
          ],
        ],
      ),
    ));

    return Platform.isAndroid
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: appBody)
        : Scaffold(appBar: appBar, body: appBody);
  }
}
