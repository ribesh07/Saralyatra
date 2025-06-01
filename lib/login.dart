// ignore_for_file: camel_case_types, prefer_const_constructors

// import 'package:flutter/cupertino.dart';
import 'package:driver/forgor_pass.dart';
import 'package:driver/input.dart';
import 'package:driver/provider.dart';
import 'package:driver/setups.dart';
import 'package:driver/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  bool passObsecure = true;
  final provider = settingProvider();
  final phonecontroller = TextEditingController();
  final passcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    phonecontroller.dispose();
    passcontroller.dispose();
    // cpasscontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Page',
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
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const CircleAvatar(
                    backgroundColor: appbarcolor,
                    radius: 46,
                    child: Icon(
                      Icons.person,
                      size: 50,
                    ),
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  const Text(
                    'Your Creditinals',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 10, left: 18, right: 18),
                    child: InputField(
                      label: "+977",
                      icon: Icons.phone,
                      keypad: TextInputType.number,
                      inputFormat: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      controller: phonecontroller,
                      validator: (value) => provider.phoneValidator(value),
                    ),
                  ),
                  // const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 10, left: 18, right: 18),
                    child: InputField(
                      label: 'Password',
                      icon: Icons.lock,
                      controller: passcontroller,
                      isvisible: passObsecure,
                      eyeButton: IconButton(
                        onPressed: () {
                          setState(() {
                            passObsecure = !passObsecure;
                          });
                        },
                        icon: Icon(passObsecure
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                      inputFormat: [LengthLimitingTextInputFormatter(16)],
                      validator: (value) => provider.passwordValidator(value),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account ??",
                        style: textStyle,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signup_page()));
                        },
                        child: const Text(
                          '  SignUp',
                          style: TextStyle(
                              color: Color.fromARGB(255, 154, 60, 227),
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                      },
                      child: Text("Forgot Password ??")),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                        } else {}
                        debugPrint(phonecontroller.text);
                        debugPrint(passcontroller.text);
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
      ),
    );
  }
}
