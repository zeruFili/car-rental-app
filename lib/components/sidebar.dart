import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/transaction_detail.dart'; // Import your TransactionDetailsPage here

class AppSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onSignOut;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onSignOut,
  });

  Future<Map<String, String>> _getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = prefs.getString('name') ?? 'John Doe';
    final String email = prefs.getString('email') ?? 'john.doe@example.com';
    final String role = prefs.getString('role') ?? 'user';
    return {'name': name, 'email': email, 'role': role};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _getUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading user details'));
        }

        final userDetails = snapshot.data!;
        final nameParts = userDetails['name']!.split(' ');
        final initials = nameParts.length > 1
            ? '${nameParts.first[0]}${nameParts.last[0]}'
            : '${nameParts.first[0]}';

        return Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(userDetails['name']!),
                accountEmail: Text(userDetails['email']!),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    initials.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.blueAccent, // Change to a contrasting color
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green, // Start color
                      Colors.lightBlue, // End color
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildNavItem(
                      context,
                      index: 0,
                      title: 'Home',
                      icon: Icons.home,
                    ),
                    _buildNavItem(
                      context,
                      index: 1,
                      title: 'Transactions',
                      icon: Icons.history,
                    ),
                    if (userDetails['role'] == 'admin')
                      _buildNavItem(
                        context,
                        index: 3,
                        title: 'Wallet Management',
                        icon: Icons.account_balance_wallet,
                        onTap: () {
                          Navigator.pop(context); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionDetailsPage()),
                          );
                        },
                      ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to settings
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: const Text('Help & Support'),
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to help
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.redAccent, // Change logout button color
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      onSignOut();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required String title,
    required IconData icon,
    VoidCallback? onTap, // Make onTap optional
  }) {
    final isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.green : null, // Change selected icon color
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.green : null, // Change selected text color
        ),
      ),
      selected: isSelected,
      onTap: () {
        if (onTap != null) {
          onTap(); // Call the provided onTap function
        } else {
          onItemSelected(index);
          Navigator.pop(context);
        }
      },
    );
  }
}
