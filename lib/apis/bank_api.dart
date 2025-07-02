import 'package:dio/dio.dart';
import '../apis/base_api.dart';

class BankApi extends BaseUrl {
  Future<Response> getBanksByUserId(String userId) async {
    try {
      final response = await dio.get('bank', queryParameters: {'user': userId});
      print('Response data from the bankapi:  $userId');
      return response; // Return the response for further handling
    } catch (e) {
      throw Exception('Failed to fetch bank records: $e');
    }
  }
}
