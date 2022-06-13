import 'package:expense_planner/widgets/chart.dart';

import 'models/transaction.dart';
import 'widgets/new_transaction.dart';
import 'widgets/transaction_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        fontFamily: 'Open Sans',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline1: const TextStyle(
                color: Colors.black,
                fontFamily: 'Quicksand',
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
              button: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: TextButton.styleFrom(
          primary: Colors.cyan,
        )),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Quicksand',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(id: 't1', title: 'My Shoes', amount: 46.54, date: DateTime.now()),
    Transaction(id: 't2', title: 'Study', amount: 87.50, date: DateTime.now()),
    Transaction(id: 't3', title: 'Groceries', amount: 35.26, date: DateTime.now()),
    Transaction(id: 't4', title: 'Groceries', amount: 35.26, date: DateTime.now()),
    // Transaction(id: 't5', title: 'Groceries', amount: 35.26, date: DateTime.now()),
    // Transaction(id: 't6', title: 'Study', amount: 87.50, date: DateTime.now()),
    // Transaction(id: 't7', title: 'Groceries', amount: 35.26, date: DateTime.now()),
    // Transaction(id: 't8', title: 'Groceries', amount: 35.26, date: DateTime.now()),
    // Transaction(id: 't9', title: 'Groceries', amount: 35.26, date: DateTime.now()),
    // Transaction(id: 't10', title: 'Groceries', amount: 35.26, date: DateTime.now()),
    // Transaction(id: 't11', title: 'Groceries', amount: 35.26, date: DateTime.now()),
    // Transaction(id: 't12', title: 'Groceries', amount: 35.26, date: DateTime.now()),
    // Transaction(id: 't13', title: 'Groceries', amount: 35.26, date: DateTime.now()),
    // Transaction(id: 't14', title: 'Groceries', amount: 35.26, date: DateTime.now()),
    // Transaction(id: 't15', title: 'Groceries', amount: 35.26, date: DateTime.now()),
  ];

  bool _showchart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((txn) {
      return txn.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  _addNewTransaction(String txTitle, double txAmount, DateTime date) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: date,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((txn) => txn.id == id);
    });
  }

  _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      centerTitle: true,
      title: const Text(
        'Expense Planner',
      ),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: Icon(Icons.add),
        ),
      ],
    );

    final txnListWidget = SizedBox(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(
        transactions: _userTransactions,
        deleteTxn: _deleteTransaction,
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Show Chart'),
                    Switch(
                      value: _showchart,
                      onChanged: (value) {
                        setState(() {
                          _showchart = value;
                        });
                      },
                    ),
                  ],
                ),
              if (!isLandscape)
                SizedBox(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.3,
                  child: Chart(recentTransactions: _recentTransactions),
                ),
              if (!isLandscape) txnListWidget,
              if (isLandscape)
                _showchart
                    ? SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.3,
                        child: Chart(recentTransactions: _recentTransactions),
                      )
                    : txnListWidget,
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorLight,
        onPressed: () => _startAddNewTransaction(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
