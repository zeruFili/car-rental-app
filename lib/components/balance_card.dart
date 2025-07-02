import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BalanceCard extends StatefulWidget {
  final double balance;

  const BalanceCard({
    super.key,
    required this.balance,
  });

  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isVisible = true; // State to track visibility

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible; // Toggle visibility
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator while fetching role
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Container(); // Handle error or null data
        }

        final String role = snapshot.data!['role'];

        // Only show the balance card if the user is an admin
        if (role != 'admin') {
          return Container(); // Do not display the card
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green, // Starting color
                Colors.blue, // Ending color
              ],
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: _toggleVisibility,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _isVisible
                    ? 'ETB ${widget.balance.toStringAsFixed(2)}'
                    : '**********', // Show asterisks when hidden
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String role = prefs.getString('role') ?? 'user';
    return {'role': role};
  }
}
