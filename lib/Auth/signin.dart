import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ecoshine24/Auth/forgetPassword.dart';
import 'package:ecoshine24/Auth/signup.dart';
import 'package:ecoshine24/Auth/widgets/custom_shape.dart';
import 'package:ecoshine24/Auth/widgets/responsive_ui.dart';
import 'package:ecoshine24/Auth/widgets/textformfield.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/General/Home.dart';
import 'package:ecoshine24/grocery/model/LoginModal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Form6.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: GroceryAppColors.lightBlueBg, // Light blue background
        body: SignInScreen(),
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  double? _height;
  double? _width;
  double? _pixelRatio;
  bool _large = false, flag = false;
  bool _medium = false;
  bool _obscurePassword = true;

  // Login design variables
  int? loginDesign;
  bool isLoadingDesign = true;

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  // OTP related variables
  bool isOtpSent = false;
  bool isOtpLogin = false;

  GlobalKey<FormState> _key = GlobalKey();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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

    // Check login design when screen loads
    _checkLoginDesign();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    nameController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.dispose();
  }

  // Check login design from API
  Future<void> _checkLoginDesign() async {
    try {
      // Use GET method directly since that's what your API expects
      http.Response response;

      try {
        final uri = Uri.parse(GroceryAppConstant.base_url + 'api/cp.php')
            .replace(queryParameters: {
          'shop_id': GroceryAppConstant.Shop_id.toString(),
        });

        response = await http.get(uri).timeout(Duration(seconds: 10));
      } catch (e) {
        throw e;
      }

      if (response.statusCode == 200) {
        // Parse JSON response
        try {
          final jsonBody = json.decode(response.body);

          // Check all possible field names for login design
          String? designValue;
          if (jsonBody['loginDesign'] != null) {
            designValue = jsonBody['loginDesign'].toString();
          } else if (jsonBody['login_design'] != null) {
            designValue = jsonBody['login_design'].toString();
          } else if (jsonBody['logindesign'] != null) {
            designValue = jsonBody['logindesign'].toString();
          }

          if (designValue != null) {
            final parsedDesign = int.tryParse(designValue);

            setState(() {
              loginDesign = parsedDesign ?? 1;
              isOtpLogin = loginDesign == 4;
              isLoadingDesign = false;
            });

            print(
                "Login Design: $loginDesign, OTP Login: $isOtpLogin"); // Debug log
          } else {
            setState(() {
              loginDesign = 1;
              isOtpLogin = loginDesign == 4; // Use consistent logic
              isLoadingDesign = false;
            });

            print(
                "Login Design (fallback): $loginDesign, OTP Login: $isOtpLogin"); // Debug log
          }
        } catch (jsonError) {
          // Check if it's the specific error response from your API
          if (response.body.contains('What are you looking for')) {
            // For testing purposes, you can manually set the login design here
            // Remove this in production once your API is fixed
            setState(() {
              loginDesign = 4; // Force OTP login for testing
              isOtpLogin = loginDesign == 4; // Use consistent logic
              isLoadingDesign = false;
            });
          } else {
            // Fallback to password login
            setState(() {
              loginDesign = 1;
              isOtpLogin = loginDesign == 4; // Use consistent logic
              isLoadingDesign = false;
            });
          }
        }
      } else {
        setState(() {
          loginDesign = 1; // Default to password login
          isOtpLogin = loginDesign == 4; // Use consistent logic
          isLoadingDesign = false;
        });
      }
    } catch (e) {
      setState(() {
        loginDesign = 1; // Default to password login
        isOtpLogin = loginDesign == 4; // Use consistent logic
        isLoadingDesign = false;
      });
    }
  }

  // Send OTP for login
  Future<void> _sendLoginOtp() async {
    if (nameController.text.length != 10) {
      _showLongToast("Please enter a valid Mobile Number");
      return;
    }

    setState(() {
      flag = true;
    });

    try {
      var map = new Map<String, dynamic>();
      map['mobile'] = nameController.text;
      map['xkey'] = GroceryAppConstant.API_KEY;

      final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'api/send_otp.php'),
        body: map,
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        print("Send OTP Response: $jsonBody"); // Debug log

        if (jsonBody['success'] == "true") {
          setState(() {
            isOtpSent = true;
            flag = false;
          });
          _showLongToast("OTP sent successfully");
        } else {
          // Check if user is not registered and auto-start registration
          String message = jsonBody['message'] ?? "Failed to send OTP";
          if (message.contains("Your Mobile or Username is invalid")) {
            _showLongToast("Mobile not registered. Starting registration...");
            _startAutoRegistration();
          } else {
            _showLongToast(message);
            setState(() {
              flag = false;
            });
          }
        }
      } else {
        _showLongToast("Network error. Please try again.");
        setState(() {
          flag = false;
        });
      }
    } catch (e) {
      _showLongToast("Error: $e");
      setState(() {
        flag = false;
      });
    }
  }

  // Login with OTP
  Future<void> _loginWithOtp() async {
    if (otpController.text.isEmpty) {
      _showLongToast("Please enter OTP");
      return;
    }

    setState(() {
      flag = true;
    });

    // This is normal login flow - verify OTP for login
    await _verifyLoginOtp();
  }

  // Verify OTP for login flow
  Future<void> _verifyLoginOtp() async {
    try {
      var map = new Map<String, dynamic>();
      map['shop_id'] = GroceryAppConstant.Shop_id; // Add missing shop_id
      map['mobile'] = nameController.text;
      map['password'] = otpController.text + '_OTP'; // OTP with _OTP suffix
      map['xkey'] = GroceryAppConstant.API_KEY;

      final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'api/login.php'),
        body: map,
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        print("OTP Login Response: $jsonBody"); // Debug log

        if (jsonBody['success'] == "true") {
          // Handle successful login
          _handleSuccessfulLogin(jsonBody);
        } else {
          String errorMessage = jsonBody['message'] ?? "Login failed";
          _showLongToast(errorMessage);
          setState(() {
            flag = false;
          });
        }
      } else {
        _showLongToast("Network error. Please try again.");
        setState(() {
          flag = false;
        });
      }
    } catch (e) {
      _showLongToast("Error: $e");
      setState(() {
        flag = false;
      });
    }
  }

  // Auto-start registration when user is not found
  Future<void> _startAutoRegistration() async {
    setState(() {
      flag = false;
    });

    _showLongToast("Redirecting to registration...");

    // Navigate directly to Form6 for complete registration flow with pre-filled mobile
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Form6(initialMobile: nameController.text)),
    );
  }

  // Handle successful login (common for both methods)
  void _handleSuccessfulLogin(Map<String, dynamic> userData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      flag = false;
    });

    try {
      // Set user data in SharedPreferences with null safety
      pref.setString("email", userData['email']?.toString() ?? "");
      pref.setString("name", userData['name']?.toString() ?? "");
      pref.setString("city", userData['city']?.toString() ?? "");
      pref.setString("address", userData['address']?.toString() ?? "");
      pref.setString("sex", userData['sex']?.toString() ?? "");
      pref.setString(
          "mobile",
          userData['username']?.toString() ??
              userData['mobile']?.toString() ??
              "");
      pref.setString("pin",
          userData['pincode']?.toString() ?? userData['pin']?.toString() ?? "");
      pref.setString(
          "user_id",
          userData['user_id']?.toString() ??
              userData['userId']?.toString() ??
              "");
      pref.setString("pp", userData['pp']?.toString() ?? "");
      pref.setBool("isLogin", true);

      // Set global constants with fallbacks
      GroceryAppConstant.isLogin = true;
      GroceryAppConstant.email = userData['email']?.toString() ?? "";
      GroceryAppConstant.name = userData['name']?.toString() ?? "";
      GroceryAppConstant.user_id = userData['user_id']?.toString() ??
          userData['userId']?.toString() ??
          "";
      GroceryAppConstant.image = userData['pp']?.toString() ?? "";
      GroceryAppConstant.User_ID = userData['username']?.toString() ??
          userData['mobile']?.toString() ??
          "";

      print("Login successful for user: ${GroceryAppConstant.User_ID}");

      _showLongToast("Login successful");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => GroceryApp()),
        (route) => false,
      );
    } catch (e) {
      print("Error in _handleSuccessfulLogin: $e");
      _showLongToast("Login successful but error saving data: $e");

      // Still navigate to app even if there's an error saving preferences
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => GroceryApp()),
        (route) => false,
      );
    }
  }

  void _showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future _getEmployee() async {
    try {
      var map = <String, dynamic>{
        'shop_id': GroceryAppConstant.Shop_id,
        'mobile': nameController.text,
        'password': passwordController.text,
      };

      // 🔍 Print request details
      print("🔸 Login API URL: ${GroceryAppConstant.base_url}api/login.php");
      print("📤 Request Body: $map");

      final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'api/login.php'),
        body: map,
      );

      // 🔍 Print raw response details
      print("📥 Response Status: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        bool isSuccess = false;
        String? successMessage;

        if (jsonBody['success'] == "true") {
          // New format
          isSuccess = true;
          successMessage = jsonBody['message'];
        } else {
          // Old format
          String message = jsonBody['message']?.toString() ?? "";
          if (message.contains("Login is Successful") ||
              message.contains("successful")) {
            isSuccess = true;
            successMessage = message;
          }
        }

        if (isSuccess) {
          setState(() {
            flag = false;
          });

          _showLongToast(successMessage ?? "Login successful");
          _handleSuccessfulLogin(jsonBody);
        } else {
          String errorMessage =
              jsonBody['message']?.toString() ?? "Login failed";
          _showLongToast(errorMessage);
          setState(() {
            flag = false;
          });
        }
      } else {
        _showLongToast("Network error. Please try again.");
        setState(() {
          flag = false;
        });
      }
    } catch (e, stackTrace) {
      // 🔍 Catch any runtime errors
      print("❌ Exception: $e");
      print("📚 StackTrace: $stackTrace");
      _showLongToast("Error: $e");
      setState(() {
        flag = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Changed to true to handle keyboard properly
      backgroundColor: Color(0xffF8FBFF), // Light medical blue background
      body: SafeArea(
        child: Column(
          children: [
            // Top section with medical blue gradient background
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
                    // Medical decorative elements
                    Positioned(
                      top: 30,
                      right: -40,
                      child: AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value * 0.1,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2),
                              ),
                              child: Icon(
                                Icons.health_and_safety,
                                color: Colors.white.withOpacity(0.2),
                                size: 60,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: -30,
                      child: AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value * 0.08,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                    width: 2),
                              ),
                              child: Icon(
                                Icons.medical_services,
                                color: Colors.white.withOpacity(0.2),
                                size: 40,
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
                          padding: EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Medical logo section
                                Container(
                                  padding: EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 25,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/medical_logo.png',
                                      height: 65,
                                      width: 65,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.local_hospital,
                                          size: 65,
                                          color: Color(0xff1E88E5),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "HealthCare Plus",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Your Trusted Medical Partner",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 20),
                                // Medical service highlights
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Consultation icon
                                    SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(-2, 0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: _slideController,
                                        curve: Interval(0.6, 1.0,
                                            curve: Curves.elasticOut),
                                      )),
                                      child: _buildMedicalServiceIcon(
                                        Icons.video_call,
                                        "Consultation",
                                        iconSize: 20,
                                        fontSize: 10,
                                      ),
                                    ),
                                    // Appointment icon
                                    SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(0, 2),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: _slideController,
                                        curve: Interval(0.7, 1.0,
                                            curve: Curves.bounceOut),
                                      )),
                                      child: _buildMedicalServiceIcon(
                                        Icons.schedule,
                                        "Appointments",
                                        iconSize: 20,
                                        fontSize: 10,
                                      ),
                                    ),
                                    // Health Records icon
                                    SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(2, 0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: _slideController,
                                        curve: Interval(0.8, 1.0,
                                            curve: Curves.elasticOut),
                                      )),
                                      child: _buildMedicalServiceIcon(
                                        Icons.folder_shared,
                                        "Records",
                                        iconSize: 20,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
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
            // Bottom section with white background and login form
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffF8FBFF), // Light medical blue background
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20, // Reduced from 25
                    bottom: 10 +
                        MediaQuery.of(context)
                            .viewInsets
                            .bottom, // Reduced from 15
                  ),
                  child: Form(
                    key: _key,
                    child: isLoadingDesign
                        ? Container(
                            height: 150,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xff1E88E5), // Medical blue
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Welcome text
                              Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  fontSize: 26, // Reduced from 30
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1E88E5), // Medical blue
                                ),
                              ),
                              SizedBox(height: 6), // Reduced from 8
                              Text(
                                "Sign in to access your healthcare account",
                                style: TextStyle(
                                  fontSize: 15, // Reduced from 16
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 20), // Reduced from 25

                              // Mobile number field
                              _buildMedicalTextField(
                                controller: nameController,
                                hintText: "Mobile Number",
                                prefixIcon: Icons.phone_android_rounded,
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 15), // Reduced from 18

                              // Show different fields based on login design
                              if (isOtpLogin) ...[
                                // OTP Login Flow
                                if (!isOtpSent) ...[
                                  // Send OTP button
                                  _buildMedicalButton(
                                    onPressed: _sendLoginOtp,
                                    text: "SEND OTP",
                                    isLoading: flag,
                                  ),
                                  SizedBox(height: 20),
                                  _buildMedicalOrDivider(),
                                ] else ...[
                                  // OTP input field
                                  _buildMedicalTextField(
                                    controller: otpController,
                                    hintText: "Enter 6-digit OTP",
                                    prefixIcon: Icons.security_rounded,
                                    keyboardType: TextInputType.number,
                                  ),
                                  SizedBox(height: 15),
                                  // Resend OTP option
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Didn't receive OTP?",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isOtpSent = false;
                                          });
                                        },
                                        child: Text(
                                          "Resend",
                                          style: TextStyle(
                                            color: Color(
                                                0xff1E88E5), // Medical blue
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 25),
                                  // Login with OTP button
                                  _buildMedicalButton(
                                    onPressed: _loginWithOtp,
                                    text: "VERIFY & LOGIN",
                                    isLoading: flag,
                                  ),
                                ],
                              ] else ...[
                                // Password Login Flow
                                _buildMedicalTextField(
                                  controller: passwordController,
                                  hintText: "Password",
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: _obscurePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_rounded
                                          : Icons.visibility_rounded,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height: 15), // Reduced from 18
                                // Forgot password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ForgetPass(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color:
                                            Color(0xff1E88E5), // Medical blue
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 18), // Reduced from 25
                                // Sign in button
                                _buildMedicalButton(
                                  onPressed: () {
                                    if (nameController.text.length != 10) {
                                      _showLongToast(
                                          "Please enter a valid Mobile Number");
                                    } else if (passwordController.text.length <
                                        5) {
                                      _showLongToast(
                                          "Password should contain at least 5 letters");
                                    } else {
                                      setState(() {
                                        flag = true;
                                      });
                                      _getEmployee();
                                    }
                                  },
                                  text: "SIGN IN",
                                  isLoading: flag,
                                ),
                                SizedBox(height: 20),
                                _buildMedicalOrDivider(),
                              ],

                              SizedBox(height: 15),
                              // Bottom action buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildMedicalSecondaryButton(
                                      onPressed: () async {
                                        // Set flag to skip category selection modal
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        await pref.setBool(
                                            "skipCategorySelection", true);

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GroceryApp()),
                                          (route) => false,
                                        );
                                      },
                                      text: "SKIP",
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    flex: 2,
                                    child: _buildMedicalOutlineButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Form6(
                                              initialMobile:
                                                  nameController.text.isNotEmpty
                                                      ? nameController.text
                                                      : null,
                                            ),
                                          ),
                                        );
                                      },
                                      text: "CREATE ACCOUNT",
                                    ),
                                  ),
                                ],
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
    );
  }

  Widget _buildMedicalServiceIcon(IconData icon, String label,
      {double iconSize = 20, double fontSize = 10}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: iconSize,
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Color(0xff64B5F6).withOpacity(0.3))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "OR",
            style: TextStyle(
              color: Color(0xff1E88E5),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: Color(0xff64B5F6).withOpacity(0.3))),
      ],
    );
  }

  Widget _buildMedicalSecondaryButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return Container(
      height: 42,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: Color(0xff64B5F6).withOpacity(0.3),
            width: 1.5), // Light medical blue border
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E88E5).withOpacity(0.08), // Medical blue shadow
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xff1E88E5), // Medical blue
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
            color: Color(0xff64B5F6), // Light medical blue
            size: 22,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalButton({
    required VoidCallback onPressed,
    required String text,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xff1E88E5), // Medical blue
            Color(0xff42A5F5), // Lighter medical blue
            Color(0xff64B5F6), // Even lighter medical blue
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E88E5).withOpacity(0.3),
            blurRadius: 18,
            offset: Offset(0, 8),
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
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
      ),
    );
  }

  Widget _buildMedicalOutlineButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Color(0xff1E88E5), width: 2), // Medical blue border
        color: Colors.white,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xff1E88E5), // Medical blue text
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
