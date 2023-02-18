import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactEntry extends StatelessWidget {
  final double amount;
  final String title;
  final DateTime date;
  final DateFormat formatter = DateFormat.yMMMd();
  TransactEntry(this.amount, this.title, this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "\$${amount.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(formatter.format(date),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
