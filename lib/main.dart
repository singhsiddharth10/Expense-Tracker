import 'package:flutter/material.dart';
import './widgets/transaction_lists.dart';
import './widgets/new_transaction.dart';
import './model/transaction.dart';
import './widgets/chart.dart';
import 'dart:io';
import './helper/database_helper.dart';
void main() {
 // SystemChrome
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
        ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  List<Transaction> _userTransactions = [];
  bool _showChart = false;
  List<Transaction> get _recentTransaction{
    DateTime lastDayOfPrevWeek = DateTime.now().subtract(Duration(days: 6));
    lastDayOfPrevWeek = DateTime(
        lastDayOfPrevWeek.year, lastDayOfPrevWeek.month, lastDayOfPrevWeek.day);
    return _userTransactions.where((element) {
      return element.txnDateTime.isAfter(
        lastDayOfPrevWeek,
      );
    }).toList();
  }
  _MyHomePageState() {
    _updateUserTransactionsList();
  }
  void _updateUserTransactionsList() {
    Future<List<Transaction>> res =
    DatabaseHelper.instance.getAllTransactions();

    res.then((txnList) {
      setState(() {
        _userTransactions = txnList;
      });
    });
  }
  void  showChartHandler(bool show) {
    setState(() {
      _showChart = show;
    });
  }
  Future<void> _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate) async{
    final newTx = Transaction(
      DateTime.now().millisecondsSinceEpoch.toString(),
      txTitle,
      txAmount,
      chosenDate,
    );
    int res = await DatabaseHelper.instance.insert(newTx);
    if(res != 0)
      _updateUserTransactionsList();
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (BuildContext context) {
      return GestureDetector(
          child: NewTransaction(_addNewTransaction),
        onTap: (){},
        behavior: HitTestBehavior.opaque,
      );
    },
    );
  }
  Future<void> _deleteTransaction(String id) async {
    int res =
    await DatabaseHelper.instance.deleteTransactionById(int.tryParse(id));
    if (res != 0) {
      _updateUserTransactionsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text('Expense Tracker'),
      actions: <Widget>[
        Builder(
          builder: (context){
            return IconButton (
              icon: Icon(Icons.add),
              onPressed: () {
                _startAddNewTransaction(context);
              },
            );
          },
        ),
      ],
      // backgroundColor: Colors.purple,
    );
    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height  - appBar.preferredSize.height -MediaQuery.of(context).padding.top) * 0.7,
        child: TransactionList(_recentTransaction, _deleteTransaction));
    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if(isLandscape) Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Show Char',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,

                  ),),
                    Switch(
                      value: _showChart,
                      onChanged: (val){
                        setState(() {
                          _showChart = val;
                        });
                      },
                    ),
                  ],
                  ),
             if(! isLandscape)
               Container(
                   height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.3,
                   child: Chart(_userTransactions)),
              if(! isLandscape)
                txListWidget,
              if(isLandscape)
             _showChart ? Container(
             height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.6,
             child: Chart(_userTransactions)):txListWidget

            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
            child: Icon(Icons.add),
            elevation: 5,
            //backgroundColor: Colors.purple,
            onPressed: () {
              _startAddNewTransaction(context);
            }),
        ),
      );
  }
}


