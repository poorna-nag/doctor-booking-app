import 'package:flutter/material.dart';

class InstaMojoPaymentWebViewFood extends StatelessWidget {
  final String url;
  final String amount;
  final String email;
  final String name;
  final String mobile;
  final String invoice;
  final String address;
  final String pincode;
  final String city;
  final String deliveryfee;
  final String coupancode;
  final String difference;
  final String onedayprice;
  final List<dynamic> prodctlist1;

  const InstaMojoPaymentWebViewFood({
    super.key,
    required this.url,
    required this.amount,
    required this.email,
    required this.name,
    required this.mobile,
    required this.invoice,
    required this.address,
    required this.pincode,
    required this.city,
    required this.deliveryfee,
    required this.coupancode,
    required this.difference,
    required this.onedayprice,
    required this.prodctlist1,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: const Color(0xFF1E88E5),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.payments_outlined, size: 72, color: Color(0xFF1E88E5)),
              const SizedBox(height: 16),
              const Text(
                'Payment webview is disabled in this simplified build.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Amount: $amount',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
