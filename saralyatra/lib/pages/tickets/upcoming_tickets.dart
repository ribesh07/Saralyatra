import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saralyatra/setups.dart';

class ticketUpcoming extends StatefulWidget {
  const ticketUpcoming({super.key});

  @override
  State<ticketUpcoming> createState() => _TicketUpcomingState();
}

class _TicketUpcomingState extends State<ticketUpcoming> {
  List<Map<String, dynamic>> dataItems = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<Map<String, dynamic>> allItems = [];

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

      // Define the collections to fetch from
      List<String> collections = ['busSeat', 'package', 'reservation'];

      for (String collectionName in collections) {
        CollectionReference collection = FirebaseFirestore.instance
            .collection('history')
            .doc('upcomingHistoryDetails')
            .collection(collectionName);

        // Query for documents where userUid matches current user
        QuerySnapshot querySnapshot =
            await collection.where('userUid', isEqualTo: currentUser.uid).get();

        // Add items from this collection with collection type
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['docId'] = doc.id;
          data['type'] = collectionName;
          allItems.add(data);
        }
      }

      // Sort allItems by date in ascending order
      allItems.sort((b, a) {
        // Try to get date from multiple possible field names
        String dateA = _getFieldValue(
            a, ['date', 'bookingDate', 'travelDate', 'reservationDate']);
        String dateB = _getFieldValue(
            b, ['date', 'bookingDate', 'travelDate', 'reservationDate']);

        // Handle 'N/A' values by putting them at the end
        if (dateA == 'N/A' && dateB == 'N/A') return 0;
        if (dateA == 'N/A') return 1;
        if (dateB == 'N/A') return -1;

        // Parse dates and compare
        try {
          DateTime parsedDateA = DateTime.parse(dateA);
          DateTime parsedDateB = DateTime.parse(dateB);
          return parsedDateA.compareTo(parsedDateB);
        } catch (e) {
          // If parsing fails, do string comparison as fallback
          return dateA.compareTo(dateB);
        }
      });

      setState(() {
        dataItems = allItems;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        dataItems = [];
      });
    }
  }

  void _showDetailsDialog(Map<String, dynamic> ticketData) {
    // Get the type and create appropriate title
    String type = ticketData['type']?.toString().toUpperCase() ?? 'DETAILS';
    String title = '$type Details';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _buildAllFields(ticketData),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showCancelDialog(ticketData);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('Cancel'),
            ),
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

  List<Widget> _buildAllFields(Map<String, dynamic> data) {
    List<Widget> fields = [];

    // Add type badge first
    if (data['type'] != null) {
      fields.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: _getTypeColor(data['type']),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            data['type'].toString().toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    // Iterate through all fields and display them
    data.forEach((key, value) {
      // Skip internal fields and userUid
      if (key != 'docId' &&
          key != 'type' &&
          key != 'userUid' &&
          value != null) {
        String displayKey = _formatFieldName(key);
        String displayValue = value.toString();

        fields.add(_buildDetailRow(displayKey, displayValue));
      }
    });

    return fields;
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'busseat':
        return Colors.blue;
      case 'package':
        return Colors.green;
      case 'reservation':
        return Colors.orange;
      default:
        return Colors.grey;
    }
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
    return '${type.toUpperCase()} Booking';
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
        return Icons.confirmation_number;
    }
  }

  String _getFieldValue(
      Map<String, dynamic> data, List<String> possibleFields) {
    for (String field in possibleFields) {
      if (data[field] != null && data[field].toString().isNotEmpty) {
        return data[field].toString();
      }
    }
    return 'N/A';
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

  void _showCancelDialog(Map<String, dynamic> ticketData) {
    TextEditingController reasonController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Cancel Ticket',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Please provide a reason for cancellation:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: reasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter cancellation reason...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (reasonController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Please provide a cancellation reason'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          try {
                            await _cancelTicket(
                                ticketData, reasonController.text.trim());
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Ticket cancelled successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            _fetchData(); // Refresh the list
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error cancelling ticket: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('Confirm Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _cancelTicket(
      Map<String, dynamic> ticketData, String reason) async {
    try {
      // Create cancelled ticket data with reason and timestamp
      Map<String, dynamic> cancelledTicketData =
          Map<String, dynamic>.from(ticketData);
      cancelledTicketData['cancellationReason'] = reason;
      cancelledTicketData['cancellationDate'] =
          DateTime.now().toIso8601String();
      cancelledTicketData['originalDocId'] = ticketData['docId'];
      cancelledTicketData['status'] = 'cancelled';

      // Generate a unique ID for the cancelled ticket
      String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

      // Save to cancelled history in Firebase
      await FirebaseFirestore.instance
          .collection('history')
          .doc('cancelledHistoryDetails')
          .collection('cancelledHistory')
          .doc(uniqueId)
          .set(cancelledTicketData);

      // Remove only the specific document from upcoming tickets
      // Do NOT delete the collection (busSeat, package, reservation)
      String collectionName = ticketData['type'];
      String docId = ticketData['docId'];

      // Delete only the specific document with the unique ID
      await FirebaseFirestore.instance
          .collection('history')
          .doc('upcomingHistoryDetails')
          .collection(collectionName)
          .doc(docId)
          .delete();

      print(
          'Successfully cancelled ticket: $docId from collection: $collectionName');
    } catch (e) {
      print('Error cancelling ticket: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return dataItems.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_note_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No upcoming tickets',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your booked tickets will appear here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
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
                      // Type Badge
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: _getTypeColor(dataItems[index]['type'] ?? ''),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          (dataItems[index]['type']?.toString().toUpperCase() ??
                              'UNKNOWN'),
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),

                      // Centered Image Container
                      Center(
                        child: Container(
                          width: 200,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: listColor,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getTypeIcon(dataItems[index]['type'] ?? ''),
                                size: 40,
                                color: _getTypeColor(
                                    dataItems[index]['type'] ?? ''),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Date: ${_getFieldValue(dataItems[index], [
                                      'date',
                                      'bookingDate',
                                      'travelDate'
                                    ])}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Time: ${_getFieldValue(dataItems[index], [
                                      'departureTime',
                                      'time',
                                      'bookingTime'
                                    ])}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
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
                            _showDetailsDialog(dataItems[index]);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Details',
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
}
