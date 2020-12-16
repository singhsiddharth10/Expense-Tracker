import 'package:expensetracker/widgets/chart_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';
import '../widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  double totalSpending = 0.0;
  Chart(this.recentTransactions);
  List<Map<String, Object>> get groupedTransactionValues{
    final today = DateTime.now();
    List<double> weekSums = List<double>.filled(7,0);
    for(Transaction txn in recentTransactions){
      weekSums[txn.txnDateTime.weekday - 1]  += txn.txnAmount;
      totalSpending += txn.txnAmount;
    }
    return List.generate(7, (index) {
      final dayOfPastWeek  = today.subtract(
        Duration(
          days: index
        ),
      );

      return {'day': DateFormat('E').format(dayOfPastWeek)[0], 'amount' : weekSums[dayOfPastWeek.weekday - 1]};
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: Colors.black, width: 2)),
      elevation: 6,
      color: Colors.amberAccent,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValues.map((data){
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpending == 0.0 ? 0.0 : (data['amount'] as double ) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
