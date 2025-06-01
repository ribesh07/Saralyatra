// ignore_for_file: prefer_const_constructors, unused_local_variable, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:driver/setups.dart';
import 'package:flutter/material.dart';
//import 'package:sadakyatra/setups.dart';

class changeProfilePic extends StatefulWidget {
  const changeProfilePic({super.key});

  @override
  State<changeProfilePic> createState() => _changeProfilePicState();
}

class _changeProfilePicState extends State<changeProfilePic> {
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

  // void storeUserData() async {
  //   String email = emailcontroller.text.trim();
  //   String password = passcontroller.text.trim();
  //   String cpassword = cpasscontroller.text.trim();
  //   String username = usernamecontroller.text.trim();
  //   String contactnum = contactnumcontroller.text.trim();

  //   if (image != null) {
  //     if (password == cpassword) {
  //       if (email.isNotEmpty && password.isNotEmpty) {
  //         // ref
  //         //     .read(authControllerProvider)
  //         //     .saveUserDataToFirebase(context, name, email, password, image);
  //       }
  //     }
  //   }
  // }

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
        title: Text(
          'Change Profile Pic',
        ),
        centerTitle: true,
        backgroundColor: appbarcolor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              FittedBox(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    image != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(image!),
                            radius: 80,
                            // child: Icon(
                            //   Icons.person,
                            //   size: 50,
                            // )
                          )
                        : CircleAvatar(
                            backgroundColor: appbarcolor,
                            radius: 80,
                            child: GestureDetector(
                              onTap: selectImage,
                              child: const Icon(
                                Icons.person,
                                size: 90,
                              ),
                            ),
                          ),
                    if (image == null)
                      Positioned(
                        bottom: -6,
                        right: -8,
                        child: IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          icon: const Icon(
                            Icons.add_a_photo_outlined,
                            size: 40,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 26,
              ),
              image == null
                  ? const Text(
                      'Add profile pic',
                      style: TextStyle(fontSize: 25),
                    )
                  : const Text(
                      'Your Image',
                      style: textStyle,
                    ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (image != null) {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.green,
                      elevation: 10,
                      duration: Duration(milliseconds: 3000),
                      content: const Text(
                        "Profile Pic Uppdated",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    final snackBar = SnackBar(
                      backgroundColor: Color.fromARGB(255, 232, 13, 13),
                      elevation: 10,
                      duration: Duration(milliseconds: 3000),
                      content: const Text(
                        "Please Select Image",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
