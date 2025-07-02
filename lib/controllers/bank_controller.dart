import '../apis/bank_api.dart';
import '../Model/user_bank_model.dart'; // Ensure the import path is correct

class BankController {
  List<Bank> banks = []; // List of banks

  Future<bool> fetchBanksByUserId(String userId) async {
    final bankApi = BankApi();
    try {
      // Pass the userId directly
      final response = await bankApi.getBanksByUserId(userId);
      if (response.statusCode == 200) {
        // Parse the bank data into Bank objects
        banks = (response.data['banks'] as List)
            .map((bankJson) => Bank.fromJson(bankJson))
            .toList();
        return true;
      } else {
        print('Failed to fetch banks: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }
}
