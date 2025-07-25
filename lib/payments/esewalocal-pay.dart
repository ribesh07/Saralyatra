// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:saralyatra/payments/eaewalocal_function.dart';
// import 'package:saralyatra/payments/esewa_function.dart';

class EsewaLocalScreen extends StatelessWidget {
  // String userName,String busName,String deptHr,String deptMin, String contact,String date
  final String userName;

  final String price;
  final String contact;
  final String date;
  final String email;
  final String userID;

  const EsewaLocalScreen({
    super.key,
    required this.userName,
    required this.price,
    required this.contact,
    required this.date,
    required this.email,
    required this.userID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esewa Integration'),
        backgroundColor: const Color.fromRGBO(103, 58, 183, 1),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Icon(
            Icons.paid,
            size: 300,
          ),
          Text(
            'Payment',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              child: const Text('Pay with E-Sewa'),
              onPressed: () {
                Esewalocal esewa = Esewalocal();
                // esewa.pay(context, price);
                esewa.pay(context, price, userName, contact, date, email,
                    userID, 'Topup');
                // pay(BuildContext context, String price, String userName, String busName,
                //     String deptHr, String deptMin, String contact, String date) {
              },
            ),
          ),
        ],
      ),
    );
  }
}
