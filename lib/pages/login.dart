import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../utils/api_endpoints.dart';
import './car_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF0A5D4A),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 20.0 : screenSize.width * 0.3,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Logo and Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A5D4A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.auto_graph,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'CAR RENTAL',
                      style: TextStyle(
                        color: const Color(0xFF0A5D4A),
                        fontSize: isSmallScreen ? 24 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 40),
                _buildLoginCard(isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(bool isSmallScreen) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sign In to CAR RENTAL',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
          const SizedBox(height: 8),
          Text(
            'Your journey starts with us!',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.black54,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
          SizedBox(height: isSmallScreen ? 30 : 40),
          _buildTextField(
            emailController,
            'Email or phone number',
            false,
            isSmallScreen,
            Icons.email_outlined,
          )
              .animate()
              .fadeIn(delay: 600.ms, duration: 600.ms)
              .slideX(begin: 0.2, end: 0),
          SizedBox(height: isSmallScreen ? 16 : 20),
          _buildTextField(
            passwordController,
            'Password',
            true,
            isSmallScreen,
            Icons.lock_outline,
          )
              .animate()
              .fadeIn(delay: 800.ms, duration: 600.ms)
              .slideX(begin: 0.2, end: 0),
          SizedBox(height: isSmallScreen ? 30 : 40),
          _buildLoginButton(isSmallScreen)
              .animate()
              .fadeIn(delay: 1000.ms, duration: 600.ms)
              .scale(begin: const Offset(0.95, 0.95)),
          SizedBox(height: isSmallScreen ? 20 : 24),
          _buildForgotPasswordButton(isSmallScreen)
              .animate()
              .fadeIn(delay: 1200.ms, duration: 600.ms),
          SizedBox(height: isSmallScreen ? 30 : 40),
          const Divider(thickness: 1),
          SizedBox(height: isSmallScreen ? 30 : 40),
          _buildSignUpButton(isSmallScreen)
              .animate()
              .fadeIn(delay: 1400.ms, duration: 600.ms)
              .scale(begin: const Offset(0.95, 0.95)),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    bool obscureText,
    bool isSmallScreen,
    IconData prefixIcon,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black45,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(
          prefixIcon,
          color: const Color(0xFF0A5D4A).withOpacity(0.7),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFF0A5D4A),
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isSmallScreen ? 16 : 20,
        ),
      ),
    );
  }

  Widget _buildLoginButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });

                try {
                  bool success = await loginUser(
                    emailController.text,
                    passwordController.text,
                  );

                  if (success) {
                    Get.offAll(() => CarRentalPage());
                  } else {
                    Get.snackbar(
                      'Login Failed',
                      'Please check your credentials.',
                      backgroundColor: Colors.red[100],
                      colorText: Colors.red[800],
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  }
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A5D4A),
          disabledBackgroundColor: const Color(0xFF0A5D4A).withOpacity(0.6),
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 16 : 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildForgotPasswordButton(bool isSmallScreen) {
    return TextButton(
      onPressed: () {
        // Implement forgot password functionality
      },
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF0A5D4A),
      ),
      child: Text(
        'Forgot your password?',
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : 16,
        ),
      ),
    );
  }

  Widget _buildSignUpButton(bool isSmallScreen) {
    return OutlinedButton(
      onPressed: () {
        Get.toNamed(ApiEndPoints.registerEmail);
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF0A5D4A),
        side: const BorderSide(
          color: Color(0xFF0A5D4A),
          width: 1.5,
        ),
        padding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 16 : 20,
          horizontal: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'Create New Account',
        style: TextStyle(
          fontSize: isSmallScreen ? 16 : 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
