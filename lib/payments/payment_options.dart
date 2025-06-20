// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:saralyatra/payments/esewa-pay.dart';
import 'package:saralyatra/payments/khalti-pay.dart';
import 'package:saralyatra/setups.dart';

class PaymentOptions extends StatefulWidget {
  // String userName,String busName,String deptHr,String deptMin, String contact,String date

  final String userName;
  final String busName;
  final String deptHr;
  final String deptMin;
  final String contact;
  final String date;
  final String price;
  final List selectedList;
  final String email;
  final String uniqueBusID;
  final String userID;
  final String location;

  PaymentOptions({
    super.key,
    required this.userName,
    required this.busName,
    required this.deptHr,
    required this.deptMin,
    required this.contact,
    required this.date,
    required this.price,
    required this.selectedList,
    required this.email,
    required this.uniqueBusID,
    required this.userID,
    required this.location,
  });

  @override
  State<PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  @override
  Widget build(BuildContext context) {
    String listString = widget.selectedList.join(', ');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarcolor,
          title: Text(
            "Payment Options",
            style: textStyleappbar,
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color.fromARGB(255, 149, 203, 229),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        // String userName,String busName,String deptHr,String deptMin, String contact,String date
                        MaterialPageRoute(
                            builder: (context) => EsewaScreen(
                                  userName: widget.userName,
                                  busName: widget.busName,
                                  deptHr: widget.deptHr,
                                  deptMin: widget.deptMin,
                                  contact: widget.contact,
                                  date: widget.date,
                                  price: widget.price,
                                  selectedList: widget.selectedList,
                                  email: widget.email,
                                  uniqueBusID: widget.uniqueBusID,
                                  userID: widget.userID,
                                  location: widget.location,
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Card(
                          // surfaceTintColor: Color.fromARGB(255, 115, 149, 222),
                          color: Color.fromARGB(255, 168, 172, 241),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Seats: ",
                                        style: textStyle,
                                      ),
                                      Text(
                                        listString,

                                        //wdd
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Payable Amount : ${widget.price}",
                                    style: textStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: Image(
                              image: AssetImage('assets/logos/esewa_logo.png')),
                        ),
                        Text(
                          "Pay With Esewa",
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PaymentKhalti()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: Image(
                              image: AssetImage('assets/logos/khalti.png')),
                        ),
                        Text(
                          "Pay With Khalti",
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
