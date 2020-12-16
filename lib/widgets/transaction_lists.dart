import 'package:flutter/material.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
final List<Transaction> transaction;
final Function deleteTransaction;
TransactionList(this.transaction,this.deleteTransaction);
  @override
  Widget build(BuildContext context) {
    return transaction.isEmpty ? LayoutBuilder(builder: (ctx,constraints){
      return Column(
        children: <Widget>[
          Text("No transaction added yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
          SizedBox(
            height: 30,
          ),
          Container(
            height: constraints.maxHeight * 0.6 ,
            child: Image.asset('assets/images/waiting.png', fit:BoxFit.cover),
          ),

        ],
      );
    },) : ListView.builder(
      itemBuilder: (context,index){
        Transaction txn = transaction[index];
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Colors.black, width: 2)),
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 5,
          ),
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: FittedBox(
                  child: Text(
                    '₹ ${txn.txnAmount}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              txn.txnTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),

            ),
            subtitle: Text(
              DateFormat.yMMMd().format(txn.txnDateTime),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () => deleteTransaction(txn.txnId),
            ),
          ),
        );
        },
      itemCount: transaction.length,
    );
  }
}
