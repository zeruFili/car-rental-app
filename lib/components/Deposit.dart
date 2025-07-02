import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/deposit_controller.dart';
import '../pages/dashboard_page.dart';

class DepositPage extends StatefulWidget {
  const DepositPage({Key? key}) : super(key: key);

  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage>
    with SingleTickerProviderStateMixin {
  final DepositController depositController = DepositController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isLoading = false;
  String _selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  Future<void> handleDeposit() async {
    if (depositController.amountController.text.isEmpty) {
      _showErrorSnackBar('Please enter an amount to deposit.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool success = await depositController.depositAmount();

      if (success) {
        if (depositController.paymentUrl != null) {
          final url = depositController.paymentUrl!;
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            _showErrorSnackBar('Could not launch payment URL.');
          }
        }
        _showSuccessDialog();
      } else {
        _showErrorSnackBar('Failed to deposit. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred. Please try again later.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deposit Successful'),
          content: const Text('Your deposit has been processed successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Go to Dashboard'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    depositController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Deposit Funds', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0A5D4A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A5D4A), Color(0xFF0A3D2A)],
            ),
          ),
          child: FadeTransition(
            opacity: _animation,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Enter Deposit Amount',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller:
                                      depositController.amountController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Amount',
                                    prefixIcon: Icon(Icons.attach_money),
                                  ),
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              const SizedBox(width: 16),
                              DropdownButton<String>(
                                value: _selectedCurrency,
                                items: <String>['Birr', 'USD', 'EUR', 'GBP']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCurrency = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : handleDeposit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.white, // Replace primary with backgroundColor
                      foregroundColor: const Color(
                          0xFF0A5D4A), // Replace onPrimary with foregroundColor
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Deposit Now',
                            style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Secure payment powered by Chapa',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
