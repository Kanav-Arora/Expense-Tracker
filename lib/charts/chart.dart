import 'package:expense_planner/charts/chartBars.dart';
import 'package:flutter/material.dart';
import '../transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;
  const Chart(this.recentTransaction, {super.key});

  List<Map<String, Object>> get GroupedTransaction {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(
        Duration(days: index),
      );
      double total = 0.0;
      for (var i = 0; i < recentTransaction.length; i++) {
        if ((recentTransaction[i].date.day == weekday.day) &&
            (recentTransaction[i].date.month == weekday.month) &&
            (recentTransaction[i].date.year == weekday.year)) {
          total = total + (recentTransaction[i].amount as double);
        }
      }
      return {'day': DateFormat.E().format(weekday), 'amount': total};
    }).reversed.toList();
  }

  double get maxSpending {
    return GroupedTransaction.fold(0.0, (previousValue, element) {
      return previousValue + (element['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: GroupedTransaction.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBars(
                    data['day'] as String,
                    data['amount'] as double,
                    maxSpending == 0.0
                        ? 0.0
                        : (data['amount'] as double) / maxSpending),
              );
            }).toList(),
          ),
        ));
  }
}
