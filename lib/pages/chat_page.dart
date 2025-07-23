import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_string/random_string.dart';
import 'package:saralyatra/services/database.dart';

class ChatPage extends StatefulWidget {
  ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream? messageStream;
  TextEditingController messagecontroller = TextEditingController();
  String? myUsername, myName, myEmail, myPicture, chatRoomId, messageId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isRecording = false;
  String? _filePath;

  User? _currentUser;
  Map<String, dynamic>? _userData;

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  Future<void> _initialize() async {
    await _recorder.openRecorder();

    await _requestPermission();
    var tempDir = await getTemporaryDirectory();
    _filePath = '${tempDir.path}/audio.aac';
  }

  Future<void> _requestPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  Future<void> _startRecording() async {
    await _recorder.startRecorder(toFile: _filePath);
    setState(() {
      _isRecording = true;
      Navigator.pop(context);
      openRecording();
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.startRecorder();
    setState(() {
      _isRecording = false;
      Navigator.pop(context);
      openRecording();
    });
  }

  @override
  void initState() {
    super.initState();
    _initUserFlow();

    ontheload();
  }

  Future<void> _uploadFile() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Your Audio is Uploading Please Wait...",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
    File file = File(_filePath!);
    try {
      TaskSnapshot snapshot =
          await FirebaseStorage.instance.ref('uploads/audio.acc').putFile(file);
      String downloadURL = await snapshot.ref.getDownloadURL();
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('h:mm:ssa').format(now);
      Map<String, dynamic> messageInfoMap = {
        "Data": "Audio",
        "message": downloadURL,
        "SendBy": myUsername,
        "ts": formattedDate,
        "time": FieldValue.serverTimestamp(),
        "imgUrl": myPicture,
      };
      messageId = randomAlphaNumeric(10);
      await DatabaseMethod()
          .addMessage(chatRoomId!, messageId!, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": "Audio",
          "lastMessageSendTs": formattedDate,
          "time": FieldValue.serverTimestamp(),
          "lastMessageSendBy": myUsername,
        };
        DatabaseMethod().updateLastMessageSend(
          chatRoomId!,
          lastMessageInfoMap,
        );
      });
    } catch (e) {
      print("Error Uploading to FireBase: $e");
    }
  }

  Future<void> _initUserFlow() async {
    await _fetchUserData(); // wait until data is fetched
    await getDetails(); // then use it
    ontheload(); // then load anything else
  }

  Future<void> _fetchUserData() async {
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('userDetailsDatabase')
          .collection('users')
          .doc(_currentUser!.uid)
          .get();
      setState(() {
        _userData = userDoc.data() as Map<String, dynamic>?;
      });
    }
  }

  getDetails() async {
    myUsername = await _userData?['messageUsername'];
    myEmail = await _userData?['email'];
    myPicture = await _userData?['imageUrl'];
    chatRoomId = getChatRoomIdbyUsername("Agent", myUsername!);
    setState(() {});
  }

  getandSetMessages() async {
    messageStream = await DatabaseMethod().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  Future<void> _uploadImage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Your Image is Uploading Please Wait...",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
    try {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImage").child(addId);

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadurl1 = await (await task).ref.getDownloadURL();
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('h:mma ').format(now);
      Map<String, dynamic> messageInfoMap = {
        "Data": "Image",
        "message": downloadurl1,
        "SendBy": myUsername,
        "ts": formattedDate,
        "time": FieldValue.serverTimestamp(),
        "imgUrl": myPicture,
      };
      messageId = randomAlphaNumeric(10);
      await DatabaseMethod()
          .addMessage(chatRoomId!, messageId!, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": "Image",
          "lastMessageSendTs": formattedDate,
          "time": FieldValue.serverTimestamp(),
          "lastMessageSendBy": myUsername,
        };
        DatabaseMethod().updateLastMessageSend(
          chatRoomId!,
          lastMessageInfoMap,
        );
      });
    } catch (e) {
      print("Error uploading to FireBase: $e");
    }
  }

  ontheload() async {
    await getandSetMessages();
    setState(() {});
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    _uploadImage();
    setState(() {});
  }

  Widget chatMessageTile(String message, bool sendByMe, String Data) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomRight:
                    sendByMe ? Radius.circular(0) : Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: sendByMe ? Radius.circular(30) : Radius.circular(0),
              ),
              color: sendByMe ? Colors.blue : Colors.grey,
            ),
            child: Data == "Image"
                ? Image.network(
                    message,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : Data == "Audio"
                    ? Row(
                        children: [
                          Icon(Icons.mic, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Audio",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        message,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
          ),
        ),
      ],
    );
  }

  Widget chatMessage() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTile(
                    ds["message"],
                    myUsername == ds["SendBy"],
                    ds["Data"],
                  );
                },
              )
            : Container();
      },
    );
  }

  String getChatRoomIdbyUsername(String a, String b) {
    return (a.compareTo(b) < 0) ? "${a}_$b" : "${b}_$a";
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Color(0xff703eff),
  //     body: Container(
  //       margin: EdgeInsets.only(top: 40),
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(left: 20),
  //             child: Row(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Icon(
  //                     Icons.arrow_back_ios_new_rounded,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 SizedBox(width: MediaQuery.of(context).size.width / 5),
  //                 Text(
  //                   // _userData?['username'] ?? 'Loading...',
  //                   "Agent",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 24,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           Expanded(
  //             child: Container(
  //               padding: EdgeInsets.only(left: 10, right: 10),
  //               // padding: EdgeInsets.only(left: 30, right: 20),
  //               width: MediaQuery.of(context).size.width,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(30),
  //                   topRight: Radius.circular(30),
  //                 ),
  //               ),
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     height: MediaQuery.of(context).size.height / 1.25,
  //                     child: chatMessage(),
  //                   ),
  //                   Container(
  //                     child: Row(
  //                       children: [
  //                         GestureDetector(
  //                           onTap: () {
  //                             openRecording();
  //                           },
  //                           child: Container(
  //                             padding: EdgeInsets.all(5),
  //                             decoration: BoxDecoration(
  //                               color: Color(0xff703eff),
  //                               borderRadius: BorderRadius.circular(60),
  //                             ),
  //                             child: Icon(
  //                               Icons.mic,
  //                               size: 35,
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(width: 10),
  //                         Expanded(
  //                           child: Container(
  //                             padding: EdgeInsets.only(left: 10),
  //                             decoration: BoxDecoration(
  //                               color: Color(0xFFececf8),
  //                               borderRadius: BorderRadius.circular(10),
  //                             ),
  //                             child: TextField(
  //                               onChanged: (value) {},
  //                               controller: messagecontroller,
  //                               decoration: InputDecoration(
  //                                 border: InputBorder.none,
  //                                 hintText: "Write a message...",
  //                                 suffixIcon: GestureDetector(
  //                                   onTap: () {
  //                                     getImage();
  //                                   },
  //                                   child: Icon(Icons.attach_file),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(width: 10),
  //                         GestureDetector(
  //                           onTap: () {
  //                             addMessage(true);
  //                           },
  //                           child: Container(
  //                             padding: EdgeInsets.all(8),
  //                             decoration: BoxDecoration(
  //                               color: Color(0xff703eff),
  //                               borderRadius: BorderRadius.circular(60),
  //                             ),
  //                             child: Icon(
  //                               Icons.send,
  //                               size: 30,
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff703eff),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 5),
                  Text(
                    "Agent",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Chat and Input Section
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
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
                    // Message List
                    Expanded(
                      child: chatMessage(),
                    ),

                    // Message Input
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          // Mic Icon
                          GestureDetector(
                            onTap: openRecording,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xff703eff),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Icon(Icons.mic,
                                  size: 30, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),

                          // TextField
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: Color(0xFFececf8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: messagecontroller,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Write a message...",
                                  suffixIcon: GestureDetector(
                                    onTap: getImage,
                                    child: Icon(Icons.attach_file),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),

                          // Send Button
                          GestureDetector(
                            onTap: () => addMessage(true),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xff703eff),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Icon(Icons.send,
                                  size: 30, color: Colors.white),
                            ),
                          ),
                        ],
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

  Future openRecording() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Text(
                    "Add Voice Note",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_isRecording) {
                        _stopRecording();
                      } else {
                        _startRecording();
                      }
                    },
                    child: Text(
                      _isRecording ? 'StopRecording' : 'Start Recording',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (_isRecording) {
                        null;
                      } else {
                        _uploadFile();
                      }
                    },
                    child: Text(
                      "Upload Audio",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  addMessage(bool sendClicked) {
    if (messagecontroller.text != "") {
      String message = messagecontroller.text;
      messagecontroller.text = "";
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('h:mm:ssa').format(now);
      Map<String, dynamic> messageInfoMap = {
        "Data": "Message",
        "message": message,
        "SendBy": myUsername,
        "ts": formattedDate,
        "time": FieldValue.serverTimestamp(),
        // "imgUrl": myPicture,
      };
      messageId = randomAlphaNumeric(10);

      DatabaseMethod().addMessage(chatRoomId!, messageId!, messageInfoMap).then(
        (value) {
          Map<String, dynamic> lastMessageInfoMap = {
            "lastMessage": message,
            "lastMessageSendTs": formattedDate,
            "time": FieldValue.serverTimestamp(),
            "lastMessageSendBy": myUsername,
          };
          DatabaseMethod().updateLastMessageSend(
            chatRoomId!,
            lastMessageInfoMap,
          );
          if (sendClicked) {
            message = "";
            print("Done");
          }
        },
      );
    }
  }
}
