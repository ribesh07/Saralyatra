// ignore_for_file: camel_case_types, prefer_const_constructors, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saralyatra/Booking/input_field.dart';
import 'package:saralyatra/Booking/provide.dart';
import 'package:saralyatra/driver/driverPage.dart';
// import 'package:saralyatra/driver/driverPage.dart';
import 'package:saralyatra/driver/home.dart';
import 'package:saralyatra/pages/ForgotPassword.dart';
import 'package:saralyatra/pages/botton_nav_bar.dart';
// import 'package:saralyatra/pages/serviceSelection.dart';
import 'package:saralyatra/pages/setups/snackbar_message.dart';
import 'package:saralyatra/pages/signup-page.dart';
import 'package:saralyatra/services/shared_pref.dart';
import 'package:saralyatra/setups.dart';
import 'package:uuid/uuid.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  bool passObsecure = true;
  final provider = settingProvider();
  final emailcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  // login(String email, String password) async {
  //   UserCredential? usercredential;
  //   try {
  //     usercredential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password)
  //         .then((value) => Navigator.pushReplacement(
  //             context, MaterialPageRoute(builder: (context) => BottomBar())));
  //     _storePassword();
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBarMsg(
  //         // ignore: use_build_context_synchronously
  //         context: context,
  //         message: e.toString(),
  //         bgColor: Colors.red);
  //   }
  // }

  // userLogin(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);

  //     final uid = userCredential.user?.uid;

  //     if (uid != null) {
  //       // 🔽 Fetch user data from Firestore
  //       final userDoc = await FirebaseFirestore.instance
  //           .collection('saralyatra')
  //           .doc('userDetailsDatabase')
  //           .collection('users')
  //           .doc(uid)
  //           .get();

  //       if (userDoc.exists) {
  //         final userData = userDoc.data();

  //         if (userData != null) {
  //           // 🔽 Save to Shared Preferences
  //           await SharedpreferenceHelper()
  //               .saveUserName(userData['username'] ?? '');
  //           await SharedpreferenceHelper()
  //               .saveUserEmail(userData['email'] ?? '');
  //           await SharedpreferenceHelper()
  //               .saveUserImage(userData['imageUrl'] ?? '');
  //           await SharedpreferenceHelper().saveUserId(uid);
  //           await SharedpreferenceHelper().saveRole("user");
  //         }
  //       }

  //       // Optional: Store password back to Firestore (not recommended generally)
  //       await _storePassword();
  //       if (!context.mounted) return;
  //       // 🔽 Navigate
  //       Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (context) => Serviceselection()));
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (!context.mounted) return;
  //     showSnackBarMsg(
  //       context: context,
  //       message: e.message ?? "Login failed",
  //       bgColor: Colors.red,
  //     );
  //   }
  // }

  Future<void> userLogin(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final uid = userCredential.user?.uid;

      if (uid != null) {
        final sessionToken = const Uuid().v4();

        await FirebaseFirestore.instance
            .collection('saralyatra')
            .doc('userDetailsDatabase')
            .collection('users')
            .doc(uid)
            .update({'sessionToken': sessionToken});

        await SharedpreferenceHelper().saveSessionToken(sessionToken);
        await SharedpreferenceHelper().saveUserId(uid);
        await SharedpreferenceHelper().saveRole('user');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BottomBar()),
        );
      }
    } catch (e) {
      showSnackBarMsg(
        context: context,
        message: "Login error: ${e.toString()}",
        bgColor: Colors.red,
      );
    }
  }

  Future<void> driverLogin(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final uid = userCredential.user?.uid;

      if (uid != null) {
        final sessionToken = const Uuid().v4();

        // Check if the driver document exists first
        final driverDoc = await FirebaseFirestore.instance
            .collection('saralyatra')
            .doc('driverDetailsDatabase')
            .collection('drivers')
            .doc(uid)
            .get();

        if (driverDoc.exists) {
          // Update existing document
          await FirebaseFirestore.instance
              .collection('saralyatra')
              .doc('driverDetailsDatabase')
              .collection('drivers')
              .doc(uid)
              .update({'sessionToken': sessionToken});

          await SharedpreferenceHelper().saveSessionToken(sessionToken);
          await SharedpreferenceHelper().saveUserId(uid);
          await SharedpreferenceHelper().saveRole('driver');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DriverPage()),
          );
        } else {
          // Document doesn't exist - this shouldn't happen for valid drivers
          showSnackBarMsg(
            context: context,
            message: "Driver account not found. Please contact support.",
            bgColor: Colors.red,
          );
        }
      }
    } catch (e) {
      showSnackBarMsg(
        context: context,
        message: "Login error: ${e.toString()}",
        bgColor: Colors.red,
      );
    }
  }

  // driverLogin(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);

  //     final uid = userCredential.user?.uid;

  //     if (uid != null) {
  //       // 🔽 Fetch user data from Firestore
  //       final userDoc = await FirebaseFirestore.instance
  //           .collection('saralyatra')
  //           .doc('driverDetailsDatabase')
  //           .collection('drivers')
  //           .doc(uid)
  //           .get();

  //       if (userDoc.exists) {
  //         final userData = userDoc.data();

  //         if (userData != null) {
  //           // 🔽 Save to Shared Preferences
  //           await SharedpreferenceHelper()
  //               .saveDriverName(userData['username'] ?? '');
  //           await SharedpreferenceHelper()
  //               .saveDriverEmail(userData['email'] ?? '');
  //           await SharedpreferenceHelper()
  //               .saveDriverImage(userData['imageUrl'] ?? '');
  //           await SharedpreferenceHelper().saveUserId(uid);
  //           await SharedpreferenceHelper().saveRole("driver");
  //         }
  //       }

  //       // Optional: Store password back to Firestore (not recommended generally)
  //       await _storeDriverPassword();
  //       if (!context.mounted) return;
  //       // 🔽 Navigate
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => DriverPage()));
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (!context.mounted) return;
  //     showSnackBarMsg(
  //       context: context,
  //       message: e.message ?? "Login failed",
  //       bgColor: Colors.red,
  //     );
  //   }
  // }

  Future<void> _storePassword() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    try {
      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('userDetailsDatabase')
          .collection('users')
          .doc(uid)
          .update({
        'password': passcontroller.text,
      });
    } catch (e) {}
  }

  Future<void> _storeDriverPassword() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    try {
      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('drivers')
          .doc(uid)
          .update({
        'password': passcontroller.text,
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passcontroller.dispose();
    // cpasscontroller.dispose();
    super.dispose();
  }

  List<bool> isSelected = [true, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Page',
        ),
        backgroundColor: appbarcolor,
      ),
      body: SizedBox(
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
                      label: "Email",
                      icon: Icons.mail,
                      keypad: TextInputType.text,
                      // inputFormat: [
                      //   FilteringTextInputFormatter.digitsOnly,
                      //   LengthLimitingTextInputFormatter(10),
                      // ],
                      controller: emailcontroller,
                      validator: (value) => provider.emailValidator(value),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 20,
                          child: ToggleButtons(
                            isSelected: isSelected,
                            borderRadius: BorderRadius.circular(8),
                            selectedColor: Colors.white,
                            fillColor: Colors.blue,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    "I am User",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    "I am Driver",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                            ],
                            onPressed: (int index) {
                              setState(() {
                                // Set only the clicked index to true, others false
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                                print("ID:$isSelected");
                              });
                            },
                          ),
                        ),
                        // SizedBox(height: 20),
                        // Text(
                        //   "Selected: ${isSelected[0] ? "I am User" : "I am driver"}",
                        //   style: TextStyle(fontStyle: FontStyle.italic),
                        // ),
                      ],
                    ),
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
                          if (isSelected[0]) {
                            userLogin(emailcontroller.text.toString(),
                                passcontroller.text.toString(), context);
                            // AuthMethods().signInWithEmailAndPassword(context,
                            //     emailcontroller.text, passcontroller.text);
                          } else if (isSelected[1]) {
                            driverLogin(emailcontroller.text.toString(),
                                passcontroller.text.toString(), context);
                          }
                          debugPrint(emailcontroller.text);
                          debugPrint(passcontroller.text);
                        }
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
