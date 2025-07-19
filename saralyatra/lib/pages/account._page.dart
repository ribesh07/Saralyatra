// ignore_for_file: camel_case_types

import 'dart:io';
// import 'dart:js';
import 'package:flutter/material.dart';
import 'package:saralyatra/setups.dart';

class accountUpdate extends StatefulWidget {
  const accountUpdate({super.key});

  @override
  State<accountUpdate> createState() => _accountUpdateState();
}

class _accountUpdateState extends State<accountUpdate> {
  final emailcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  final cpasscontroller = TextEditingController();
  final usernamecontroller = TextEditingController();
  final contactnumcontroller = TextEditingController();
  File? image;
  void selectImage() async {
    image = await PickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String email = emailcontroller.text.trim();
    String password = passcontroller.text.trim();
    String cpassword = cpasscontroller.text.trim();
    String username = usernamecontroller.text.trim();
    String contactnum = contactnumcontroller.text.trim();

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
  void dispose() {
    emailcontroller.dispose();
    // passcontroller.dispose();
    // cpasscontroller.dispose();
    usernamecontroller.dispose();
    contactnumcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            alignment: Alignment.center,
            child: const Padding(
              padding: EdgeInsets.only(right: 69),
              child: Text(
                'Edit details',
                style: textStyleappbar,
              ),
            )),
        backgroundColor: appbarcolor,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            color: Colors.blueGrey[100],
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
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
                  height: 26,
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
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 10, left: 18, right: 18),
                  child: TextField(
                    controller: emailcontroller,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       top: 8, bottom: 10, left: 18, right: 18),
                //   child: TextField(
                //     controller: usernamecontroller,
                //     decoration: const InputDecoration(
                //       labelText: 'Username',
                //       border: OutlineInputBorder(),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 10, left: 18, right: 18),
                  child: TextField(
                    controller: contactnumcontroller,
                    decoration: const InputDecoration(
                      labelText: 'Contact Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // const SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint(emailcontroller.text);
                      // debugPrint(passcontroller.text);
                      // debugPrint(cpasscontroller.text);
                      debugPrint(contactnumcontroller.text);
                      debugPrint(usernamecontroller.text);
                      debugPrint("Inside Button invoked !!!");
                      storeUserData;
                    },
                    child: const Text(
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
    );
  }
}
