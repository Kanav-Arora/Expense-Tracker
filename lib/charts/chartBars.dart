import 'package:flutter/material.dart';

class ChartBars extends StatelessWidget {
  final String label;
  final double spending;
  final double percTotal;
  const ChartBars(this.label, this.spending, this.percTotal);

  @override
  Widget build(BuildContext context) {
    // print(percTotal);
    return Column(
      children: <Widget>[
        FittedBox(
          child: Text('\$${spending.toStringAsFixed(0)}'),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          height: 60,
          width: 15,
          child: Stack(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  color: const Color(0xFFEFCA65),
                  borderRadius: BorderRadius.circular(10)),
            ),
            FractionallySizedBox(
              heightFactor: percTotal,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10)),
              ),
            )
          ]),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(label)
      ],
    );
  }
}
