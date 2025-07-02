import 'package:dio/dio.dart';
import '../apis/base_api.dart';

class TransactionApi extends BaseUrl {
  Future<Response> createTransaction(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('transaction', data: data);
      return response; // Return the response for further handling
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  Future<Response> getAllTransactions() async {
    try {
      final response = await dio.get('transaction');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch transaction: $e');
    }
  }

  Future<Response> updateTransactionStatus(
      String transactionId, String status) async {
    try {
      final data = {'status': status};
      final response =
          await dio.patch('transaction/$transactionId', data: data);
      return response;
    } catch (e) {
      throw Exception('Failed to update transaction status: $e');
    }
  }
}
