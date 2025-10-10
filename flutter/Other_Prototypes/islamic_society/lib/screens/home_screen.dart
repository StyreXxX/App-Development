import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  final _amountController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _repaymentPeriodController = TextEditingController();
  bool _isLoading = false;
  final String contactNumber = "+880-1234-567890"; // Replace with actual number

  // Simulate bKash payment
  Future<bool> _simulateBkashPayment(double amount) async {
    // In a real app, integrate bKash Merchant API here
    await Future.delayed(Duration(seconds: 2)); // Simulate API call
    return true; // Mock successful payment
  }

  // Deposit money
  Future<void> _depositMoney() async {
    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    setState(() => _isLoading = true);
    try {
      bool paymentSuccess = await _simulateBkashPayment(amount);
      if (paymentSuccess) {
        await _firestore.collection('users').doc(user!.uid).update({
          'depositedAmount': FieldValue.increment(amount),
        });
        Get.snackbar('Success', 'Deposited $amount BDT successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        _amountController.clear();
      } else {
        Get.snackbar('Error', 'Payment failed',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to deposit: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    setState(() => _isLoading = false);
  }

  // Request loan
  Future<void> _requestLoan(double depositedAmount, DateTime membershipStart) async {
    double? loanAmount = double.tryParse(_loanAmountController.text);
    int? repaymentPeriod = int.tryParse(_repaymentPeriodController.text);
    if (loanAmount == null || loanAmount <= 0 || repaymentPeriod == null || repaymentPeriod <= 0) {
      Get.snackbar('Error', 'Please enter valid loan amount and repayment period',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    DateTime now = DateTime.now();
    DateTime sixMonthsAfterStart = membershipStart.add(Duration(days: 180));
    if (now.isBefore(sixMonthsAfterStart)) {
      Get.snackbar('Error', 'Loans are available after 6 months of membership',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (loanAmount > depositedAmount) {
      Get.snackbar('Error', 'Loan amount cannot exceed deposited amount',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (loanAmount > depositedAmount * 0.5) {
      Get.snackbar('Error', 'Loan exceeds 50% of deposited amount. Contact $contactNumber',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _firestore.collection('users').doc(user!.uid).collection('loans').add({
        'amount': loanAmount,
        'repaymentPeriodMonths': repaymentPeriod,
        'requestedAt': Timestamp.now(),
      });
      Get.snackbar('Success', 'Loan of $loanAmount BDT requested for $repaymentPeriod months',
          backgroundColor: Colors.green, colorText: Colors.white);
      _loanAmountController.clear();
      _repaymentPeriodController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to request loan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    setState(() => _isLoading = false);
  }

  // Show deposit dialog
  void _showDepositDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        title: Text(
          'Deposit Money',
          style: GoogleFonts.amiri(
            fontSize: 24,
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: _amountController,
          decoration: InputDecoration(
            hintText: 'Enter amount (BDT)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.amiri(color: Color(0xFF1B5E20)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _depositMoney();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFD700),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Deposit via bKash',
              style: GoogleFonts.amiri(
                color: Color(0xFF1B5E20),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show loan dialog
  void _showLoanDialog(double depositedAmount, DateTime membershipStart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        title: Text(
          'Request Loan',
          style: GoogleFonts.amiri(
            fontSize: 24,
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _loanAmountController,
              decoration: InputDecoration(
                hintText: 'Enter loan amount (BDT)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _repaymentPeriodController,
              decoration: InputDecoration(
                hintText: 'Repayment period (months)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.amiri(color: Color(0xFF1B5E20)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _requestLoan(depositedAmount, membershipStart);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFD700),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Request Loan',
              style: GoogleFonts.amiri(
                color: Color(0xFF1B5E20),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('users').doc(user!.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading data',
                    style: GoogleFonts.amiri(
                      fontSize: 20,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: SpinKitCircle(color: Color(0xFFFFD700)));
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>;
              double depositedAmount = (userData['depositedAmount'] ?? 0.0).toDouble();
              Timestamp membershipStartTs = userData['membershipStart'] ?? Timestamp.now();
              DateTime membershipStart = membershipStartTs.toDate();
              DateTime now = DateTime.now();
              DateTime oneYearAfterStart = membershipStart.add(Duration(days: 365));
              bool canWithdraw = now.isAfter(oneYearAfterStart);

              return Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_border, size: 80, color: Color(0xFFFFD700)),
                    SizedBox(height: 20),
                    Text(
                      'Welcome to Islamic Society',
                      style: GoogleFonts.amiri(
                        fontSize: 28,
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Hello, ${user?.email ?? "User"}!',
                      style: GoogleFonts.amiri(
                        fontSize: 20,
                        color: Color(0xFFFFD700),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Deposited Amount: ${depositedAmount.toStringAsFixed(2)} BDT',
                      style: GoogleFonts.amiri(
                        fontSize: 18,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      canWithdraw
                          ? 'Your funds are ready to be withdrawn!'
                          : 'Funds available for withdrawal after ${DateFormat.yMMMd().format(oneYearAfterStart)}',
                      style: GoogleFonts.amiri(
                        fontSize: 16,
                        color: Color(0xFFFFD700),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    _isLoading
                        ? SpinKitCircle(color: Color(0xFFFFD700))
                        : Column(
                            children: [
                              ElevatedButton(
                                onPressed: _showDepositDialog,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFFD700),
                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Deposit Money',
                                  style: GoogleFonts.amiri(
                                    fontSize: 18,
                                    color: Color(0xFF1B5E20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () => _showLoanDialog(depositedAmount, membershipStart),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFFD700),
                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Request Loan',
                                  style: GoogleFonts.amiri(
                                    fontSize: 18,
                                    color: Color(0xFF1B5E20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Get.offAllNamed('/login');
                                  Get.snackbar('Success', 'Signed out successfully',
                                      backgroundColor: Colors.green, colorText: Colors.white);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFFD700),
                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Sign Out',
                                  style: GoogleFonts.amiri(
                                    fontSize: 18,
                                    color: Color(0xFF1B5E20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}