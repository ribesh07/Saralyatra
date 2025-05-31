// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:mapbox/usercard/setups.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpline extends StatefulWidget {
  const Helpline({super.key});

  @override
  State<Helpline> createState() => _HelplineState();
}

class _HelplineState extends State<Helpline> {
  var sushantNtc = 9844499531;
  var sauravNcell = 9812075707;
  var mail = "sushant.201245@ncit.edu.np";

  Uri dialnumber1 = Uri(scheme: 'tel', path: '9844499531');
  Uri dialnumber2 = Uri(scheme: 'tel', path: '9812075707');
  Uri email = Uri(scheme: 'mailto', path: 'sushant.201245@ncit.edu.np');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Support'),
        centerTitle: true,
        backgroundColor: appbarcolor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Column(
            children: [
              Center(
                child: Icon(
                  Icons.support_agent,
                  size: 200,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Customer Support',
                              style: textStyle,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  '$sushantNtc',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    '(Office)',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      launchUrl(dialnumber1);
                                    },
                                    icon: Icon(
                                      Icons.phone,
                                      color: Colors.blue,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  '$sauravNcell',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    '(Office)',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      launchUrl(dialnumber2);
                                    },
                                    icon: Icon(
                                      Icons.phone,
                                      color: Colors.blue,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                'Email',
                                style: textStyle,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 345,
                                  child: Text(
                                    mail,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      launchUrl(email);
                                    },
                                    icon: Icon(
                                      Icons.mail,
                                      color: Colors.blue,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
