import 'package:flutter/material.dart';

class StatementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Statement',
      debugShowCheckedModeBanner: false,
      home: BankStatementScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class BankStatementScreen extends StatelessWidget {
  final List<Transaction> transactions = [
    Transaction(
        date: '2025-05-30',
        description: 'topup esewa',
        amount: 50.00,
        balance: 1000.00),
    Transaction(
        date: '2025-05-30',
        description: 'bhaktapur-kalanki',
        amount: -50.00,
        balance: 950.00),
    Transaction(
        date: '2025-05-29',
        description: 'kausaltar-bhaktapur',
        amount: -20.00,
        balance: 1000.00),
    Transaction(
        date: '2025-05-28',
        description: 'kalanki-pashupati',
        amount: -30.00,
        balance: 1020.00),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(title: Text('Card Statement')),
        body: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text(tx.description),
                subtitle: Text(tx.date),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${tx.amount < 0 ? '-' : '+'} \Nrs${tx.amount.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: tx.amount < 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Bal: \Nrs${tx.balance.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Transaction {
  final String date;
  final String description;
  final double amount;
  final double balance;

  Transaction({
    required this.date,
    required this.description,
    required this.amount,
    required this.balance,
  });
}
