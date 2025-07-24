// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saralyatra/Booking/provide.dart';
import 'package:saralyatra/setups.dart';

class CompletedTickets extends StatefulWidget {
  const CompletedTickets({super.key});

  @override
  State<CompletedTickets> createState() => _CompletedTicketsState();
}

class _CompletedTicketsState extends State<CompletedTickets> {
  final reviewcontroller = TextEditingController();
  final provider = settingProvider();
  final formkey = GlobalKey<FormState>();
  List<Map<String, dynamic>> dataItems = [];
  Map<String, Map<String, dynamic>> savedRatings = {};
  bool isLoading = true;
  double currentRating = 0.0;
  String? currentTicketId;

  @override
  void initState() {
    super.initState();
    _fetchCompletedTickets();
  }

  Future<void> _fetchCompletedTickets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // Try the primary query with orderBy completionDate
      QuerySnapshot querySnapshot;
      try {
        querySnapshot = await FirebaseFirestore.instance
            .collection('history/completedHistoryDetails/completedHistory')
            .where('userUid', isEqualTo: user.uid)
            .orderBy('completionDate', descending: true)
            .get();
      } catch (indexError) {
        // If ordering by completionDate fails (likely due to missing index or null values),
        // fall back to a simpler query and sort in code
        print(
            'Primary query failed, falling back to simple query: $indexError');
        querySnapshot = await FirebaseFirestore.instance
            .collection('history/completedHistoryDetails/completedHistory')
            .where('userUid', isEqualTo: user.uid)
            .get();
      }

      // Process the data and filter out documents with null/missing completionDate
      List<Map<String, dynamic>> fetchedData = querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            // Add document ID for reference if needed
            data['documentId'] = doc.id;
            return data;
          })
          .where((data) =>
              data['completionDate'] != null) // Filter out null completionDate
          .toList();

      // Sort by completionDate in code if we used the fallback query
      fetchedData.sort((a, b) {
        final aDate = a['completionDate'] as Timestamp?;
        final bDate = b['completionDate'] as Timestamp?;

        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1; // null values go to end
        if (bDate == null) return -1;

        // Descending order (most recent first)
        return bDate.compareTo(aDate);
      });

      // Fetch existing ratings for these tickets
      await _fetchExistingRatings(fetchedData, user.uid);

      setState(() {
        dataItems = fetchedData;
        isLoading = false;
      });
    } catch (e) {
      // Handle any remaining errors
      print('Error fetching completed tickets: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchExistingRatings(
      List<Map<String, dynamic>> tickets, String userUid) async {
    try {
      // Get all ratings for this user
      final ratingsSnapshot = await FirebaseFirestore.instance
          .collection('uploads')
          .doc('ratingDetails')
          .collection('rating')
          .where('userUid', isEqualTo: userUid)
          .get();

      // Create a map of ticketId -> rating data
      final ratingsMap = <String, Map<String, dynamic>>{};
      for (final doc in ratingsSnapshot.docs) {
        final data = doc.data();
        final ticketId = data['ticketId'] as String?;
        if (ticketId != null) {
          ratingsMap[ticketId] = {
            'rating': data['rating'] ?? 0.0,
            'description': data['description'] ?? '',
            'documentId': doc.id,
          };
        }
      }

      setState(() {
        savedRatings = ratingsMap;
      });
    } catch (e) {
      print('Error fetching existing ratings: $e');
    }
  }

  void _showDetailsDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ticket Details"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: _buildAllFields(item),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildAllFields(Map<String, dynamic> item) {
    List<Widget> fields = [];

    // Fields to exclude from display
    final excludeFields = {'userUid'};

    item.forEach((key, value) {
      if (!excludeFields.contains(key) && value != null) {
        String displayKey = _formatFieldName(key);
        String displayValue = _formatFieldValue(key, value);

        fields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    '$displayKey:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(displayValue),
                ),
              ],
            ),
          ),
        );
      }
    });

    return fields;
  }

  String _formatFieldName(String fieldName) {
    // Convert camelCase to readable format
    String result = fieldName.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    );

    // Capitalize first letter
    if (result.isNotEmpty) {
      result = result[0].toUpperCase() + result.substring(1);
    }

    return result.trim();
  }

  String _formatFieldValue(String key, dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toString().split('.')[0];
    }
    return value.toString();
  }

  Future<void> _saveRatingToFirebase(
      String ticketId, double rating, String description) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      // Check if a rating already exists for this ticket
      final existingRating = savedRatings[ticketId];

      String documentId;
      if (existingRating != null) {
        // Update existing rating
        documentId = existingRating['documentId'];
      } else {
        // Generate a unique ID for new rating
        documentId = DateTime.now().millisecondsSinceEpoch.toString();
      }

      // Create the rating data
      final ratingData = {
        'ticketId': ticketId,
        'description': description,
        'userUid': user.uid,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save to Firebase under the specified path
      await FirebaseFirestore.instance
          .collection('uploads')
          .doc('ratingDetails')
          .collection('rating')
          .doc(documentId)
          .set(ratingData);

      // Update local cache
      setState(() {
        savedRatings[ticketId] = {
          'rating': rating,
          'description': description,
          'documentId': documentId,
        };
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(existingRating != null
              ? 'Rating updated successfully!'
              : 'Rating and review saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the review controller
      reviewcontroller.clear();
    } catch (e) {
      print('Error saving rating: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save rating. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (dataItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              "No completed data available",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 1500.0,
      child: ListView.builder(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: dataItems.length,
        itemBuilder: (BuildContext context, int index) {
          final item = dataItems[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "COMPLETED",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (item['completionDate'] != null)
                          Text(
                            _formatFieldValue(
                                'completionDate', item['completionDate']),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      item['title']?.toString() ??
                          item['packageName']?.toString() ??
                          'Completed Ticket',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    if (item['destination'] != null)
                      Text(
                        'Destination: ${item['destination']}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => _showDetailsDialog(item),
                          child: Text(
                            "View Details",
                            style: buttonStyle,
                          ),
                        ),
                        RatingBar(
                          initialRating: savedRatings[item['documentId']]
                                      ?['rating']
                                  ?.toDouble() ??
                              0.0,
                          ratingWidget: RatingWidget(
                            full: Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            half: Icon(Icons.star_half, color: Colors.amber),
                            empty: Icon(
                              Icons.star,
                              color: Colors.grey,
                            ),
                          ),
                          onRatingUpdate: (rating) {
                            currentRating = rating;
                            currentTicketId = item['documentId'];

                            // Prefill review controller with existing review if available
                            final existingReview = savedRatings[currentTicketId]
                                    ?['description'] ??
                                '';
                            reviewcontroller.text = existingReview;

                            Future.delayed(Duration(milliseconds: 200), () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return Form(
                                    key: formkey,
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      title: Text("Write a review"),
                                      content: FittedBox(
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: reviewcontroller,
                                                maxLines: null,
                                                minLines: 8,
                                                style: TextStyle(fontSize: 25),
                                                keyboardType:
                                                    TextInputType.multiline,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      2000)
                                                ],
                                                onTapOutside: (event) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "Review",
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                      color: Colors.blue
                                                          .withOpacity(1),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                      color: Colors.red
                                                          .withOpacity(0.4),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                      color: Colors.red
                                                          .withOpacity(1),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                ),
                                                validator: (value) =>
                                                    provider.validator(
                                                  value!,
                                                  'Write review first',
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        reviewcontroller.text =
                                                            "";
                                                      });
                                                    },
                                                    child: Text(
                                                      'Discard',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Color.fromARGB(
                                                            255, 4, 80, 142),
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (formkey.currentState!
                                                          .validate()) {
                                                        // Save rating and review to Firebase
                                                        await _saveRatingToFirebase(
                                                          currentTicketId!,
                                                          currentRating,
                                                          reviewcontroller.text
                                                              .trim(),
                                                        );
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text(
                                                      'Ok',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Color.fromARGB(
                                                            255, 4, 80, 142),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                            print(rating);
                          },
                          allowHalfRating: true,
                          tapOnlyMode: true,
                          glow: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
