import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saralyatra/Booking/search_bus.dart';
import 'package:saralyatra/setups.dart';

class HomeDefScreen extends StatefulWidget {
  final String userUId;

  const HomeDefScreen({
    Key? key,
    required this.userUId,
  }) : super(key: key);

  @override
  State<HomeDefScreen> createState() => _HomeDefScreenState();
}

class _HomeDefScreenState extends State<HomeDefScreen>
    with SingleTickerProviderStateMixin {
  var departurevalue = -1;
  var destinationvalue = -1;
  final formkey = GlobalKey<FormState>();
  int current = 0;
  List<Map<String, dynamic>> dataItemsAll = [];
  List<Map<String, dynamic>> dataItemsBLogs = [];
  List<Map<String, dynamic>> dataItemsNews = [];
  var location;
  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      // Fetch blogs from Firestore
      QuerySnapshot blogSnapshot = await FirebaseFirestore.instance
          .collection('uploads')
          .doc('blogDetails')
          .collection('blogs')
          .get();

      List<Map<String, dynamic>> blogs = blogSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'title': data['title'] ?? 'No Title',
          'imageUrl': data['imageUrl'] ?? '',
          'description': data['description'] ?? 'No Description',
          'type': 'blog'
        };
      }).toList();

      // Fetch news from Firestore
      QuerySnapshot newsSnapshot = await FirebaseFirestore.instance
          .collection('uploads')
          .doc('newsDetails')
          .collection('news')
          .get();

      List<Map<String, dynamic>> news = newsSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'title': data['title'] ?? 'No Title',
          'imageUrl': data['imageUrl'] ?? '',
          'description': data['description'] ?? 'No Description',
          'type': 'news'
        };
      }).toList();

      setState(() {
        dataItemsBLogs = blogs;
        dataItemsNews = news;
        dataItemsAll = [...blogs, ...news];
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  void _showDescriptionDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  double changeContainerColor() {
    switch (current) {
      case 0:
        return double.infinity;
      case 1:
        return double.infinity;
      case 2:
        return double.infinity;
      default:
        return 0;
    }
  }

  Container ChangeLayout() {
    switch (current) {
      case 0:
        return Container(
          child: SizedBox(
            height: 240.0,
            child: ListView.builder(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: dataItemsAll.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: SizedBox(
                      height: 200,
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "   ${dataItemsAll[index]["title"]}",
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
                                image: dataItemsAll[index]["imageUrl"] != ''
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            dataItemsAll[index]["imageUrl"]!),
                                        fit: BoxFit.contain,
                                      )
                                    : null,
                              ),
                              child: dataItemsAll[index]["imageUrl"] == ''
                                  ? Center(child: Text('No Image'))
                                  : null,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    _showDescriptionDialog(
                                      dataItemsAll[index]["title"] ?? 'Title',
                                      dataItemsAll[index]["description"] ??
                                          'No Description',
                                    );
                                  },
                                  child: Text(
                                    'Read',
                                    style: buttonStyle,
                                  )),
                            ],
                          )
                        ],
                      )),
                ),
              ),
            ),
          ),
        );

      case 1:
        return Container(
          child: SizedBox(
            height: 240.0,
            child: ListView.builder(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: dataItemsBLogs.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: SizedBox(
                      height: 200,
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "   ${dataItemsBLogs[index]["title"]}",
                            style: textStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: listColor,
                                image: dataItemsBLogs[index]["imageUrl"] != ''
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            dataItemsBLogs[index]["imageUrl"]!),
                                        fit: BoxFit.contain,
                                      )
                                    : null,
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                              child: dataItemsBLogs[index]["imageUrl"] == ''
                                  ? Center(child: Text('No Image'))
                                  : null,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    _showDescriptionDialog(
                                      dataItemsBLogs[index]["title"] ?? 'Title',
                                      dataItemsBLogs[index]["description"] ??
                                          'No Description',
                                    );
                                  },
                                  child: Text(
                                    'Read',
                                    style: buttonStyle,
                                  )),
                            ],
                          )
                        ],
                      )),
                ),
              ),
            ),
          ),
        );

      case 2:
        return Container(
          child: SizedBox(
            height: 240.0,
            child: ListView.builder(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: dataItemsNews.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: SizedBox(
                      height: 200,
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "   ${dataItemsNews[index]["title"]}",
                            style: textStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: listColor,
                                image: dataItemsNews[index]["imageUrl"] != ''
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            dataItemsNews[index]["imageUrl"]!),
                                        fit: BoxFit.contain,
                                      )
                                    : null,
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                              child: dataItemsNews[index]["imageUrl"] == ''
                                  ? Center(child: Text('No Image'))
                                  : null,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    _showDescriptionDialog(
                                      dataItemsNews[index]["title"] ?? 'Title',
                                      dataItemsNews[index]["description"] ??
                                          'No Description',
                                    );
                                  },
                                  child: Text(
                                    'Read',
                                    style: buttonStyle,
                                  )),
                            ],
                          )
                        ],
                      )),
                ),
              ),
            ),
          ),
        );

      default:
        return Container();
    }
  }

  List<String> TabItem = [
    "All",
    "Blogs",
    "News",
  ];

  final _value = -1;
  var departureDate = DateFormat("yyyy/MM/dd").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Column(
            children: [
              Form(
                key: formkey,
                child: Container(
                  color: backgroundColor,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                      elevation: 8,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          DropdownButtonFormField(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            validator: (value) {
                              if (value == -1) {
                                return "Please select pickup point";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
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
                                prefixIcon: Icon(departurevalue == -1
                                    ? Icons.add_location_alt_outlined
                                    : Icons.add_location_alt_sharp)),
                            value: departurevalue,
                            onChanged: (value) {
                              setState(() {
                                departurevalue = value as int;
                                print(_value);
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                  child: Text(
                                    "From",
                                    style: dropDownFirststyle,
                                  ),
                                  value: -1),
                              DropdownMenuItem(
                                  child: Text(
                                    "Kathmandu",
                                    style: dropDownTextStyle,
                                  ),
                                  value: 1),
                              DropdownMenuItem(
                                  child: Text(
                                    "Pokhara",
                                    style: dropDownTextStyle,
                                  ),
                                  value: 2),
                              DropdownMenuItem(
                                  child: Text(
                                    "Janakpur",
                                    style: dropDownTextStyle,
                                  ),
                                  value: 3),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DropdownButtonFormField(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            validator: (value) {
                              if (value == -1) {
                                return "Please Choose Location";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
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
                                prefixIcon: Icon(destinationvalue == -1
                                    ? Icons.add_location_alt_outlined
                                    : Icons.add_location_alt_sharp)),
                            value: destinationvalue,
                            onChanged: (value) {
                              setState(() {
                                destinationvalue = value as int;
                                print(_value);
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                  child: Text(
                                    "To",
                                    style: dropDownFirststyle,
                                  ),
                                  value: -1),
                              DropdownMenuItem(
                                  child: Text(
                                    "Kathmandu",
                                    style: dropDownTextStyle,
                                  ),
                                  value: 1),
                              DropdownMenuItem(
                                  child: Text(
                                    "Pokhara",
                                    style: dropDownTextStyle,
                                  ),
                                  value: 2),
                              DropdownMenuItem(
                                  child: Text(
                                    "Janakpur",
                                    style: dropDownTextStyle,
                                  ),
                                  value: 3),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Departure Date ',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () async {
                                final selectedate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    Duration(days: 30),
                                  ),
                                );
                                if (selectedate != null) {
                                  setState(() {
                                    departureDate = DateFormat("yyyy/MM/dd")
                                        .format(selectedate);
                                    print(selectedate);
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final selectedate = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(
                                          Duration(days: 30),
                                        ),
                                      );
                                      if (selectedate != null) {
                                        setState(() {
                                          departureDate =
                                              DateFormat("yyyy/MM/dd")
                                                  .format(selectedate);
                                          print(selectedate);
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.calendar_month_outlined,
                                      size: 30,
                                    ),
                                  ),
                                  Text(departureDate)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
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
                                    if (departurevalue == destinationvalue) {
                                      final snackBar = SnackBar(
                                        backgroundColor:
                                            Color.fromARGB(255, 226, 5, 12),
                                        elevation: 10,
                                        duration: Duration(milliseconds: 3000),
                                        content: const Text(
                                          "Departure and Destination must be different",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else if (departurevalue !=
                                        destinationvalue) {
                                      if (departurevalue == 1 &&
                                          destinationvalue == 2) {
                                        location = 'KTM-POK';
                                      } else if (departurevalue == 1 &&
                                          destinationvalue == 3) {
                                        location = 'KTM-JKR';
                                      } else if (departurevalue == 2 &&
                                          destinationvalue == 1) {
                                        location = 'KTM-POK';
                                      } else if (departurevalue == 2 &&
                                          destinationvalue == 3) {
                                        location = 'POK-JKR';
                                      } else if (departurevalue == 3 &&
                                          destinationvalue == 1) {
                                        location = 'JKR-KTM';
                                      } else if (departurevalue == 3 &&
                                          destinationvalue == 2) {
                                        location = 'JKR-POK';
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SearchBus(
                                            location: location.toString(),
                                            date: departureDate,
                                            userId: widget.userUId,
                                            // userI
                                          ),
                                        ),
                                      );
                                    } else {}
                                  } else {}
                                },
                                child: Text(
                                  'Search Bus',
                                  style: textStyle,
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
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemCount: TabItem.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                current = index;
                                print(current);
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: index == current
                                      ? Colors.blue
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              width: 70,
                              child: Center(child: Text(TabItem[index])),
                            ),
                          );
                        },
                      ),
                    ),
                    AnimatedContainer(
                      width: changeContainerColor(),
                      duration: Duration(milliseconds: 300),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: ChangeLayout(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
