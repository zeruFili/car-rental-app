import 'package:flutter/material.dart';
import '../controllers/transaction_controller.dart';
import '../model/banklist_model.dart';

class TransactionDetailsPage extends StatefulWidget {
  const TransactionDetailsPage({super.key});

  @override
  State<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  final TransactionsController transactionController = TransactionsController();
  String? selectedStatus;
  bool _isLoading = true;
  String _searchQuery = '';
  String _statusFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    await transactionController.retrieveAllTransactions();

    setState(() {
      _isLoading = false;
    });
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  String getBankName(String bankCode) {
    int bankId = int.tryParse(bankCode) ?? -1;
    return bankList
        .firstWhere((bank) => bank.id == bankId,
            orElse: () => Bank(id: -1, name: 'Unknown'))
        .name;
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showTransactionDetails(BuildContext context, dynamic transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white, // Changed to white
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.green, // Changed to green
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            getStatusColor(transaction.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        transaction.status,
                        style: TextStyle(
                          color: getStatusColor(transaction.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDetailRow(
                  context,
                  'Amount',
                  '${transaction.amount} ${transaction.currency}',
                  Icons.attach_money,
                ),
                _buildDetailRow(
                  context,
                  'Sender',
                  '${transaction.sender?.firstName ?? 'Unknown'} ${transaction.sender?.lastName ?? ''}',
                  Icons.person_outline,
                ),
                _buildDetailRow(
                  context,
                  'Receiver',
                  '${transaction.receiver?.firstName ?? 'Unknown'} ${transaction.receiver?.lastName ?? ''}',
                  Icons.person,
                ),
                _buildDetailRow(
                  context,
                  'Description',
                  transaction.description,
                  Icons.description_outlined,
                ),
                _buildDetailRow(
                  context,
                  'Date',
                  formatDate(transaction.createdAt),
                  Icons.calendar_today,
                ),
                _buildDetailRow(
                  context,
                  'Account Name',
                  transaction.accountName,
                  Icons.account_box_outlined,
                ),
                _buildDetailRow(
                  context,
                  'Account Number',
                  transaction.accountNumber,
                  Icons.account_balance_outlined,
                ),
                _buildDetailRow(
                  context,
                  'Bank Name',
                  getBankName(transaction.bankCode),
                  Icons.account_balance,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        selectedStatus = transaction.status;
                        _showEditStatusDialog(context, transaction.id);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green, // Changed to green
                      ),
                      child: const Text('Edit Status'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Changed to green
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1), // Changed to green
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.green, // Changed to green
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditStatusDialog(BuildContext context, String transactionId) {
    final List<String> statusOptions = ['rejected', 'accepted', 'pending'];
    String? selectedStatus;

    final transactionToUpdate = transactionController.transactions
        .firstWhere((transaction) => transaction.id == transactionId);

    if (transactionToUpdate.status.toLowerCase() == 'accepted') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot change the status of an accepted transaction.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, // Changed to white
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Change Transaction Status',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green, // Changed to green
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...statusOptions
                        .map((status) => RadioListTile<String>(
                              title: Text(
                                status.substring(0, 1).toUpperCase() +
                                    status.substring(1),
                                style: TextStyle(
                                  color: getStatusColor(status),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              value: status,
                              groupValue: selectedStatus,
                              activeColor: getStatusColor(status),
                              onChanged: (value) {
                                setDialogState(() {
                                  selectedStatus = value;
                                });
                              },
                            ))
                        .toList(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: selectedStatus == null
                              ? null
                              : () async {
                                  await transactionController
                                      .updateTransactionStatus(
                                          transactionId, selectedStatus!);

                                  _loadTransactions();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Status updated successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  Navigator.of(context).pop();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Changed to green
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            disabledBackgroundColor: Colors.grey[300],
                          ),
                          child: const Text('Update Status'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<dynamic> _getFilteredTransactions() {
    return transactionController.transactions.where((transaction) {
      if (_statusFilter != 'All' &&
          transaction.status.toLowerCase() != _statusFilter.toLowerCase()) {
        return false;
      }

      if (_searchQuery.isEmpty) {
        return true;
      }

      final query = _searchQuery.toLowerCase();
      final senderName =
          '${transaction.sender?.firstName ?? ''} ${transaction.sender?.lastName ?? ''}'
              .toLowerCase();
      final receiverName =
          '${transaction.receiver?.firstName ?? ''} ${transaction.receiver?.lastName ?? ''}'
              .toLowerCase();

      return transaction.amount.toString().contains(query) ||
          transaction.status.toLowerCase().contains(query) ||
          senderName.contains(query) ||
          receiverName.contains(query) ||
          transaction.description.toLowerCase().contains(query) ||
          transaction.accountName.toLowerCase().contains(query) ||
          transaction.accountNumber.toLowerCase().contains(query) ||
          getBankName(transaction.bankCode).toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = _getFilteredTransactions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: Colors.green, // Changed to green
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green, // Changed to green
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search transactions...',
                          hintStyle: const TextStyle(color: Colors.white70),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('All'),
                            _buildFilterChip('Accepted'),
                            _buildFilterChip('Pending'),
                            _buildFilterChip('Rejected'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredTransactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No transactions found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = filteredTransactions[index];
                            return _buildTransactionCard(context, transaction);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadTransactions,
        backgroundColor: Colors.green, // Changed to green
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _statusFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _statusFilter = selected ? label : 'All';
          });
        },
        backgroundColor: Colors.white.withOpacity(0.2),
        selectedColor: Colors.green, // Changed to green
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.green, // Adapted colors
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, dynamic transaction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showTransactionDetails(context, transaction),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${transaction.sender?.firstName ?? 'Unknown'} ${transaction.sender?.lastName ?? ''} → ${transaction.receiver?.firstName ?? 'Unknown'} ${transaction.receiver?.lastName ?? ''}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatDate(transaction.createdAt),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          getStatusColor(transaction.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      transaction.status,
                      style: TextStyle(
                        color: getStatusColor(transaction.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${transaction.amount} ${transaction.currency}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.green, // Changed to green
                        onPressed: () {
                          selectedStatus = transaction.status;
                          _showEditStatusDialog(context, transaction.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        color: Colors.green, // Changed to green
                        onPressed: () =>
                            _showTransactionDetails(context, transaction),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Description: ${transaction.description}',
                style: const TextStyle(
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
