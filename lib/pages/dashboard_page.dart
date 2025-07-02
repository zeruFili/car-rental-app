import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../components/sidebar.dart';
import '../components/balance_card.dart';
import '../components/action_buttons.dart';

import '../pages/home_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _MastersfacturingDashboardPageState();
}

class _MastersfacturingDashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double _balance = 1250.75;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signOut() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      Get.offAll(() => MastersManufacturingHomePage());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully signed out'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'MASTERSFACTURING',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0A5D4A),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: AppSidebar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        onSignOut: _signOut,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeScreen(),
          _buildInnovatorsScreen(),
          _buildAIFactoryScreen(),
          _buildResourcesScreen(),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BalanceCard(balance: _balance),
          const SizedBox(height: 24),
          ActionButtons(), // Removed onAction parameter
          const SizedBox(height: 24),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInnovatorsScreen() {
    return const Center(
      child: Text('Innovators Network'),
    );
  }

  Widget _buildAIFactoryScreen() {
    return const Center(
      child: Text('AI Production Factory'),
    );
  }

  Widget _buildResourcesScreen() {
    return const Center(
      child: Text('Strategic Resources'),
    );
  }
}
