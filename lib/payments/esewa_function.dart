//

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/pages/setups/snackbar_message.dart';
import 'package:saralyatra/pages/tickets/generate_ticket.dart';
import 'package:saralyatra/routes/app_route.dart';

const String kEsewaClientId =
    'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R';
const String kEsewaSecretKey = 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==';

class Esewa {
  Future<void> _addPaymentInDatabase(
    String userName,
    String busName,
    String deptHr,
    String deptMin,
    String txnRefId,
    String contact,
    String date,
    String price,
    List selectedList,
    String email,
    String uniqueBusID,
    String userID,
    String location,
  ) async {
    // double price = 100.0;
    // String productId = "1d71jd81";
    // String productName = "Product One";

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference documentReference = firestore
        .collection('saralyatra')
        .doc('paymentDetails')
        .collection('forAdmin')
        .doc('$uniqueBusID$date');

    String departureTime = "$deptHr : $deptMin";

    final paymentData = {
      'userName': userName,
      'busName': busName,
      'departureTime': departureTime,
      'txnRefId': txnRefId,
      'contact': contact,
      'date': date,
      'price': price,
      'selectedList': selectedList,
      'timestamp': FieldValue.serverTimestamp(),
      'uniqueBusID': uniqueBusID,
      'userID': userID,
      'location': location
    };

    try {
      await documentReference.set(paymentData);
      print('Payment data added to the database successfully');
    } catch (e) {
      print('Error adding payment data to the database: $e');
    }
  }

  Future<void> _addUserInDatabase(
    String userName,
    String busName,
    String deptHr,
    String deptMin,
    String txnRefId,
    String contact,
    String date,
    String price,
    List selectedList,
    String email,
    String uniqueBusID,
    String userID,
    String location,
  ) async {
    // double price = 100.0;
    // String productId = "1d71jd81";
    // String productName = "Product One";

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference documentReference = firestore
        .collection('saralyatra')
        .doc('paymentDetails')
        .collection('forUser')
        .doc('$userID$date');

    String departureTime = "$deptHr : $deptMin";

    final paymentData = {
      'userName': userName,
      'busName': busName,
      'departureTime': departureTime,
      'txnRefId': txnRefId,
      'contact': contact,
      'date': date,
      'price': price,
      'selectedList': selectedList,
      'timestamp': FieldValue.serverTimestamp(),
      'uniqueBusID': uniqueBusID,
      'userID': userID,
      'location': location
    };

    try {
      await documentReference.set(paymentData);
      print('Payment data added to the database successfully');
    } catch (e) {
      print('Error adding payment data to the database: $e');
    }
  }

  // pay(BuildContext context, String price) {
  pay(
    BuildContext context,
    String price,
    String userName,
    String busName,
    String deptHr,
    String deptMin,
    String contact,
    String date,
    List selectedList,
    String email,
    String uniqueBusID,
    String userID,
    String location,
  ) {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: kEsewaClientId,
          secretId: kEsewaSecretKey,
        ),
        esewaPayment: EsewaPayment(
          productId: "1d71jd81",
          productName: "Product One",
          productPrice: price,
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult result) async {
          debugPrint('SUCCESS');
          String txnRefId = result.refId;
          // String userName,String busName,String deptHr,String deptMin,String txnRefId, String contact,String date, String price,List selectedList
          _addPaymentInDatabase(
              userName,
              busName,
              deptHr,
              deptMin,
              txnRefId,
              contact,
              date,
              price,
              selectedList,
              email,
              uniqueBusID,
              userID,
              location);
          _addUserInDatabase(
              userName,
              busName,
              deptHr,
              deptMin,
              txnRefId,
              contact,
              date,
              price,
              selectedList,
              email,
              uniqueBusID,
              userID,
              location);
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
                busName: busName,
                deptHr: deptHr,
                deptMin: deptMin,
                txnRefId: txnRefId,
                contact: contact,
                date: date,
                price: price,
                selectedList: selectedList,
                uniqueBusID: uniqueBusID,
                userID: userID,
              ),
            ),
          );
          verify(result);
        },
        onPaymentFailure: () {
          debugPrint('FAILURE');
          showSnackBarMsg(
            context: context,
            message: 'Failed to pay.',
            bgColor: Colors.red,
          );
        },
        // onPaymentCancellation: () {
        //   debugPrint('CANCEL');
        //   showSnackBarMsg(
        //     context: context,
        //     message: 'Canceled to payment proceed.',
        //     bgColor: Colors.pink,
        //   );
        //   Navigator.pushNamed(context, AppRoute.homeRoute);
        // },
        onPaymentCancellation: () {
          debugPrint('CANCEL');
          showSnackBarMsg(
            context: context,
            message: 'Canceled to payment proceed.',
            bgColor: Colors.pink,
          );
          // Log additional information here if needed
          Navigator.pushNamed(context, AppRoute.homeRoute);
        },
      );
    } catch (e) {
      debugPrint('EXCEPTION: $e');
    }
  }

//   verify(EsewaPaymentSuccessResult result) async {
//     try {
//       Dio dio = Dio();
//       String basic =
//           'Basic ${base64.encode(utf8.encode('$kEsewaClientId:$kEsewaSecretKey'))}';
//       Response response = await dio.get(
//         'https://esewa.com.np/mobile/transaction',
//         queryParameters: {
//           'txnRefId': result.refId,
//         },
//         options: Options(
//           headers: {
//             'Authorization': basic,
//           },
//         ),
//       );
//       print('Verification response: ${response.data}');
//     } catch (e) {
//       print('Verification error: $e');
//     }
//   }
// }

  verify(EsewaPaymentSuccessResult result) async {
    try {
      Dio dio = Dio();
      String basic =
          'Basic ${base64.encode(utf8.encode('$kEsewaClientId:$kEsewaSecretKey'))}';
      Response response = await dio.get(
        'https://esewa.com.np/mobile/transaction',
        queryParameters: {
          'txnRefId': result.refId,
        },
        options: Options(
          headers: {
            'Authorization': basic,
          },
        ),
      );
      print('Verification response: ${response.data}');
      // Add additional checks on response data if needed
    } catch (e) {
      print('Verification error: $e');
      // You could notify the user about the verification failure
    }
  }
}
