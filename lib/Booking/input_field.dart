// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:saralyatra/Booking/seatbooking_form.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputField extends StatelessWidget {
  final String label;
  final IconData? icon;
  //final IconData? hola;
  final IconButton? eyeButton;
  final bool isvisible;
  final TextInputType? keypad;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final List<TextInputFormatter>? inputFormat;
  // final Function(String)? hola;

  const InputField({
    super.key,
    this.label = "label Name",
    this.icon,
    // this.keypad,
    this.controller,
    this.validator,
    this.inputFormat,
    this.keypad,
    this.eyeButton,
    this.isvisible = false,
    //this.hola,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onTapOutside: (event) {
          //print('onTapOutside');
          FocusManager.instance.primaryFocus?.unfocus();
        },

        validator: validator,
        controller: controller,
        obscureText: isvisible,
        inputFormatters: inputFormat,
        keyboardType: keypad,
        autovalidateMode:
            AutovalidateMode.onUserInteraction, //validation while typing
        // keyboardType:
        //     (keypad != null) ? TextInputType.number : TextInputType.text,
        //onChanged: hola,
        decoration: InputDecoration(
          label: Text(label),
          prefixIcon: Icon(icon),
          suffixIcon: eyeButton,

          hintText: label,

          //
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide:
                BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.blue.withOpacity(1), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide:
                BorderSide(color: Colors.red.withOpacity(0.4), width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide:
                BorderSide(color: Colors.red.withOpacity(1), width: 1.5),
          ),
        ),
      ),
    );
  }
}
