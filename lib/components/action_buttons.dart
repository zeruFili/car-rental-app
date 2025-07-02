import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure you import this
import 'Deposit.dart'; // Import the DepositPage
import 'transaction.dart';
import '../pages/user_page.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserRole(), // Fetch the user role asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while fetching
        }

        final String role = snapshot.data ?? 'user';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.add,
                  label: 'Deposit',
                  color: Colors.green,
                  onTap: () => _navigateToDepositPage(context),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.send, // Icon for Transfer Money
                  label: 'Transfer Money',
                  color: Colors.blue, // Change color as needed
                  onTap: () => _navigateToTransferPage(context),
                ),
                if (role == 'admin') // Check if the role is admin
                  _buildActionButton(
                    context,
                    icon: Icons.receipt_long,
                    label: 'Transactions',
                    color: Colors.purple,
                    onTap: () => _navigateToTransactionsPage(context),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<String> _getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role') ?? 'user';
  }

  void _navigateToDepositPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DepositPage()),
    );
  }

  void _navigateToTransferPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              UsersPage()), // Navigate to UsersPage for transfer
    );
  }

  void _navigateToTransactionsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionsPage()),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
