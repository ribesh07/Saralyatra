// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:saralyatra/setups.dart';

class CancelledTickets extends StatefulWidget {
  const CancelledTickets({super.key});

  @override
  State<CancelledTickets> createState() => _CancelledTicketsState();
}

class _CancelledTicketsState extends State<CancelledTickets> {
  List<dynamic> dataItems = [
    {"product": "[Description1]", "frequency": "[Trip id1]"},
    {"product": "[Description1]", "frequency": "[Trip id2]"},
    {"product": "[Description1]", "frequency": "[Trip id3]"},
    {"product": "[Description1]", "frequency": "[Trip id4]"}
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      child: ListView.builder(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        // ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: dataItems.length,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: SizedBox(
                height: 200,
                width: 300,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "   ${dataItems[index]["frequency"].toString()}",
                      style: textStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: listColor,
                        ),
                        child: Text(dataItems[index]["product"].toString(),
                            style: textStyle, textAlign: TextAlign.center),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
