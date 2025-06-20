// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:saralyatra/pages/botton_nav_bar.dart';
import 'package:saralyatra/pages/tickets/pdf_generate.dart';
import 'package:printing/printing.dart';
import 'package:saralyatra/setups.dart';

class generateTicket extends StatefulWidget {
  final String userName;
  final String busName;
  final String deptHr;
  final String deptMin;
  final String txnRefId;
  final String contact;
  final String price;
  final String date;
  final List selectedList;
  final String uniqueBusID;
  final String userID;

  const generateTicket({
    super.key,
    required this.userName,
    required this.busName,
    required this.deptHr,
    required this.deptMin,
    required this.txnRefId,
    required this.contact,
    required this.price,
    required this.date,
    required this.selectedList,
    required this.uniqueBusID,
    required this.userID,
  });

  @override
  State<generateTicket> createState() => _generateTicketState();
}

// Future<void> _storeD

class _generateTicketState extends State<generateTicket> {
  @override
  Widget build(BuildContext context) {
    String time = '${widget.deptHr} : ${widget.deptMin}';
    String listString = widget.selectedList.join(', ');
    int totalSeats = widget.selectedList.length;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Ticket'),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                // _pushImageInStorage();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BottomBar()));
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Sadak Yatra',
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Name',
                        style: textStyle,
                      ),
                      Text(widget.userName, style: textStyle)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bus name',
                        style: textStyle,
                      ),
                      Text(
                        widget.busName,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Departure Date',
                        style: textStyle,
                      ),
                      Text(
                        widget.date,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Departure Time',
                        style: textStyle,
                      ),
                      Text(
                        '${widget.deptHr} : ${widget.deptMin}',
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction Id',
                        style: textStyle,
                      ),
                      Text(
                        widget.txnRefId,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Contact",
                        style: textStyle,
                      ),
                      Text(
                        widget.contact,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Seat No',
                        style: textStyle,
                      ),
                      Text(
                        listString,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Seat',
                        style: textStyle,
                      ),
                      Text(
                        '$totalSeats',
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: textStyle,
                      ),
                      Text(
                        widget.price,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "contact us: 9844499531",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 50, 115, 168)),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.amberAccent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Disclaimer: Customer needs to show the ticket during travel',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.blue,
                  child: TextButton(
                    onPressed: () => printDoc(
                        widget.userName,
                        widget.busName,
                        widget.date,
                        time,
                        widget.txnRefId,
                        widget.contact,
                        listString,
                        totalSeats,
                        widget.price),
                    child: Text("Generate PDF",
                        style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> printDoc(
    String name,
    String busName,
    String departureDate,
    String departureTime,
    String txn,
    String contact,
    String selectedList,
    int totalSeats,
    String amount) async {
  final doc = pw.Document();
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return builPrintableData(name, busName, departureDate, departureTime,
            txn, contact, selectedList, totalSeats, amount);
      }));
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}
