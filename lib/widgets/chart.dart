import 'package:expense_planner/models/transaction.dart';
import 'package:expense_planner/widgets/chart_bars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  const Chart({Key? key, required this.recentTransactions}) : super(key: key);

  final List<Transaction> recentTransactions;

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      var totalAmtSum = 0.0;
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalAmtSum += recentTransactions[i].amount;
        }
      }
      // print(DateFormat.E().format(weekDay));
      // print(totalAmtSum);

      return {'Day': DateFormat.E().format(weekDay), 'Amount': totalAmtSum};
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactions.fold(0.0, (sum, data) {
      return sum + (data['Amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(groupedTransactions);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactions.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: data['Day'].toString(),
                spendingAmt: data['Amount'] as double,
                spendingPercentTotal:
                    totalSpending == 0.0 ? 0.0 : ((data['Amount'] as double) / totalSpending),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
