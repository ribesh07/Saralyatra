// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saralyatra/Booking/input_field.dart';
import 'package:saralyatra/Booking/provide.dart';
import 'package:saralyatra/pages/login-page.dart';
// import 'package:saralyatra/pages/setups/oottpp.dart';
import 'package:saralyatra/setups.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final provider = settingProvider();
  final formkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
        backgroundColor: appbarcolor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        color: Color.fromARGB(255, 254, 254, 254),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 80, right: 8, left: 8),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.lock,
                    size: 50,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      "Forgot Password",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      'Enter your registered Email',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InputField(
                    label: "Email",
                    icon: Icons.mail,
                    controller: emailController,
                    keypad: TextInputType.text,
                    // inputFormat: [
                    //   FilteringTextInputFormatter.digitsOnly,
                    //   LengthLimitingTextInputFormatter(10),
                    // ],
                    validator: (value) => provider.emailValidator(value),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue),
                        child: TextButton(
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              auth.sendPasswordResetEmail(
                                  email: emailController.text.toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login_page(),
                                ),
                              );
                            } else {}
                          },
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: textStyle,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
