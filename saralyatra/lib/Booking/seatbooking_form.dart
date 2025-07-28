import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saralyatra/Booking/input_field.dart';
import 'package:saralyatra/Booking/provide.dart';
import 'package:saralyatra/payments/payment_options.dart';
import 'package:saralyatra/setups.dart';

class bookSeat extends StatefulWidget {
  final String busName;
  final String shift;
  final String depMin;
  final String depHr;
  final String arrMin;
  final String arrHr;
  final String price;
  final String date;
  final List selectedSeats;
  final String uniqueBusID;
  final String userID;
  final String location;

  const bookSeat({
    super.key,
    required this.busName,
    required this.shift,
    required this.depMin,
    required this.depHr,
    required this.arrMin,
    required this.arrHr,
    required this.price,
    required this.date,
    required this.selectedSeats,
    required this.uniqueBusID,
    required this.userID,
    required this.location,
  });

  @override
  State<bookSeat> createState() => _bookSeatState();
}

class _bookSeatState extends State<bookSeat> with TickerProviderStateMixin {
  var _value = -1;
  final double toPay = 0.0;
  final namecontroller = TextEditingController();
  final provider = settingProvider();
  final phonecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final mailcontroller = TextEditingController();
  final numbercontroller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Animation setup
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
    int priceD = int.parse(widget.price) * widget.selectedSeats.length;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Seat Booking',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, "reset");
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
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
                        _buildBusDetailsCard(),
                        const SizedBox(height: 20),
                        _buildContactDetailsCard(),
                        const SizedBox(height: 20),
                        _buildPickupPointCard(),
                        const SizedBox(height: 20),
                        _buildBillingCard(priceD),
                        const SizedBox(height: 30),
                        _buildPayNowButton(priceD),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusDetailsCard() {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.busName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow(Icons.event_seat, 'Shift', widget.shift),
                _buildInfoRow(Icons.access_time, 'Time',
                    '${widget.depHr}:${widget.depMin} - ${widget.arrHr}:${widget.arrMin}'),
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
            const Text('Contact Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              validator: (value) =>
                  provider.validator(value, "Full Name is required"),
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

  Widget _buildPickupPointCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pickup Point',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            DropdownButtonFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == -1) {
                  return "Please select a pickup point";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on_outlined),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              value: _value,
              onChanged: (value) {
                setState(() {
                  _value = value as int;
                });
              },
              items: const [
                DropdownMenuItem(
                    value: -1, child: Text("--Choose Pickup Point--")),
                DropdownMenuItem(value: 1, child: Text("Tinkune")),
                DropdownMenuItem(value: 2, child: Text("Gaushala")),
                DropdownMenuItem(value: 3, child: Text("Kalanki")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingCard(int priceD) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          children: [
            const Text(
              'Bill Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildBillingRow('Selected Seats', widget.selectedSeats.join(', ')),
            const SizedBox(height: 10),
            _buildBillingRow(
                'Total Seats', widget.selectedSeats.length.toString()),
            const SizedBox(height: 10),
            _buildBillingRow('Price per Seat', 'Rs. ${widget.price}'),
            const Divider(height: 20, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  'Rs. $priceD',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayNowButton(int priceD) {
    return ElevatedButton(
      onPressed: () {
        if (formkey.currentState!.validate()) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentOptions(
                userName: namecontroller.text,
                busName: widget.busName,
                deptHr: widget.depHr,
                deptMin: widget.depMin,
                contact: phonecontroller.text,
                date: widget.date,
                price: priceD.toString(),
                selectedList: widget.selectedSeats,
                email: mailcontroller.text,
                uniqueBusID: widget.uniqueBusID,
                userID: widget.userID,
                location: widget.location,
              ),
            ),
          );
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
        'Proceed to Pay',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildBillingRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, color: Colors.black54)),
        Text(value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
      ],
    );
  }
}
