import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/checkauth_controller.dart';
import 'utils/api_endpoints.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/home_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/car_page.dart'; // Import the car rental page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService authController = AuthService();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Navigation',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: ApiEndPoints.registerEmail, page: () => RegisterScreen()),
        GetPage(name: ApiEndPoints.loginEmail, page: () => LoginScreen()),
        GetPage(name: ApiEndPoints.DashboardPage, page: () => DashboardPage()),
        GetPage(
            name: ApiEndPoints.home,
            page: () => CarRentalPage()), // Update the home page route
      ],
      home: FutureBuilder<bool>(
        future: authController.checkAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!) {
            return CarRentalPage(); // Set CarRentalPage for authenticated users
          } else {
            return CarRentalPage(); // Navigate to login if not authenticated
          }
        },
      ),
    );
  }
}
