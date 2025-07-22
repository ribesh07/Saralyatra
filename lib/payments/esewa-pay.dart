// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:saralyatra/payments/esewa_function.dart';

class EsewaScreen extends StatelessWidget {
  // String userName,String busName,String deptHr,String deptMin, String contact,String date
  final String userName;
  final String busName;
  final String deptHr;
  final String deptMin;
  final String price;
  final String contact;
  final String date;
  final List selectedList;
  final String email;
  final String uniqueBusID;
  final String userID;
  final String location;

  const EsewaScreen({
    super.key,
    required this.userName,
    required this.busName,
    required this.deptHr,
    required this.deptMin,
    required this.price,
    required this.contact,
    required this.date,
    required this.selectedList,
    required this.email,
    required this.uniqueBusID,
    required this.userID,
    required this.location,
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
                Esewa esewa = Esewa();
                // esewa.pay(context, price);
                esewa.pay(
                    context,
                    price,
                    userName,
                    busName,
                    deptHr,
                    deptMin,
                    contact,
                    date,
                    selectedList,
                    email,
                    uniqueBusID,
                    userID,
                    location);
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
