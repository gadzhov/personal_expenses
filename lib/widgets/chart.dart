import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart(this._recentTransactions, {Key? key}) : super(key: key);

  final List<Transaction> _recentTransactions;

  List<Map<String, dynamic>> get _groupedTransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (var tran in _recentTransactions) {
        if (tran.date.day == weekday.day &&
            tran.date.month == weekday.month &&
            tran.date.year == weekday.year) {
          totalSum += tran.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekday),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get maxSpending => _groupedTransactionValues.fold(
      0.0, (previousValue, element) => previousValue + element['amount']);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _groupedTransactionValues
              .map(
                (grp) => Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(grp['day'], grp['amount'],
                      maxSpending == 0.0 ? 0.0 : grp['amount'] / maxSpending),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
