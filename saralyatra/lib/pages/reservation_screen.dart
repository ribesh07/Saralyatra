import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:saralyatra/Booking/input_field.dart';
import 'package:saralyatra/Booking/provide.dart';
import 'package:saralyatra/setups.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> with TickerProviderStateMixin {
  var _value = -1;
  final namecontroller = TextEditingController();
  final provider = settingProvider();
  final phonecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final departcontroller = TextEditingController();
  final destinationcontroller = TextEditingController();
  var departureDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Future<void> _storeReservationDetails() async {
    if (formkey.currentState!.validate()) {
      // Get current user first
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please login to make a reservation'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show loading dialog with better management
      bool isDialogShowing = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          isDialogShowing = true;
          return PopScope(
            canPop: false,
            child: AlertDialog(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      "Creating reservation...",
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
        // Get vehicle type
        String vehicleType;
        switch (_value) {
          case 1:
            vehicleType = 'Bus';
            break;
          case 2:
            vehicleType = 'Car';
            break;
          case 3:
            vehicleType = 'Jeep';
            break;
          default:
            vehicleType = 'Unknown';
        }

        // Generate a unique ID for the reservation
        String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

        final reservationDetails = {
          'name': namecontroller.text.trim(),
          'contact': phonecontroller.text.trim(),
          'email': emailcontroller.text.trim(),
          'vehicleType': vehicleType,
          'from': departcontroller.text.trim(),
          'destination': destinationcontroller.text.trim(),
          'date': departureDate,
          'bookingDate': DateTime.now().toIso8601String(),
          'bookingTime': DateFormat('HH:mm').format(DateTime.now()),
          'userUid': currentUser.uid,
          'status': 'pending', // Add status field
        };

        // Save to Firebase location: history/upcomingHistoryDetails/reservation/{uniqueId}
        await FirebaseFirestore.instance
            .collection('history')
            .doc('upcomingHistoryDetails')
            .collection('reservation')
            .doc(uniqueId)
            .set(reservationDetails);

        // Close loading dialog safely
        if (isDialogShowing && mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          isDialogShowing = false;
        }

        print('Reservation details stored successfully');
      } catch (e) {
        // Close loading dialog safely
        if (isDialogShowing && mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          isDialogShowing = false;
        }

        print('Error storing reservation details: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create reservation. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
        rethrow; // Re-throw to let the confirmation dialog handle it
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    phonecontroller.dispose();
    emailcontroller.dispose();
    departcontroller.dispose();
    destinationcontroller.dispose();
    provider.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
                      const SizedBox(height: 40),
                      _buildHeaderCard(),
                      const SizedBox(height: 20),
                      _buildContactDetailsCard(),
                      const SizedBox(height: 20),
                      _buildVehicleTypeCard(),
                      const SizedBox(height: 20),
                      _buildTripDetailsCard(),
                      const SizedBox(height: 20),
                      _buildDateCard(),
                      const SizedBox(height: 30),
                      _buildSubmitButton(),
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

  Widget _buildHeaderCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.event_seat,
              size: 40,
              color: Colors.blue[800],
            ),
            const SizedBox(height: 10),
            const Text(
              'Vehicle Reservation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Book your perfect ride',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
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
              controller: emailcontroller,
              validator: (value) => provider.emailValidator(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleTypeCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vehicle Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == -1) {
                  return "Please select a vehicle type";
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.directions_car_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              value: _value,
              onChanged: (value) {
                setState(() {
                  _value = value as int;
                });
              },
              items: const [
                DropdownMenuItem(value: -1, child: Text("--Choose Vehicle Type--")),
                DropdownMenuItem(value: 1, child: Text("🚌 Bus")),
                DropdownMenuItem(value: 2, child: Text("🚗 Car")),
                DropdownMenuItem(value: 3, child: Text("🚙 Jeep")),
              ],
            ),
          ],
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
            InputField(
              icon: Icons.location_on_outlined,
              label: "From",
              keypad: TextInputType.text,
              controller: departcontroller,
              inputFormat: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s-_]')),
                LengthLimitingTextInputFormatter(50),
              ],
              validator: (value) => provider.validator(value, "Please enter departure location"),
            ),
            const SizedBox(height: 15),
            InputField(
              icon: Icons.place_outlined,
              label: "To",
              keypad: TextInputType.text,
              controller: destinationcontroller,
              validator: (value) => provider.validator(value, "Please enter destination location"),
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

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (formkey.currentState!.validate()) {
          _showConfirmationDialog();
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
        'Submit Reservation',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            "Confirm Reservation",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to submit this reservation?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _storeReservationDetails();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Reservation created successfully! We will contact you soon.",
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } catch (e) {
                  print('Error in confirmation: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
