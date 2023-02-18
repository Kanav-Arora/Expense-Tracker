import './transaction.dart';
import 'package:flutter/material.dart';
import './transactEntry.dart';
import 'charts/chart.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Quicksand',
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'Opensand',
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
      home: const MyHomePage(title: 'Expense Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> transactions = [];

  final title = TextEditingController();
  final amount = TextEditingController();
  DateTime date = DateTime.now();

  void _startTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          // _ means we don't actually require that
          return Card(
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  controller: title,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  controller: amount,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      date = newDateTime;
                    },
                  ),
                ),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        String t = title.text.toString();
                        String a = amount.text.toString();
                        if (t.isNotEmpty && a.isNotEmpty) {
                          var ad = double.parse(a);
                          title.clear();
                          amount.clear();
                          transactions.insert(
                              0, Transaction(title: t, amount: ad, date: date));
                          transactions.sort(((a, b) {
                            if (a.date.isBefore(b.date)) {
                              return 1;
                            } else if (a.date.isAfter(b.date)) {
                              return -1;
                            } else {
                              return 0;
                            }
                          }));
                        }
                        Navigator.pop(context);
                      });
                    },
                    child: const Text("New Transaction"))
              ]),
            ),
          );
        });
  }

  List<Transaction> get _recentTransaction {
    return transactions.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _startTransaction(context),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: transactions.isEmpty
            ? [
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "No transactions yet!!",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          height: 200,
                          child: Image.asset(
                            'assets/images/waiting.png',
                            fit: BoxFit.contain,
                          ))
                    ])
              ]
            : <Widget>[
                Card(
                  elevation: 5,
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    width: double.infinity,
                    child: Chart(_recentTransaction),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (ctx, ind) {
                    Transaction tx = transactions[ind];
                    return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          setState(() {
                            transactions.removeAt(ind);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Transaction: ${tx.title}',
                              style: TextStyle(fontSize: 18),
                            ),
                            action: SnackBarAction(
                              label: "Dismiss",
                              onPressed: () => {},
                            ),
                          ));
                        },
                        background: Container(
                          color: Colors.red,
                        ),
                        child: TransactEntry(tx.amount, tx.title, tx.date));
                  },
                  itemCount: transactions.length,
                ))
              ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () => _startTransaction(context),
          child: const Icon(Icons.add)),
    );
  }
}
