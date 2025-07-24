import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saralyatra/Booking/input_field.dart';
import 'package:saralyatra/Booking/provide.dart';
import 'package:saralyatra/driver/driverPage.dart';
import 'package:saralyatra/driver/home.dart';
import 'package:saralyatra/pages/ForgotPassword.dart';
import 'package:saralyatra/pages/botton_nav_bar.dart';
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
  bool _isLoading = false;

  Future<void> userLogin(
      String email, String password, BuildContext context) async {
    setState(() => _isLoading = true);
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

        setState(() => _isLoading = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BottomBar()),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      showSnackBarMsg(
        context: context,
        message: "Login error: ${e.toString()}",
        bgColor: Colors.red,
      );
    }
  }

  Future<void> driverLogin(
      String email, String password, BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final uid = userCredential.user?.uid;

      if (uid != null) {
        final sessionToken = const Uuid().v4();

        final driverDoc = await FirebaseFirestore.instance
            .collection('saralyatra')
            .doc('driverDetailsDatabase')
            .collection('drivers')
            .doc(uid)
            .get();

        if (driverDoc.exists) {
          await FirebaseFirestore.instance
              .collection('saralyatra')
              .doc('driverDetailsDatabase')
              .collection('drivers')
              .doc(uid)
              .update({'sessionToken': sessionToken});

          await SharedpreferenceHelper().saveBusNumber(driverDoc['busNumber']);
          await SharedpreferenceHelper().saveSessionToken(sessionToken);
          await SharedpreferenceHelper().saveUserId(uid);
          await SharedpreferenceHelper().saveRole('driver');

          setState(() => _isLoading = false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DriverPage()),
          );
        } else {
          setState(() => _isLoading = false);
          showSnackBarMsg(
            context: context,
            message: "Driver account not found. Please contact support.",
            bgColor: Colors.red,
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      showSnackBarMsg(
        context: context,
        message: "Login error: ${e.toString()}",
        bgColor: Colors.red,
      );
    }
  }

  List<bool> isSelected = [true, false];

  @override
  void dispose() {
    emailcontroller.dispose();
    passcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Login Page'),
            centerTitle: true,
            backgroundColor: appbarcolor,
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            child: Form(
              key: formkey,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      CircleAvatar(
                        backgroundColor: appbarcolor,
                        radius: 46,
                        child: Icon(Icons.person, size: 50),
                      ),
                      SizedBox(height: 26),
                      Text(
                        'Your Credentials',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: InputField(
                          label: "Email",
                          icon: Icons.mail,
                          keypad: TextInputType.text,
                          controller: emailcontroller,
                          validator: (value) => provider.emailValidator(value),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
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
                          validator: (value) =>
                              provider.passwordValidator(value),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ToggleButtons(
                          isSelected: isSelected,
                          borderRadius: BorderRadius.circular(8),
                          selectedColor: Colors.white,
                          fillColor: Colors.blue,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Text("I am User",
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontStyle: FontStyle.italic)),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Text("I am Driver",
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontStyle: FontStyle.italic)),
                            ),
                          ],
                          onPressed: (int index) {
                            setState(() {
                              for (int i = 0; i < isSelected.length; i++) {
                                isSelected[i] = i == index;
                              }
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account ??", style: textStyle),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Signup_page()),
                              );
                            },
                            child: Text(
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
                                builder: (context) => const ForgotPassword()),
                          );
                        },
                        child: Text("Forgot Password ??"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (formkey.currentState!.validate()) {
                                    final email = emailcontroller.text.trim();
                                    final password = passcontroller.text.trim();
                                    if (isSelected[0]) {
                                      userLogin(email, password, context);
                                    } else if (isSelected[1]) {
                                      driverLogin(email, password, context);
                                    }
                                  }
                                },
                          child: Text('Submit', style: textStyle),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // ✅ Full screen loading overlay
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
