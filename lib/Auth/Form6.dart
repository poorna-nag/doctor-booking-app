import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ecoshine24/Auth/signup.dart';
import 'package:ecoshine24/Auth/signin.dart';
import 'package:ecoshine24/Auth/widgets/custom_shape.dart';
import 'package:ecoshine24/Auth/widgets/responsive_ui.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/model/RegisterModel.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Form6 extends StatefulWidget {
  final String? initialMobile;

  const Form6({Key? key, this.initialMobile}) : super(key: key);

  @override
  _Form6State createState() => _Form6State();
}

class _Form6State extends State<Form6> with TickerProviderStateMixin {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String result = "";
  String currentText = "";
  bool isOtpSent = false;
  bool isLoading = false;
  bool isVerifying = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  double? _height;
  double? _width;
  double? _pixelRatio;
  bool _large = false;
  bool _medium = false;

  @override
  void initState() {
    super.initState();

    // Pre-fill phone number if provided
    if (widget.initialMobile != null && widget.initialMobile!.isNotEmpty) {
      phoneController.text = widget.initialMobile!;
    }

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  // Country selection removed; always use plain mobile number

  Future<void> sendOtp() async {
    if (phoneController.text.length != 10) {
      _showToast("Please enter a valid 10-digit mobile number");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Make actual API call to step1.php
      var map = new Map<String, dynamic>();
      map['shop_id'] = GroceryAppConstant.Shop_id;
      map['name'] = "User"; // Default name as per API spec
      map['mobile'] = phoneController.text;

      final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'api/step1.php'),
        body: map,
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        // Check if success is true before proceeding
        if (jsonBody['success'] == "true") {
          setState(() {
            isOtpSent = true;
            isLoading = false;
          });

          _showToast(jsonBody['message'] ?? "OTP sent successfully");
        } else {
          // Show error message from API
          setState(() {
            isLoading = false;
          });
          _showToast(jsonBody['message'] ?? "Failed to send OTP");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        _showToast("Network error. Please try again.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showToast("Failed to send OTP. Please try again.");
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length != 5) {
      _showToast("Please enter a valid 5-digit OTP");
      return;
    }

    setState(() {
      isVerifying = true;
    });

    try {
      // Make actual API call to step2.php
      var map = new Map<String, dynamic>();
      map['shop_id'] = GroceryAppConstant.Shop_id;
      map['otp'] = otpController.text;
      map['mobile'] = phoneController.text;

      final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'api/step2.php'),
        body: map,
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        // Check if success is true before proceeding
        if (jsonBody['success'] == "true") {
          setState(() {
            isVerifying = false;
          });

          _showToast(jsonBody['message'] ?? "OTP verified successfully");

          // Save mobile number to SharedPreferences for signup form
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("temp_mobile", phoneController.text);

          // Navigate to signup form (step 3) to collect user details
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()),
          );
        } else {
          // Show error message from API
          setState(() {
            isVerifying = false;
          });
          _showToast(jsonBody['message'] ?? "Invalid OTP");
        }
      } else {
        setState(() {
          isVerifying = false;
        });
        _showToast("Network error. Please try again.");
      }
    } catch (e) {
      setState(() {
        isVerifying = false;
      });
      _showToast("Invalid OTP. Please try again.");
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(
            255, 66, 147, 227), // Orange from eco-shine theme
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);

    return Scaffold(
      backgroundColor: GroceryAppColors.lightBlueBg, // Light blue background
      body: SafeArea(
        child: Column(
          children: [
            // Top section with dark green background
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff1E88E5), // Medical blue from logo
                      Color(0xff42A5F5), // Lighter medical blue
                      Color(0xff64B5F6), // Even lighter medical blue
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative elements
                    Positioned(
                      top: 20,
                      right: -30,
                      child: AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value * 0.15,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: -40,
                      child: AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value * 0.1,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 2),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Content
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Back button
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back,
                                          color: Colors.white, size: 20),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                ),
                                // Logo and brand section
                                Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 20,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isOtpSent ? Icons.sms : Icons.person_add,
                                    size: 40,
                                    color: Color(
                                        0xff1E88E5), // Medical blue from logo
                                    // Color(0xff42A5F5), // Lighter medical blue
                                    // Color(0xff64B5F6), // Even lighter medical blue // Orange from eco-shine
                                  ),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  isOtpSent ? "Verify OTP" : "Join LaundryPro",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  isOtpSent
                                      ? "Enter the 5-digit code sent to\n${phoneController.text}"
                                      : "Create your account to access\nour premium laundry services",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        const Color.fromARGB(255, 255, 255, 255)
                                            .withOpacity(0.9),
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom section with white background and form
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: GroceryAppColors.lightBlueBg, // Light blue background
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      // Form title
                      Text(
                        isOtpSent ? "Verification Code" : "Mobile Verification",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1E88E5), // Medical blue from logo
                          // Lighter medical blue
                          // Even lighter medical blue // Orange from eco-shine
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        isOtpSent
                            ? "Please enter the 5-digit verification code"
                            : "We'll send you a verification code to confirm your number",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 30),

                      if (!isOtpSent) ...[
                        // Phone number input
                        _buildModernTextField(
                          controller: phoneController,
                          hintText: "Enter mobile number",
                          prefixIcon: Icons.phone_android,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                        ),
                        SizedBox(height: 30),
                        // Send OTP button
                        _buildModernButton(
                          onPressed: sendOtp,
                          text: "SEND VERIFICATION CODE",
                          isLoading: isLoading,
                        ),
                        SizedBox(height: 20),
                        _buildOrDivider(),
                      ] else ...[
                        // OTP input with modern design
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: PinCodeTextField(
                            appContext: context,
                            length: 5,
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(12),
                              fieldHeight: 55,
                              fieldWidth: 50,
                              activeFillColor:
                                  Color(0xFFFFF3E0), // Light orange background
                              inactiveFillColor:
                                  Color(0xffFAFCFF), // Very light blue
                              selectedFillColor:
                                  Color(0xFFFFF3E0), // Light orange background
                              activeColor: const Color.fromARGB(
                                  255, 66, 143, 216), // Orange border
                              inactiveColor: Colors.grey[300]!,
                              selectedColor: const Color.fromARGB(
                                  255, 63, 141, 219), // Orange border
                              borderWidth: 2,
                            ),
                            animationDuration: Duration(milliseconds: 300),
                            enableActiveFill: true,
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(
                                  255, 72, 185, 234), // Orange text
                            ),
                            onChanged: (value) {
                              setState(() {
                                currentText = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        // Resend OTP option
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Didn't receive the code?",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isOtpSent = false;
                                  otpController.clear();
                                });
                              },
                              child: Text(
                                "Resend Code",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 53, 211,
                                      255), // Orange from eco-shine
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        // Verify button
                        _buildModernButton(
                          onPressed: verifyOtp,
                          text: "VERIFY & CONTINUE",
                          isLoading: isVerifying,
                        ),
                        SizedBox(height: 20),
                        _buildOrDivider(),
                      ],

                      SizedBox(height: 20),
                      // Back to sign in
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xffFFE5D6),
                                  width: 1), // Light orange border
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: Color(
                                      0xff1E88E5), // Medical blue from logo

                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Go Back",
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 77, 190,
                                        234), // Light orange from eco-shine
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffFAFCFF), // Light blue background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Color(0xffFFE5D6), width: 1), // Light orange border
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 53, 158, 207).withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xff1E88E5), // Medical blue from logo
          // Even lighter medical blue, // Orange from eco-shine
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: const Color.fromARGB(
                255, 65, 148, 208), // Light orange from eco-shine
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          counterText: "",
        ),
        onChanged: (value) {
          setState(() {
            result = value;
          });
        },
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
            child: Divider(color: Color(0xffFFE5D6))), // Light orange divider
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "OR",
            style: TextStyle(
              color: Color(0xff1E88E5), // Medical blue from logo
              //  Even lighter medical blue // Light orange text
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
            child: Divider(color: Color(0xffFFE5D6))), // Light orange divider
      ],
    );
  }

  Widget _buildModernButton({
    required VoidCallback onPressed,
    required String text,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xff1E88E5), // Medical blue from logo
            Color(0xff42A5F5), // Lighter medical blue
            Color(0xff64B5F6), // Even lighter medical blue
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E88E5), // Medical blue from logo

            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
      ),
    );
  }
}

// Placeholder for actual signup form
class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Registration"),
        backgroundColor: Color(0xFF667eea),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 100,
                color: Colors.green,
              ),
              SizedBox(height: 20),
              Text(
                "Phone Verified Successfully!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Please complete your profile information",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF667eea),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Continue to Sign In",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
