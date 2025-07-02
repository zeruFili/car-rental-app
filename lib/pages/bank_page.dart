import 'package:flutter/material.dart';
import '../controllers/bank_controller.dart';
import 'transfer_page.dart';

class BanksPage extends StatefulWidget {
  final String userId; // Add a userId parameter
  final String fullName; // Add fullName parameter

  BanksPage(
      {required this.userId,
      required this.fullName}); // Constructor to accept userId and fullName

  @override
  _BanksPageState createState() => _BanksPageState();
}

class _BanksPageState extends State<BanksPage> {
  final BankController bankController = BankController();
  String? accountName; // Declare account_name as nullable
  bool _isLoading = true; // Track loading state
  String? _errorMessage; // Track error messages

  @override
  void initState() {
    super.initState();
    accountName = widget.fullName; // Set accountName from the passed full name
    _loadBanks(); // Load banks directly after setting accountName
  }

  Future<void> _loadBanks() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null; // Reset any previous error messages
      });

      print('Fetching banks for userId: ${widget.userId}');
      await bankController
          .fetchBanksByUserId(widget.userId)
          .timeout(const Duration(seconds: 10)); // Set timeout

      setState(() {
        _isLoading = false; // Loading complete
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Loading complete
        _errorMessage =
            'Failed to load banks. Please try again later.'; // Set error message
      });
    }
  }

  void _navigateToTransferPage(String accountNumber, String bankCode) {
    if (accountName != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransferPage(
            accountName: accountName!, // Use the passed full name
            receiverId: widget.userId,
            accountNumber: accountNumber,
            bankCode: bankCode,
            currency: 'Birr', // Set currency to Birr
          ),
        ),
      );
    } else {
      // Handle case when account_name is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account name not found.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Banks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A5D4A), // Green color
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage!,
                      style:
                          TextStyle(color: Colors.red))) // Show error message
              : bankController.banks.isEmpty
                  ? _buildEmptyState() // Call the method for the empty state
                  : ListView.builder(
                      itemCount: bankController.banks.length,
                      itemBuilder: (context, index) {
                        final bank = bankController.banks[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                                color: Color(0xFF0A5D4A), width: 1),
                          ),
                          child: ListTile(
                            title: Text(
                              bank.bankName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A5D4A),
                              ),
                            ),
                            subtitle: Text('Account: ${bank.accountNumber}'),
                            trailing: const Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF0A5D4A),
                            ),
                            onTap: () {
                              // Navigate to TransferPage with the selected bank details
                              _navigateToTransferPage(
                                bank.accountNumber,
                                bank.bankCode,
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance, // Use a relevant icon
            size: 80,
            color: const Color(0xFF0A5D4A), // Green color
          ),
          const SizedBox(height: 16),
          Text(
            'No Banks Available',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A5D4A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'It seems you don’t have any banks listed.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
