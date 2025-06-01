// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:driver/input.dart';
import 'package:driver/provider.dart';
import 'package:driver/setups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sadakyatra/Booking/input_field.dart';
// import 'package:sadakyatra/Booking/provide.dart';
// import 'package:sadakyatra/setups.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final passcontroller = TextEditingController();
  bool isObsecure = true;
  final provider = settingProvider();
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
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
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                InputField(
                  label: 'Enter Password',
                  icon: Icons.lock,
                  controller: passcontroller,
                  isvisible: isObsecure,
                  eyeButton: IconButton(
                    onPressed: () {
                      setState(() {
                        isObsecure = !isObsecure;
                      });
                    },
                    icon: Icon(
                        isObsecure ? Icons.visibility_off : Icons.visibility),
                  ),
                  validator: (value) => provider.passValidator(value),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text("Are You Sure?"),
                              content: FittedBox(
                                child: Container(
                                  height: 100,
                                  width: 200,
                                  child: Column(
                                    children: [
                                      Text(
                                          'This will permanently delete your account'),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {},
                                            child: Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('No'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      );
                    } else {}
                    // showDialog(
                    //   context: context,
                    //   builder: (_) {
                    //     return AlertDialog(
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(10),
                    //         ),
                    //         title: Text("Are You Sure?"),
                    //         content: FittedBox(
                    //           child: Container(
                    //             height: 100,
                    //             width: 200,
                    //             child: Column(
                    //               children: [
                    //                 Text(
                    //                     'This will permanently delete your account'),
                    //                 SizedBox(height: 10),
                    //                 Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   children: [
                    //                     TextButton(
                    //                       onPressed: () {},
                    //                       child: Text('Yes'),
                    //                     ),
                    //                     TextButton(
                    //                       onPressed: () {
                    //                         Navigator.pop(context);
                    //                       },
                    //                       child: Text('No'),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ));
                    //   },
                    // );
                  },
                  child: Text('Delete Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
