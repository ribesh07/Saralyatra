// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:driver/input.dart';
import 'package:driver/provider.dart';
import 'package:driver/setups.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sadakyatra/Booking/input_field.dart';
// import 'package:sadakyatra/Booking/provide.dart';
// import 'package:sadakyatra/setups.dart';

class EditEmail extends StatefulWidget {
  const EditEmail({super.key});

  @override
  State<EditEmail> createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  bool passwordObsecured = true;
  final emailcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final provider = settingProvider();
  final formkey = GlobalKey<FormState>();
  var password = 'hola';

  @override
  void initState() {
    namecontroller.text = 'hey';
    emailcontroller.text = 'a@gmail.com';
    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passcontroller.dispose();
    namecontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarcolor,
        title: Text('Edit Details'),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                InputField(
                  label: 'Fullname',
                  icon: Icons.person,
                  controller: namecontroller,
                  inputFormat: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-z ]'),
                    ),
                    LengthLimitingTextInputFormatter(50),
                  ],
                  validator: (value) =>
                      provider.validator(value, 'Fullname required'),
                ),
                InputField(
                  label: 'Email',
                  icon: Icons.mail,
                  controller: emailcontroller,
                  validator: (value) => provider.emailValidator(value),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                  child: Text('Enter password to update email'),
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
                  validator: (value) => provider.passValidator(value),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            if (passcontroller.text == password) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.green,
                                elevation: 10,
                                duration: Duration(milliseconds: 3000),
                                content: const Text(
                                  "Email changed",
                                  style: TextStyle(fontSize: 20),
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              final snackBar = SnackBar(
                                backgroundColor: Color.fromARGB(255, 230, 5, 5),
                                elevation: 10,
                                duration: Duration(milliseconds: 3000),
                                content: const Text(
                                  "Password Incorrect",
                                  style: TextStyle(fontSize: 20),
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } else {}
                        },
                        child: Text(
                          'Save Changes',
                        )),
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
