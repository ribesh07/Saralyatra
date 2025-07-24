import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:saralyatra/setups.dart' as pw;
import 'package:saralyatra/setups.dart';

// String busName = "Rudraksha";
// String depthr = "08";
// String deptMin = "30";
// String userName = "sushant karn";
// String trnId = "1100gd";
// String contact = "9840171036";
// String price = "100";
// String totalAmount = "2000";
// int totalSeats = 5;
// String seatNo = "l1,l2";

builPrintableData(
        String name, String date, String txn, String contact, String amount) =>
    pw.Padding(
      padding: pw.EdgeInsets.all(8),
      child: pw.Column(
        children: [
          pw.SizedBox(
            height: 10,
          ),
          pw.Text(
            'Sadak Yatra',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor(0.2, 0.2, 0.2, 0.2),
              fontSize: 20,
            ),
          ),
          pw.SizedBox(height: 30),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Name',
                  style: pw.TextStyle(
                    color: PdfColor(0.2, 0.2, 0.2, 0.2),
                    fontSize: 20,
                  ),
                ),
                pw.Text(
                  'name',
                  style: pw.TextStyle(
                    color: PdfColor(0.2, 0.2, 0.2, 0.2),
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Transaction Id',
                  style: pw.TextStyle(
                    color: PdfColor(0.2, 0.2, 0.2, 0.2),
                    fontSize: 20,
                  ),
                ),
                pw.Text(
                  'txn',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Date ',
                  style: pw.TextStyle(
                    color: PdfColor(0.2, 0.2, 0.2, 0.2),
                    fontSize: 20,
                  ),
                ),
                pw.Text(
                  'date',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Contact",
                  style: pw.TextStyle(
                    color: PdfColor(0.2, 0.2, 0.2, 0.2),
                    fontSize: 20,
                  ),
                ),
                pw.Text(
                  'contact',
                  style: pw.TextStyle(
                    color: PdfColor(0.2, 0.2, 0.2, 0.2),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Total Amount',
                  style: pw.TextStyle(
                    color: PdfColor(0.2, 0.2, 0.2, 0.2),
                    fontSize: 20,
                  ),
                ),
                pw.Text(
                  '$amount',
                  style: pw.TextStyle(
                    color: PdfColor(0.2, 0.2, 0.2, 0.2),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(
            height: 60,
          ),
          pw.Text(
            "contact us: 9844499531",
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
                fontSize: 15,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor(0.2, 0.2, 0.2, 0.2)),
          ),
          pw.SizedBox(
            height: 20,
          ),
          pw.Container(
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.rectangle,
              borderRadius: pw.BorderRadius.circular(5),
              color: PdfColor(1, 1, 0, 0),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                'Disclaimer: Customer have any query regarding the payment, please contact us at 9844499531',
                style: pw.TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
