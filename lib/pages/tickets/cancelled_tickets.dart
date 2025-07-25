// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/setups.dart';

class CancelledTickets extends StatefulWidget {
  const CancelledTickets({super.key});

  @override
  State<CancelledTickets> createState() => _CancelledTicketsState();
}

class _CancelledTicketsState extends State<CancelledTickets> {
  List<Map<String, dynamic>> dataItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCancelledTickets();
  }

  Future<void> _fetchCancelledTickets() async {
    try {
      // Get current user
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('No user logged in');
        setState(() {
          dataItems = [];
        });
        return;
      }

      CollectionReference collection = FirebaseFirestore.instance
          .collection('history')
          .doc('cancelledHistoryDetails')
          .collection('cancelledHistory');

      // Query for documents where userUid matches current user
      QuerySnapshot querySnapshot = await collection
          .where('userUid', isEqualTo: currentUser.uid)
          .get();

      List<Map<String, dynamic>> cancelledItems = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['docId'] = doc.id;
        cancelledItems.add(data);
      }

      // Sort by cancellation date (most recent first)
      cancelledItems.sort((a, b) {
        String dateA = a['cancellationDate'] ?? '';
        String dateB = b['cancellationDate'] ?? '';
        
        if (dateA.isEmpty && dateB.isEmpty) return 0;
        if (dateA.isEmpty) return 1;
        if (dateB.isEmpty) return -1;
        
        try {
          DateTime parsedDateA = DateTime.parse(dateA);
          DateTime parsedDateB = DateTime.parse(dateB);
          return parsedDateB.compareTo(parsedDateA); // Most recent first
        } catch (e) {
          return dateB.compareTo(dateA);
        }
      });

      setState(() {
        dataItems = cancelledItems;
      });
    } catch (e) {
      print('Error fetching cancelled tickets: $e');
      setState(() {
        dataItems = [];
      });
    }
  }
  void _showCancelledTicketDetails(Map<String, dynamic> ticketData) {
    String type = ticketData['type']?.toString().toUpperCase() ?? 'CANCELLED';
    String title = 'Cancelled $type Details';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _buildCancelledTicketFields(ticketData),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildCancelledTicketFields(Map<String, dynamic> data) {
    List<Widget> fields = [];

    // Add type badge first
    if (data['type'] != null) {
      fields.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'CANCELLED ${data['type'].toString().toUpperCase()}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    // Add cancellation info first
    if (data['cancellationReason'] != null) {
      fields.add(_buildDetailRow('Cancellation Reason', data['cancellationReason'].toString()));
    }
    
    if (data['cancellationDate'] != null) {
      try {
        DateTime cancelDate = DateTime.parse(data['cancellationDate']);
        String formattedDate = '${cancelDate.day}/${cancelDate.month}/${cancelDate.year} at ${cancelDate.hour}:${cancelDate.minute.toString().padLeft(2, '0')}';
        fields.add(_buildDetailRow('Cancelled On', formattedDate));
      } catch (e) {
        fields.add(_buildDetailRow('Cancelled On', data['cancellationDate'].toString()));
      }
    }

    fields.add(Divider(thickness: 1, color: Colors.grey[300]));
    fields.add(SizedBox(height: 8));
    fields.add(Text(
      'Original Ticket Details:',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.grey[700],
      ),
    ));
    fields.add(SizedBox(height: 8));

    // Iterate through all other fields and display them
    data.forEach((key, value) {
      // Skip internal fields, cancellation fields already shown, and userUid
      if (key != 'docId' && 
          key != 'type' && 
          key != 'cancellationReason' && 
          key != 'cancellationDate' && 
          key != 'originalDocId' && 
          key != 'userUid' && 
          value != null) {
        String displayKey = _formatFieldName(key);
        String displayValue = value.toString();

        fields.add(_buildDetailRow(displayKey, displayValue));
      }
    });

    return fields;
  }

  String _formatFieldName(String fieldName) {
    // Convert camelCase or snake_case to readable format
    String formatted = fieldName
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .replaceAll('_', ' ')
        .trim();

    // Capitalize first letter of each word
    return formatted.split(' ').map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }).join(' ') +
        ':';
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayTitle(Map<String, dynamic> data) {
    // Try different possible title fields based on type
    List<String> titleFields = [
      'location',
      'destination',
      'route',
      'packageName',
      'busName',
      'name',
      'title'
    ];

    for (String field in titleFields) {
      if (data[field] != null && data[field].toString().isNotEmpty) {
        return data[field].toString();
      }
    }

    // Fallback based on type
    String type = data['type']?.toString() ?? 'Unknown';
    return 'Cancelled ${type.toUpperCase()}';
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'busseat':
        return Icons.directions_bus;
      case 'package':
        return Icons.card_travel;
      case 'reservation':
        return Icons.book_online;
      default:
        return Icons.cancel;
    }
  }

  String _getFieldValue(Map<String, dynamic> data, List<String> possibleFields) {
    for (String field in possibleFields) {
      if (data[field] != null && data[field].toString().isNotEmpty) {
        return data[field].toString();
      }
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return dataItems.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No cancelled tickets',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: dataItems.length,
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Cancelled Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'CANCELLED ${(dataItems[index]['type']?.toString().toUpperCase() ?? 'TICKET')}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      // Centered Title
                      Text(
                        _getDisplayTitle(dataItems[index]),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),

                      // Cancellation Reason (truncated)
                      if (dataItems[index]['cancellationReason'] != null)
                        Container(
                          padding: EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reason:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.red[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                dataItems[index]['cancellationReason'].toString().length > 50
                                    ? '${dataItems[index]['cancellationReason'].toString().substring(0, 50)}...'
                                    : dataItems[index]['cancellationReason'].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 12),

                      // Centered Image Container
                      Center(
                        child: Container(
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.red[50],
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getTypeIcon(dataItems[index]['type'] ?? ''),
                                size: 32,
                                color: Colors.red,
                              ),
                              SizedBox(height: 8),
                              if (dataItems[index]['cancellationDate'] != null)
                                Text(
                                  "Cancelled: ${_formatCancellationDate(dataItems[index]['cancellationDate'])}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Details Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showCancelledTicketDetails(dataItems[index]);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  String _formatCancellationDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
