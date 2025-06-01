import 'package:driver/new_password.dart';
import 'package:driver/otpp.dart';
import 'package:driver/provider.dart';
import 'package:driver/setups.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgetOtp extends StatefulWidget {
  const ForgetOtp({super.key});

  @override
  State<ForgetOtp> createState() => _ForgetOtpState();
}

class _ForgetOtpState extends State<ForgetOtp> {
  final pin1controller = TextEditingController();
  final pin2controller = TextEditingController();
  final pin3controller = TextEditingController();
  final pin4controller = TextEditingController();
  final pin5controller = TextEditingController();
  final pin6controller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final provider = settingProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('OTP Verification'),
          centerTitle: true,
          backgroundColor: appbarcolor,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Container(
                          height: 200,
                          width: 200,
                          child: Image(
                              image: AssetImage('assets/logos/security.png'))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Verification code",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "We have sent the code verification to ",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                " your mobile number",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Otp(
                            hint: "0",
                            controller: pin1controller,
                            validator: (value) => provider.otpValidator(value),
                          ),
                          Otp(
                            hint: "0",
                            controller: pin2controller,
                            validator: (value) => provider.otpValidator(value),
                          ),
                          Otp(
                            hint: "0",
                            controller: pin3controller,
                            validator: (value) => provider.otpValidator(value),
                          ),
                          Otp(
                            hint: "0",
                            controller: pin4controller,
                            validator: (value) => provider.otpValidator(value),
                          ),
                          Otp(
                            hint: "0",
                            controller: pin5controller,
                            validator: (value) => provider.otpValidator(value),
                          ),
                          Otp(
                            hint: "0",
                            controller: pin6controller,
                            validator: (value) => provider.otpValidator(value),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewPassword()));
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
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
