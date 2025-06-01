import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Otp extends StatelessWidget {
  final String? hint;
  //final TextInputType? keypad;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  //final List<TextInputFormatter>? inputFormat;

  //final Function(String)? hola;

  const Otp({
    super.key,
    this.controller,
    this.validator,
    // this.inputFormat,
    // this.keypad,
    this.hint,
    /* this.hola,*/
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        // height: 50,
        width: 50,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            onTapOutside: (event) {
              //print('onTapOutside');
              FocusManager.instance.primaryFocus?.unfocus();
            },

            validator: validator,
            controller: controller,

            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            keyboardType: TextInputType.number,
            autovalidateMode:
                AutovalidateMode.onUserInteraction, //validation while typing

            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              } else {
                FocusScope.of(context).previousFocus();
              }
            },
            // onTapOutside:hola,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: EdgeInsets.only(left: 5, right: 5),

              //
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide:
                    BorderSide(color: Colors.blue.withOpacity(1), width: 2),
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
        ),
      ),
    );
  }
}
