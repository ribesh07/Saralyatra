import 'package:flutter/material.dart';

void showSnackBarMsg({
  required BuildContext context,
  required String message,
  required Color bgColor,
}) {
  final snackbar = SnackBar(
      backgroundColor: bgColor,
      duration: const Duration(milliseconds: 5000),
      elevation: 0,
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ));

  ScaffoldMessenger.of(context)
      // ..hideCurrentSnackBar()
      .showSnackBar(snackbar);
}
