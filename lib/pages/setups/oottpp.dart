import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class oottpp extends StatefulWidget {
  const oottpp({super.key});

  @override
  State<oottpp> createState() => _oottppState();
}

class _oottppState extends State<oottpp> {
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('otp'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: Container(
            child: PinCodeTextField(
          appContext: context,
          length: 6,
          hintCharacter: "0",
          keyboardType: TextInputType.number,
          onChanged: print,
          autoFocus: true,
        )),
      ),
    );
  }
}
