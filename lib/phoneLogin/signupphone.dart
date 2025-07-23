import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/setups.dart';

class Signupphone extends StatelessWidget {
  const Signupphone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'SignUp',
            style: textStyleappbar,
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      FirebaseAuth auth = FirebaseAuth.instance;

                      await auth.verifyPhoneNumber(
                        phoneNumber: '+9779809691013',
                        verificationFailed: (FirebaseAuthException e) {
                          if (e.code == 'invalid-phone-number') {
                            print('The provided phone number is not valid.');
                          }
                        },
                        verificationCompleted:
                            (PhoneAuthCredential credential) async {
                          await auth.signInWithCredential(credential);
                        },
                        codeSent:
                            (String verificationId, int? resendToken) async {
                          String smsCode = '123456';

                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: smsCode);

                          await auth.signInWithCredential(credential);
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    },
                    child: Text('SignUp with Phone')),
              ],
            )));
  }
}
