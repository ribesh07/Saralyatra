import 'package:driver/input.dart';
import 'package:driver/login.dart';
import 'package:driver/provider.dart';
import 'package:driver/setups.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final passcontroller = TextEditingController();
  final cpasscontroller = TextEditingController();
  bool passwordObsecured = true;
  bool confirmpasswordObsecured = true;
  final provider = settingProvider();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Password'),
        centerTitle: true,
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
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                FittedBox(
                  child: Text(
                    "Create New Password",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InputField(
                  label: ' New Password',
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
                          confirmpasswordObsecured = !confirmpasswordObsecured;
                        });
                      },
                      icon: Icon(confirmpasswordObsecured
                          ? Icons.visibility_off
                          : Icons.visibility)),
                  inputFormat: [LengthLimitingTextInputFormatter(16)],
                  validator: (value) => provider.cpasswordValidator(
                      passcontroller.text, cpasscontroller.text),
                ),
                SizedBox(
                  height: 10,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(
                  height: 10,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blue),
                    child: TextButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          //check from db and session out
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login_page(),
                            ),
                          );
                        } else {}
                      },
                      child: Text(
                        "Change",
                        textAlign: TextAlign.center,
                        style: textStyle,
                      ),
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
