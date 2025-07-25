// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saralyatra/Booking/input_field.dart';
import 'package:saralyatra/Booking/provide.dart';
import 'package:saralyatra/payments/payment_options.dart';
import 'package:saralyatra/setups.dart';

class bookSeat extends StatefulWidget {
  final String busName;
  final String shift;
  final String depMin;
  final String depHr;
  final String arrMin;
  final String arrHr;
  final String price;
  final String date;
  final List selectedSeats;
  final String uniqueBusID;
  final String userID;
  final String location;
  const bookSeat({
    super.key,
    required this.busName,
    required this.shift,
    required this.depMin,
    required this.depHr,
    required this.arrMin,
    required this.arrHr,
    required this.price,
    required this.date,
    required this.selectedSeats,
    required this.uniqueBusID,
    required this.userID,
    required this.location,
  });

  @override
  State<bookSeat> createState() => _bookSeatState();
}

class _bookSeatState extends State<bookSeat> {
  var _value = -1;
  final double toPay = 0.0;
  final namecontroller = TextEditingController();
  final provider = settingProvider();
  final phonecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final mailcontroller = TextEditingController();
  final numbercontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    phonecontroller.dispose();
    mailcontroller.dispose();
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // int totalPrice = int.parse(${widget.price})
    String pickup = "";

    int priceD = int.parse(widget.price) * widget.selectedSeats.length;
    print(priceD);
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Booking',
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, "reset");
              },
              icon: Icon(Icons.arrow_back)),
          // actions: [
          //    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios_new_sharp)),
          //   Text("data"),
          // ],
          backgroundColor: appbarcolor,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          color: backgroundColor,
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 8,
                      child: Container(
                        height: 110,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    widget.busName,
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceEvenly,
                                  //     children: [
                                  Text(
                                    "Shift: ${widget.shift}",
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Time: ${widget.depHr}",
                                        style: textStyle,
                                      ),
                                      Text(" : "),
                                      Text(
                                        widget.depHr,
                                        style: textStyle,
                                      ),
                                      Text(
                                        " --- ",
                                        style: textStyle,
                                      ),
                                      Text(
                                        widget.arrHr,
                                        style: textStyle,
                                      ),
                                      Text(" : "),
                                      Text(
                                        widget.arrMin,
                                        style: textStyle,
                                      )
                                    ],
                                  ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 8,
                      child: Column(
                        children: [
                          Text('Contact Details', style: textStyle),
                          //Name
                          InputField(
                            icon: Icons.person,
                            label: "Full Name",
                            keypad: TextInputType.text,
                            controller: namecontroller,
                            inputFormat: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-z ]'),
                              ),
                              LengthLimitingTextInputFormatter(50),
                            ],
                            validator: (value) => provider.validator(
                                value, "full Name is required"),
                          ),

                          //phone Number
                          InputField(
                            icon: Icons.phone,
                            label: "+977",
                            keypad: TextInputType.number,
                            controller: phonecontroller,
                            inputFormat: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) =>
                                provider.phoneValidator(value),
                          ),
                          InputField(
                            icon: Icons.mail,
                            label: "Email",
                            controller: mailcontroller,
                            validator: (value) =>
                                provider.emailValidator(value),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    //address detail
                    Card(
                      elevation: 8,
                      child: Column(
                        children: [
                          Text('Pickup Point', style: textStyle),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == -1) {
                                  return "please select pickup point";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.blue.withOpacity(1),
                                        width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red.withOpacity(0.5),
                                        width: 2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red.withOpacity(1),
                                        width: 2),
                                  ),
                                  prefixIcon:
                                      Icon(Icons.add_location_alt_outlined)),
                              value: _value,
                              onChanged: (value) {
                                setState(() {
                                  _value = value as int;
                                });
                              },
                              items: [
                                DropdownMenuItem(
                                    child: Text("--Choose Pickup Point"),
                                    value: -1),
                                DropdownMenuItem(
                                    child: Text("Tinkune"), value: 1),
                                DropdownMenuItem(
                                    child: Text("Gaushala"), value: 2),
                                DropdownMenuItem(
                                    child: Text("Kalanki"), value: 3),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    //billing
                    Card(
                      elevation: 10,
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Bill Amount',
                              style: textStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Amount : ${int.parse(widget.price) * widget.selectedSeats.length}",
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Total Seat: ${widget.selectedSeats.length}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue),
                        child: TextButton(
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentOptions(
                                            userName: namecontroller.text,
                                            busName: widget.busName,
                                            deptHr: widget.depHr,
                                            deptMin: widget.depMin,
                                            contact: phonecontroller.text,
                                            date: widget.date,
                                            price: priceD.toString(),
                                            // seatNumber:widget
                                            selectedList: widget.selectedSeats,
                                            email: mailcontroller.text,
                                            uniqueBusID: widget.uniqueBusID,
                                            userID: widget.userID,
                                            location: widget.location,
                                          )));
                            }
                          },
                          child: Text(
                            "Pay Now",
                            textAlign: TextAlign.center,
                            style: textStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
