// ignore_for_file: camel_case_types, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:io';
// import 'dart:js';
import 'package:driver/input.dart';
import 'package:driver/otpp.dart';
import 'package:driver/provider.dart';
import 'package:driver/setups.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:sadakyatra/Booking/input_field.dart';
// import 'package:sadakyatra/Booking/provide.dart';
// import 'package:sadakyatra/pages/setups/otp.dart';
// import 'package:sadakyatra/setups.dart';

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
  File? image;
  void selectImage() async {
    image = await PickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String email = emailcontroller.text.trim();
    String password = passcontroller.text.trim();
    String cpassword = cpasscontroller.text.trim();
    // String username = usernamecontroller.text.trim();
    // String contactnum = contactnumcontroller.text.trim();

    if (image != null) {
      if (password == cpassword) {
        if (email.isNotEmpty && password.isNotEmpty) {
          // ref
          //     .read(authControllerProvider)
          //     .saveUserDataToFirebase(context, name, email, password, image);
        }
      }
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
                      image != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(image!),
                              radius: 46,
                              // child: Icon(
                              //   Icons.person,
                              //   size: 50,
                              // )
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
                      if (image == null)
                        Positioned(
                          bottom: -6,
                          right: -10,
                          child: IconButton(
                            onPressed: () {
                              selectImage();
                            },
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
                  image == null
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
                    icon: Icons.person,
                    label: "Full Name",
                    controller: usernamecontroller,
                    inputFormat: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-z ]'),
                      ),
                      LengthLimitingTextInputFormatter(50),
                    ],
                    validator: (value) =>
                        provider.validator(value, "Fullname Required"),
                  ),
                  InputField(
                    label: "Email",
                    icon: Icons.mail,
                    controller: emailcontroller,
                    validator: (value) => provider.emailValidator(value),
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
                  // const SizedBox(height: 20,),
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
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("•Minimun 8 character"),
                                      Text("•Maximum 8 Character"),
                                      Text(
                                          "•At Least one uppercase English letter [A-Z]"),
                                      Text(
                                          "•At Least one uppercase English letter [a-z]"),
                                      Text("•At least one digit [0-9]"),
                                      Text(
                                          "•At least one Special Character [@ # & ? % ^ .]"),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      );
                    },
                    icon: Icon(Icons.privacy_tip_outlined),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          //send to db
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Otp(),
                            ),
                          );
                        } else {}
                        // storeUserData;
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
