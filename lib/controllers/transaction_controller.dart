import '../apis/payment_api.dart';
import '../apis/transaction_api.dart';
import '../Model/transaction_model.dart';
import '../Model/payment_transaction-model.dart';

class TransactionsController {
  List<Transaction> transactions = [];
  List<PaymentRecord> paymentRecords = [];
  double walletBalance = 0.0;

  // Callback to notify listeners
  Function? onUpdate; // Callback to notify UI of updates

  Future<bool> fetchTransactions() async {
    final paymentApi = PaymentApi();
    try {
      final response = await paymentApi.getAllTransactions();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        paymentRecords =
            data.map((json) => PaymentRecord.fromJson(json)).toList();
        onUpdate?.call(); // Notify listeners after updating paymentRecords
        return true;
      } else {
        print('Failed to fetch transactions: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<bool> retrieveAllTransactions() async {
    final transactionApi = TransactionApi();
    try {
      final response = await transactionApi.getAllTransactions();
      if (response.statusCode == 200) {
        transactions = (response.data as List)
            .map((transaction) => Transaction.fromJson(transaction))
            .toList();
        onUpdate?.call(); // Notify listeners after updating transactions
        return true;
      } else {
        print('Failed to retrieve transactions: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<bool> updateTransactionStatus(
      String transactionId, String status) async {
    final transactionApi = TransactionApi();
    try {
      final response =
          await transactionApi.updateTransactionStatus(transactionId, status);
      print('From frontend controller: $transactionId $status');

      if (response.statusCode == 200) {
        onUpdate?.call(); // Notify listeners after the status update
        return true; // Indicate that the update was successful
      } else {
        print('Failed to update transaction status: ${response.data}');
        return false; // Indicate failure
      }
    } catch (e) {
      print('Error occurred while updating transaction status: $e');
      return false; // Return false to indicate failure
    }
  }

  Future<bool> createTransfer({
    required String description,
    required String receiverId,
    required String accountNumber,
    required String bankCode,
    required double amount,
    required String account_name,
    required String currency,
  }) async {
    final transactionApi = TransactionApi();
    try {
      final transferData = {
        'receiver': receiverId,
        'account_number': accountNumber,
        'bank_code': bankCode,
        'amount': amount,
        'account_name': account_name,
        'description': description,
        'currency': currency,
      };
      print('From controller Transfer Data: $transferData');

      final response = await transactionApi.createTransaction(transferData);
      if (response.statusCode == 201) {
        onUpdate?.call(); // Notify listeners after creating a transfer
        return true;
      } else {
        print('Failed to create transfer: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error occurred while creating transfer: $e');
      return false;
    }
  }

  Future<bool> fetchWalletBalance() async {
    final paymentApi = PaymentApi();
    try {
      final response = await paymentApi.getWalletBalance();
      if (response.statusCode == 200) {
        final balanceData = response.data['balance']['data'];
        for (var currency in balanceData) {
          if (currency['currency'] == 'ETB') {
            walletBalance = currency['available_balance'].toDouble();
            break; // Exit loop once we find ETB
          }
        }
        onUpdate?.call(); // Notify listeners after fetching wallet balance
        return true;
      } else {
        print('Failed to fetch wallet balance: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }
}
