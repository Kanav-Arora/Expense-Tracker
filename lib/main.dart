import './transaction.dart';
import 'package:flutter/material.dart';
import './transactEntry.dart';

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
      ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            elevation: 5,
            color: Colors.blue,
            child: Container(
              width: double.infinity,
              child: const Text("Chart Placeholder"),
            ),
          ),
          Card(
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: title,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller: amount,
                )
              ]),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, ind) {
              Transaction tx = transactions[ind];
              return TransactEntry(tx.amount, tx.title, tx.date);
            },
            itemCount: transactions.length,
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              String t = title.text.toString();
              String a = amount.text.toString();
              if (t.isNotEmpty && a.isNotEmpty) {
                var ad = double.parse(a);
                title.clear();
                amount.clear();
                transactions.insert(
                    0, Transaction(title: t, amount: ad, date: DateTime.now()));
              }
              print("Transaction added");
            });
          },
          child: const Icon(Icons.add)),
    );
  }
}
