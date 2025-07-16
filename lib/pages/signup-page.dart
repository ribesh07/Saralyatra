// ignore_for_file: camel_case_types, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saralyatra/Booking/input_field.dart';
import 'package:saralyatra/Booking/provide.dart';
import 'package:saralyatra/pages/botton_nav_bar.dart';
import 'package:saralyatra/services/database.dart';
import 'package:saralyatra/services/shared_pref.dart';
import 'package:saralyatra/setups.dart';

class Signup_page extends StatefulWidget {
  const Signup_page({super.key});

  @override
  State<Signup_page> createState() => _Signup_pageState();
}

class _Signup_pageState extends State<Signup_page> {
  bool passwordObsecured = true;
  bool confirmpasswordObsecured = true;

  final provider = settingProvider();
  final emailcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  final cpasscontroller = TextEditingController();
  final usernamecontroller = TextEditingController();
  final contactnumcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  void selectImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  // getChatRoomIdbyUsername(String a, String b) {
  //   if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
  //     return "$b\_$a";
  //   } else {
  //     return "$a\_$b";
  //   }
  // }

  String getChatRoomIdbyUsername(String a, String b) {
    return (a.compareTo(b) < 0) ? "${a}_$b" : "${b}_$a";
  }

  Future<String?> _uploadImage(XFile image) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('user_images').child(image.name);
      final uploadTask = storageRef.putFile(File(image.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // signUp(String email, String password) async {
  //   if (_image == null) {
  //     print('No image selected');
  //     return;
  //   }

  //   final imageUrl = await _uploadImage(_image!);

  //   if (imageUrl == null) {
  //     print('Failed to upload image');
  //     return;
  //   }

  //   UserCredential? usercredential;
  //   try {
  //     usercredential = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(email: email, password: password);

  //     String? uid = usercredential.user?.uid;

  //     Map<String, dynamic> userInfoMap = {
  //       'username': usernamecontroller.text.toString(),
  //       'email': emailcontroller.text.toString(),
  //       'contact': contactnumcontroller.text.toString(),
  //       'uid': uid,
  //       'password': passcontroller.text.toString(),
  //       'imageUrl': imageUrl,
  //     };
  //     await DatabaseMethod().addUserDetails(userInfoMap, uid!).then((value) {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => BottomBar()));
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     print('Error: $e');
  //   }
  // }

  signUp(String email, String password) async {
    String messageUserName = email.replaceAll("@gmail.com", "");
    if (_image == null) {
      print('No image selected');
      return;
    }

    final imageUrl = await _uploadImage(_image!);

    if (imageUrl == null) {
      print('Failed to upload image');
      return;
    }

    UserCredential? usercredential;
    try {
      usercredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String? uid = usercredential.user?.uid;

      Map<String, dynamic> userInfoMap = {
        'username': usernamecontroller.text.toString(),
        'email': emailcontroller.text.toString(),
        'contact': contactnumcontroller.text.toString(),
        'uid': uid,
        'password': passcontroller.text.toString(),
        'imageUrl': imageUrl,
        'messageUsername': messageUserName,
      };

      await DatabaseMethod().addUserDetails(userInfoMap, uid!);

      var chatRoomId =
          getChatRoomIdbyUsername("Agent", userInfoMap["username"]);
      Map<String, dynamic> chatInfoMap = {
        "users": ["Agent", userInfoMap["username"]],
      };
      await DatabaseMethod().createChatRoom(chatRoomId, chatInfoMap);
      // Navigator.push(
      //   // ignore: use_build_context_synchronously
      //   context,
      //   MaterialPageRoute(
      //     builder:
      //         (context) => ChatPage(
      //           name: data["Name"],
      //           profileUrl: data["Image"],
      //           username: data["username"],
      //         ),
      //   ),
      // ).then((value) {
      //   if (value == 'refresh') {
      //     setState(() {
      //       Home();
      //     });
      //   }
      // }

      // );

      // 🔽 Save to Shared Preferences
      await SharedpreferenceHelper()
          .saveUserName(usernamecontroller.text.trim());
      await SharedpreferenceHelper().saveUserEmail(emailcontroller.text.trim());
      await SharedpreferenceHelper().saveUserImage(imageUrl);
      await SharedpreferenceHelper().saveUserId(uid);

      // Navigate to BottomBar
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomBar()));
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passcontroller.dispose();
    cpasscontroller.dispose();
    usernamecontroller.dispose();
    contactnumcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SignUp',
        ),
        centerTitle: true,
        backgroundColor: appbarcolor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(File(_image!.path)),
                              radius: 46,
                            )
                          : CircleAvatar(
                              backgroundColor: appbarcolor,
                              radius: 46,
                              child: GestureDetector(
                                onTap: selectImage,
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                ),
                              ),
                            ),
                      if (_image == null)
                        Positioned(
                          bottom: -6,
                          right: -10,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.add_a_photo_outlined,
                              size: 30,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _image == null
                      ? const Text(
                          'Add Image',
                          style: textStyle,
                        )
                      : const Text(
                          'Your Image',
                          style: textStyle,
                        ),
                  const SizedBox(
                    height: 15,
                  ),
                  InputField(
                    label: "Email",
                    icon: Icons.mail,
                    controller: emailcontroller,
                    validator: (value) => provider.emailValidator(value),
                  ),
                  InputField(
                    icon: Icons.person,
                    label: "Full Name",
                    controller: usernamecontroller,
                    inputFormat: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z ]'),
                      ),
                      LengthLimitingTextInputFormatter(50),
                    ],
                    validator: (value) =>
                        provider.validator(value, "Fullname Required"),
                  ),
                  InputField(
                    icon: Icons.phone,
                    label: "+977",
                    keypad: TextInputType.number,
                    controller: contactnumcontroller,
                    inputFormat: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) => provider.phoneValidator(value),
                  ),
                  InputField(
                    label: 'Password',
                    icon: Icons.lock,
                    controller: passcontroller,
                    isvisible: passwordObsecured,
                    eyeButton: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordObsecured = !passwordObsecured;
                        });
                      },
                      icon: Icon(passwordObsecured
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    inputFormat: [LengthLimitingTextInputFormatter(16)],
                    validator: (value) => provider.passwordValidator(value),
                  ),
                  InputField(
                    label: 'Confirm password',
                    icon: Icons.lock,
                    controller: cpasscontroller,
                    isvisible: confirmpasswordObsecured,
                    eyeButton: IconButton(
                        onPressed: () {
                          setState(() {
                            confirmpasswordObsecured =
                                !confirmpasswordObsecured;
                          });
                        },
                        icon: Icon(confirmpasswordObsecured
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    inputFormat: [LengthLimitingTextInputFormatter(16)],
                    validator: (value) => provider.cpasswordValidator(
                        passcontroller.text, cpasscontroller.text),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text("Password must have"),
                              content: FittedBox(
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("•Minimum 8 characters"),
                                      Text("•Maximum 16 characters"),
                                      Text(
                                          "•At least one uppercase English letter [A-Z]"),
                                      Text(
                                          "•At least one lowercase English letter [a-z]"),
                                      Text("•At least one digit [0-9]"),
                                      Text(
                                          "•At least one special character [@ # & ? % ^ .]"),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      );
                    },
                    icon: Icon(Icons.privacy_tip_outlined),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //         height: MediaQuery.of(context).size.height / 20,
                  //         child: ToggleButtons(
                  //           isSelected: isSelected,
                  //           borderRadius: BorderRadius.circular(8),
                  //           selectedColor: Colors.white,
                  //           fillColor: Colors.blue,
                  //           children: [
                  //             Container(
                  //               width: MediaQuery.of(context).size.width / 3,
                  //               child: Padding(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 16),
                  //                 child: Text(
                  //                   "I am User",
                  //                   textAlign: TextAlign.center,
                  //                   style:
                  //                       TextStyle(fontStyle: FontStyle.italic),
                  //                 ),
                  //               ),
                  //             ),
                  //             Container(
                  //               width: MediaQuery.of(context).size.width / 3,
                  //               child: Padding(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 16),
                  //                 child: Text(
                  //                   "I am Driver",
                  //                   textAlign: TextAlign.center,
                  //                   style:
                  //                       TextStyle(fontStyle: FontStyle.italic),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //           onPressed: (int index) {
                  //             setState(() {
                  //               // Set only the clicked index to true, others false
                  //               for (int i = 0; i < isSelected.length; i++) {
                  //                 isSelected[i] = i == index;
                  //               }
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //       SizedBox(height: 20),
                  //       Text(
                  //         "Selected: ${isSelected[0] ? "I am User" : "I am driver"}",
                  //         style: TextStyle(fontStyle: FontStyle.italic),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          signUp(emailcontroller.text.toString(),
                              passcontroller.text.toString());
                        } else {}
                      },
                      child: Text(
                        'Submit',
                        style: textStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
