// // ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/pages/setups/snackbar_message.dart';
import 'package:saralyatra/pages/tickets/generate_localpaymenthistory.dart';
import 'package:saralyatra/routes/app_route.dart';
import 'package:saralyatra/services/shared_pref.dart';

const String kEsewaClientId =
    'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R';
const String kEsewaSecretKey = 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==';

class Esewalocal {
  Future<void> _addPaymentInDatabase(
    String userName,
    String txnRefId,
    String contact,
    String date,
    String price,
    String email,
    String userID,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentReference = firestore
        .collection('saralyatra')
        .doc('paymentDetails')
        .collection('userLocalPaymentHistory')
        .doc('$userID');

    final paymentData = {
      'userName': userName,
      'txnRefId': txnRefId,
      'contact': contact,
      'date': date,
      'price': price,
      'timestamp': FieldValue.serverTimestamp(),
      'userID': userID,
    };
    print('Adding payment data to the database: $paymentData');
    try {
      await documentReference.set(paymentData);
      print('Payment data added to the database successfully');
    } catch (e) {
      print('Error adding payment data to the database: $e');
    }
  }

  Future<void> _addUserInDatabase(
    String userName,
    String txnRefId,
    String contact,
    String date,
    String price,
    String email,
    String userID,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentReference = firestore
        .collection('saralyatra')
        .doc('userDetailsDatabase')
        .collection('users')
        .doc('$userID');

    // final paymentData = {
    //   'userName': userName,
    //   'txnRefId': txnRefId,
    //   'contact': contact,
    //   'date': date,
    //   'price': price,
    //   'timestamp': FieldValue.serverTimestamp(),

    // };

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('saralyatra')
        .doc('userDetailsDatabase')
        .collection('users')
        .doc('$userID')
        .get();
    // print('Current balance: $balance');

    try {
      var balancer = snapshot['balance'] ?? '0.00';
      balancer =
          (double.parse(balancer!) + double.parse(price)).toStringAsFixed(2);
      print('Updated balance: $balancer');
      await documentReference.update({'balance': balancer});
      print('User payment data added to the database successfully');
    } catch (e) {
      print('Error adding user payment data to the database: $e');
    }
  }

  void pay(
    BuildContext context,
    String price,
    String userName,
    String contact,
    String date,
    String email,
    String userID,
  ) {
    print('Price: $price');
    try {
      final parsedPrice =
          double.tryParse(price) ?? 100.0; // Default to 100 if parsing fails
      final formattedPrice = parsedPrice.toStringAsFixed(2);

      print("Starting payment...");
      print("Price: $formattedPrice");

      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: kEsewaClientId,
          secretId: kEsewaSecretKey,
        ),
        esewaPayment: EsewaPayment(
          productId: "BUS_TICKET_01",
          productName: "BusTicket", // Use a clean name
          productPrice: formattedPrice,
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult result) async {
          debugPrint('Payment SUCCESS');
          String txnRefId = result.refId;

          await _addPaymentInDatabase(
            userName,
            txnRefId,
            contact,
            date,
            formattedPrice,
            email,
            userID,
          );

          await _addUserInDatabase(
            userName,
            txnRefId,
            contact,
            date,
            formattedPrice,
            email,
            userID,
          );

          showSnackBarMsg(
            context: context,
            message: 'Payment success.',
            bgColor: Colors.green,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => generateTicket(
                userName: userName,
                txnRefId: txnRefId,
                contact: contact,
                date: date,
                price: formattedPrice,
                userID: userID,
              ),
            ),
          );

          verify(result);
        },
        onPaymentFailure: () {
          debugPrint('Payment FAILURE');
          showSnackBarMsg(
            context: context,
            message: 'Failed to pay.',
            bgColor: Colors.red,
          );
        },
        onPaymentCancellation: () {
          debugPrint('Payment CANCELLED');
          showSnackBarMsg(
            context: context,
            message: 'Canceled to payment proceed.',
            bgColor: Colors.pink,
          );
          Navigator.pushNamed(context, AppRoute.homeRoute);
        },
      );
    } catch (e) {
      debugPrint('EXCEPTION during payment: $e');
      showSnackBarMsg(
        context: context,
        message: 'Something went wrong during payment.',
        bgColor: Colors.red,
      );
    }
  }

  void verify(EsewaPaymentSuccessResult result) async {
    try {
      Dio dio = Dio();
      String basicAuth =
          'Basic ${base64.encode(utf8.encode('$kEsewaClientId:$kEsewaSecretKey'))}';
      Response response = await dio.get(
        'https://esewa.com.np/mobile/transaction',
        queryParameters: {'txnRefId': result.refId},
        options: Options(headers: {'Authorization': basicAuth}),
      );
      print('Verification response: ${response.data}');
    } catch (e) {
      print('Verification error: $e');
    }
  }
}
