import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditDriverEmail extends StatefulWidget {
  const EditDriverEmail({super.key});

  @override
  State<EditDriverEmail> createState() => _EditDriverEmailState();
}

class _EditDriverEmailState extends State<EditDriverEmail> {
  bool passwordObsecured = true;

  // final newEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final drivernameController = TextEditingController();

  Future<void> _authenticateAndUpdate() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Driver is not logged in')),
      );
      return;
    }

    try {
      DocumentSnapshot driverDoc = await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('drivers')
          .doc(uid)
          .get();

      if (!driverDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Driver not found')),
        );
        return;
      }

      // String email = driverDoc['email'];

      // var credential = EmailAuthProvider.credential(
      // email: email, password: passwordController.text);

      // await currentUser?.reauthenticateWithCredential(credential);
      // await currentUser?.verifyBeforeUpdateEmail(newEmailController.text);
      // await currentUser?.updateEmail(newEmailController.text);

      await FirebaseFirestore.instance
          .collection('saralyatra')
          .doc('driverDetailsDatabase')
          .collection('drivers')
          .doc(uid)
          .update({
        'drivername': drivernameController.text,
        // 'email': newEmailController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Driver details updated successfully')),
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    // newEmailController.dispose();
    passwordController.dispose();
    drivernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Edit Driver Details'),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                TextField(
                  controller: drivernameController,
                  decoration: InputDecoration(
                    labelText: 'Driver Name',
                  ),
                ),
                // TextField(
                //   controller: newEmailController,
                //   decoration: InputDecoration(
                //     labelText: 'New Email',
                //   ),
                //   keyboardType: TextInputType.emailAddress,
                // ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordObsecured = !passwordObsecured;
                        });
                      },
                      icon: Icon(
                        passwordObsecured
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  obscureText: passwordObsecured,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          _authenticateAndUpdate();
                        }
                      },
                      child: Text('Save Changes'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
