import 'package:shared_preferences/shared_preferences.dart';
import '../apis/login_api.dart';

Future<bool> loginUser(String email, String password) async {
  final loginApi = LoginApis();

  // Prepare the data to be sent
  var data = {
    'email': email,
    'password': password,
  };

  try {
    // Call the login method from LoginApis
    final response = await loginApi.login(data);

    if (response.statusCode == 200) {
      final String token = response.data['token'];
      final user = response.data; // Adjusted to directly use response.data

      final String name = '${user['first_name']} ${user['last_name']}';

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('name', name); // Store concatenated name
      await prefs.setString('email', user['email']); // Store email
      await prefs.setString('role', user['role']);
      await prefs.setString('user_id', user['_id']);
      return true;
    } else {
      // Handle error
      print('Failed to login: ${response.data}');
      return false; // Indicate failure
    }
  } catch (e) {
    print('Error during login: $e');
    return false;
  }
}
