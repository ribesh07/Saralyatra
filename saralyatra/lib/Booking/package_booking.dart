import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:saralyatra/Booking/input_field.dart';
import 'package:saralyatra/Booking/provide.dart';
import 'package:saralyatra/setups.dart';

class PackageBooking extends StatefulWidget {
  final String packageTitle;
  final String? packageId;
  const PackageBooking({
    super.key,
    required this.packageTitle,
    this.packageId,
  });

  @override
  State<PackageBooking> createState() => _PackageBookingState();
}

class _PackageBookingState extends State<PackageBooking> with TickerProviderStateMixin {
  double toPay = 0.0;
  final namecontroller = TextEditingController();
  final provider = settingProvider();
  final phonecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final mailcontroller = TextEditingController();
  String tripdetails = '[details]';
  var departureDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
  String packagePrice = "0";
  bool isLoadingPrice = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fetchPackageDetails();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  Future<void> _fetchPackageDetails() async {
    try {
      if (widget.packageId != null) {
        DocumentSnapshot packageDoc = await FirebaseFirestore.instance
            .collection('history')
            .doc('upcomingHistoryDetails')
            .collection('package')
            .doc(widget.packageId!)
            .get();

        if (packageDoc.exists) {
          var data = packageDoc.data() as Map<String, dynamic>;
          setState(() {
            packagePrice = data['price']?.toString() ?? "0";
            toPay = double.tryParse(packagePrice) ?? 0.0;
            isLoadingPrice = false;
          });
        } else {
          setState(() {
            isLoadingPrice = false;
          });
        }
      } else {
        setState(() {
          isLoadingPrice = false;
        });
      }
    } catch (e) {
      print('Error fetching package details: $e');
      setState(() {
        isLoadingPrice = false;
      });
    }
  }

  Future<void> _saveBookingDetails() async {
    if (formkey.currentState!.validate()) {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to book a package'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      bool isDialogShowing = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          isDialogShowing = true;
          return PopScope(
            canPop: false,
            child: const AlertDialog(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      "Booking package...",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).then((_) {
        isDialogShowing = false;
      });

      try {
        String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

        final bookingDetails = {
          'contact': phonecontroller.text.trim(),
          'email': mailcontroller.text.trim(),
          'name': namecontroller.text.trim(),
          'packageName': widget.packageTitle,
          'reservationDate': departureDate,
          'price': packagePrice,
          'bookingDate': DateTime.now().toIso8601String(),
          'bookingTime': DateFormat('HH:mm').format(DateTime.now()),
          'userUid': currentUser.uid,
          'status': 'pending',
        };

        await FirebaseFirestore.instance
            .collection('history')
            .doc('upcomingHistoryDetails')
            .collection('package')
            .doc(uniqueId)
            .set(bookingDetails);

        if (isDialogShowing && mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          isDialogShowing = false;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Package booked successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (isDialogShowing && mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          isDialogShowing = false;
        }

        print('Error booking package: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to book package. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    namecontroller.dispose();
    phonecontroller.dispose();
    mailcontroller.dispose();
    provider.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Package Booking',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: appbarcolor,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, Colors.blue[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildTripDetailsCard(),
                      const SizedBox(height: 20),
                      _buildContactDetailsCard(),
                      const SizedBox(height: 20),
                      _buildDateCard(),
                      const SizedBox(height: 30),
                      _buildBookNowButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripDetailsCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trip Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.card_travel, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.packageTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactDetailsCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            InputField(
              icon: Icons.person_outline,
              label: "Full Name",
              keypad: TextInputType.text,
              controller: namecontroller,
              inputFormat: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                LengthLimitingTextInputFormatter(50),
              ],
              validator: (value) => provider.validator(value, "Full Name is required"),
            ),
            const SizedBox(height: 15),
            InputField(
              icon: Icons.phone_outlined,
              label: "+977 Phone Number",
              keypad: TextInputType.number,
              controller: phonecontroller,
              inputFormat: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) => provider.phoneValidator(value),
            ),
            const SizedBox(height: 15),
            InputField(
              icon: Icons.email_outlined,
              label: "Email Address",
              controller: mailcontroller,
              validator: (value) => provider.emailValidator(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Travel Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (selectedDate != null) {
                  setState(() {
                    departureDate = DateFormat("dd/MM/yyyy").format(selectedDate);
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text(
                      departureDate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookNowButton() {
    return ElevatedButton(
      onPressed: () {
        if (formkey.currentState!.validate()) {
          _saveBookingDetails();
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      child: const Text(
        'Book Now',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
