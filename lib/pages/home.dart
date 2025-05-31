import 'package:chat_app/customWidget/custom_text.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  String? myUsername, myName, myEmail, myPicture;
  TextEditingController searchController =  TextEditingController();

  getthesahredpref() async {
    myUsername = await SharedpreferenceHelper().getUserName();
    myName = await SharedpreferenceHelper().getUserDisplayName();
    myEmail = await SharedpreferenceHelper().getUserEmail();
    myPicture = await SharedpreferenceHelper().getUserImage();

    setState(() {});
  }

  // getthesahredpref() async {
  //   myUsername = await SharedpreferenceHelper().getUserId();
  //   myName = await SharedpreferenceHelper().getDisplayName();
  //   myEmail = await SharedpreferenceHelper().getEmail();
  //   myPicture = await SharedpreferenceHelper().getImageUrl();

  //   setState(() {});
  // }

  @override
  void initState() {
    getthesahredpref();
    super.initState();
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  getChatRoomIdbyUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  // initiateSearch(String value) {
  //   if (value.isEmpty) {
  //     setState(() {
  //       queryResultSet = [];
  //       tempSearchStore = [];
  //       search = true;
  //     });
  //     return;
  //   }

  //   String capitalizedValue = value[0].toUpperCase() + value.substring(1);

  //   if (queryResultSet.isEmpty && value.length == 1) {
  //     // First character: fetch from DB
  //     DatabaseMethod().search(value).then((QuerySnapshot docs) {
  //       List results = [];
  //       for (int i = 0; i < docs.docs.length; ++i) {
  //         results.add(docs.docs[i].data());
  //       }

  //       setState(() {
  //         queryResultSet = results;
  //         // Also filter immediately
  //         tempSearchStore =
  //             results
  //                 .where(
  //                   (element) =>
  //                       element['username'].startsWith(capitalizedValue),
  //                 )
  //                 .toList();
  //       });
  //     });
  //   } else {
  //     // Filter existing results
  //     setState(() {
  //       tempSearchStore =
  //           queryResultSet
  //               .where(
  //                 (element) => element['username'].startsWith(capitalizedValue),
  //               )
  //               .toList();
  //     });
  //   }
  // }

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });

    var captilizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethod().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['username'].startsWith(captilizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff703eff),

      body: Container(
        margin: EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Image.asset(
                    "images/wave.png",
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  CustomText(
                    text: "Hello,",
                    textAlign: TextAlign.center,
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    text: " Ujwal",
                    textAlign: TextAlign.center,
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Color(0xff703eff),
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: CustomText(
                text: "Welcome to",
                textAlign: TextAlign.center,
                color: Color.fromARGB(197, 255, 255, 255),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),

              child: CustomText(
                text: "ChatUp",
                textAlign: TextAlign.center,
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 30, right: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFececf8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          initiateSearch(value.toUpperCase());
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search Username...",
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    search
                        ? ListView(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          primary: false,
                          shrinkWrap: true,
                          children:
                              tempSearchStore.map((element) {
                                return buildResultCard(element);
                              }).toList(),
                        )
                        : Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.asset(
                                    "images/boy.jpg",
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10),
                                    CustomText(
                                      text: "Shyam Gupta",
                                      textAlign: TextAlign.center,
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      text: "Hello, How are you?",
                                      textAlign: TextAlign.center,
                                      color: Color.fromARGB(151, 0, 0, 0),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                CustomText(
                                  text: "02:00 PM",
                                  textAlign: TextAlign.center,
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () async {
        // if (myUsername == null || data["username"] == null) {
        //   // You can show a snackbar or just return
        //   ScaffoldMessenger.of(
        //     context,
        //   ).showSnackBar(SnackBar(content: Text("User data not loaded yet")));
        //   return;
        // }

        search = false;
        var chatRoomId = getChatRoomIdbyUsername(myUsername!, data["username"]);
        Map<String, dynamic> chatInfoMap = {
          "users": [myUsername, data["username"]],
        };
        await DatabaseMethod().createChatRoom(chatRoomId, chatInfoMap);
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder:
                (context) => ChatPage(
                  name: data["Name"],
                  profileUrl: data["Image"],
                  username: data["username"],
                ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    data["Image"],
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["Name"],
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ), // TextStyle
                    ),

                    SizedBox(height: 8),
                    Text(
                      data["username"],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:chat_app/customWidget/custom_text.dart';
// import 'package:chat_app/pages/chat_page.dart';
// import 'package:chat_app/services/database.dart';
// import 'package:chat_app/services/shared_pref.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   bool search = false;
//   String? myUsername, myName, myEmail, myPicture;
//   TextEditingController searchController = TextEditingController();

//   List<dynamic> queryResultSet = [];
//   List<dynamic> tempSearchStore = [];

//   @override
//   void initState() {
//     getSharedPref();
//     super.initState();
//   }

//   Future<void> getSharedPref() async {
//     myUsername = await SharedpreferenceHelper().getUserId();
//     myName = await SharedpreferenceHelper().getDisplayName();
//     myEmail = await SharedpreferenceHelper().getEmail();
//     myPicture = await SharedpreferenceHelper().getImageUrl();
//     setState(() {});
//   }

//   String getChatRoomIdbyUsername(String a, String b) {
//     return (a.toLowerCase().compareTo(b.toLowerCase()) > 0)
//         ? "${b}_$a"
//         : "${a}_$b";
//   }

//   void initiateSearch(String value) {
//     if (value.isEmpty) {
//       setState(() {
//         queryResultSet.clear();
//         tempSearchStore.clear();
//         search = false;
//       });
//       return;
//     }

//     setState(() {
//       search = true;
//     });

//     String capitalizedValue = value[0].toUpperCase() + value.substring(1);

//     if (queryResultSet.isEmpty && value.length == 1) {
//       DatabaseMethod().search(value).then((QuerySnapshot docs) {
//         List<dynamic> results = [];
//         for (var doc in docs.docs) {
//           results.add(doc.data());
//         }

//         setState(() {
//           queryResultSet = results;
//           tempSearchStore =
//               results
//                   .where(
//                     (element) => element['username'].toString().startsWith(
//                       capitalizedValue,
//                     ),
//                   )
//                   .toList();
//         });
//       });
//     } else {
//       setState(() {
//         tempSearchStore =
//             queryResultSet
//                 .where(
//                   (element) => element['username'].toString().startsWith(
//                     capitalizedValue,
//                   ),
//                 )
//                 .toList();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff703eff),
//       body: Container(
//         margin: const EdgeInsets.only(top: 40),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             Padding(
//               padding: const EdgeInsets.only(left: 20.0),
//               child: Row(
//                 children: [
//                   Image.asset(
//                     "images/wave.png",
//                     height: 40,
//                     width: 40,
//                     fit: BoxFit.cover,
//                   ),
//                   const SizedBox(width: 10),
//                   const CustomText(
//                     text: "Hello,",
//                     textAlign: TextAlign.center,
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   CustomText(
//                     text: " ${myName ?? ''}",
//                     textAlign: TextAlign.center,
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   const Spacer(),
//                   Container(
//                     padding: const EdgeInsets.all(5),
//                     margin: const EdgeInsets.only(right: 20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(
//                       Icons.person,
//                       color: Color(0xff703eff),
//                       size: 30,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Padding(
//               padding: EdgeInsets.only(left: 20.0),
//               child: CustomText(
//                 text: "Welcome to",
//                 textAlign: TextAlign.center,
//                 color: Color.fromARGB(197, 255, 255, 255),
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.only(left: 20.0),
//               child: CustomText(
//                 text: "ChatUp",
//                 textAlign: TextAlign.center,
//                 color: Colors.white,
//                 fontSize: 40,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 30),

//             // Body Section
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.only(left: 30, right: 20),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 30),

//                     // Search Field
//                     Container(
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFececf8),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: TextField(
//                         controller: searchController,
//                         onChanged:
//                             (value) => initiateSearch(value.toUpperCase()),
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           prefixIcon: const Icon(Icons.search),
//                           suffixIcon: IconButton(
//                             icon: const Icon(Icons.clear),
//                             onPressed: () {
//                               searchController.clear();
//                               setState(() {
//                                 tempSearchStore.clear();
//                                 search = false;
//                               });
//                             },
//                           ),
//                           hintText: "Search Username...",
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // Search Results or Default Card
//                     search
//                         ? ListView(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           shrinkWrap: true,
//                           children:
//                               tempSearchStore
//                                   .map((element) => buildResultCard(element))
//                                   .toList(),
//                         )
//                         : buildDefaultUserCard(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildDefaultUserCard() {
//     return Material(
//       elevation: 3,
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(60),
//               child: Image.asset(
//                 "images/boy.jpg",
//                 height: 70,
//                 width: 70,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(width: 20),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 CustomText(
//                   text: "Shyam Gupta",
//                   textAlign: TextAlign.center,
//                   color: Colors.black,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 CustomText(
//                   text: "Hello, How are you?",
//                   textAlign: TextAlign.center,
//                   color: Color.fromARGB(151, 0, 0, 0),
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ],
//             ),
//             const Spacer(),
//             const CustomText(
//               text: "02:00 PM",
//               textAlign: TextAlign.center,
//               color: Colors.black,
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildResultCard(Map<String, dynamic> data) {
//     return GestureDetector(
//       // onTap: () async {
//       //   if (myUsername == null || data["username"] == null) {
//       //     ScaffoldMessenger.of(
//       //       context,
//       //     ).showSnackBar(SnackBar(content: Text("User data not loaded yet.")));
//       //     return;
//       //   }

//       //   setState(() {
//       //     search = false;
//       //   });

//       //   var chatRoomId = getChatRoomIdbyUsername(myUsername!, data["username"]);
//       //   Map<String, dynamic> chatInfoMap = {
//       //     "users": [myUsername, data["username"]],
//       //   };
//       //   await DatabaseMethod().createChatRoom(chatRoomId, chatInfoMap);

//       //   Navigator.push(
//       //     // ignore: use_build_context_synchronously
//       //     context,
//       //     MaterialPageRoute(
//       //       builder:
//       //           (context) => ChatPage(
//       //             name: data["Name"],
//       //             profileUrl: data["Image"],
//       //             username: data["username"],
//       //           ),
//       //     ),
//       //   );
//       // },
//       onTap: () async {
//         if (myUsername == null || data["username"] == null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("User data not loaded yet.")),
//           );
//           return;
//         }

//         if (myUsername == data["username"]) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("You can't message yourself.")),
//           );
//           return;
//         }

//         String chatRoomId = getChatRoomIdbyUsername(
//           myUsername!,
//           data["username"],
//         );

//         Map<String, dynamic> chatRoomMap = {
//           "users": [myUsername, data["username"]],
//         };

//         await DatabaseMethod().createChatRoom(chatRoomId, chatRoomMap);

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (context) => ChatPage(
//                   name: data["Name"],
//                   profileUrl: data["Image"],
//                   username: data["username"],
//                 ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         child: Material(
//           elevation: 5,
//           borderRadius: BorderRadius.circular(10),
//           child: Container(
//             padding: const EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(60),
//                   child: Image.network(
//                     data["Image"],
//                     height: 70,
//                     width: 70,
//                     fit: BoxFit.cover,
//                     errorBuilder:
//                         (context, error, stackTrace) =>
//                             const Icon(Icons.error, size: 70),
//                     loadingBuilder:
//                         (context, child, progress) =>
//                             progress == null
//                                 ? child
//                                 : const CircularProgressIndicator(),
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       data["Name"],
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.0,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       data["username"],
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
