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
      map['X-Api-Key'] = GroceryAppConstant.API_KEY;

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
      map['X-Api-Key'] = GroceryAppConstant.API_KEY;

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
      pref.setBool("skipLogin", false);

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

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => GroceryApp()),
        (route) => false,
      );
    } catch (e) {
      print("Error in _handleSuccessfulLogin: $e");
      _showLongToast("Login successful but error saving data: $e");

      // Still navigate to app even if there's an error saving preferences
      if (!mounted) return;

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

  Future<void> _continueAsGuest() async {
    setState(() {
      flag = false;
    });

    final pref = await SharedPreferences.getInstance();
    await pref.setBool("skipLogin", true);
    await pref.setBool("isLogin", false);
    await pref.setString("email", "");
    await pref.setString("name", "");
    await pref.setString("city", "");
    await pref.setString("address", "");
    await pref.setString("sex", "");
    await pref.setString("mobile", "");
    await pref.setString("pin", "");
    await pref.setString("user_id", "");
    await pref.setString("pp", "");

    GroceryAppConstant.isLogin = false;
    GroceryAppConstant.email = "";
    GroceryAppConstant.name = "";
    GroceryAppConstant.user_id = "";
    GroceryAppConstant.image = "";
    GroceryAppConstant.User_ID = "";

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => GroceryApp()),
      (route) => false,
    );
  }

  Future _getEmployee() async {
    try {
      var map = <String, dynamic>{
        'shop_id': GroceryAppConstant.Shop_id,
        'mobile': nameController.text,
        'password': passwordController.text,
        'X-Api-Key': GroceryAppConstant.API_KEY,
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
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF5F8FC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF4FF), Color(0xFFF7FBFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    _height! - MediaQuery.of(context).padding.vertical - 48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBrandHeader(),
                  const SizedBox(height: 24),
                  _buildLoginCard(),
                  const SizedBox(height: 20),
                  _buildFooterLinks(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Column(
      children: [
        Container(
          width: 112,
          height: 112,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.12),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Image.asset(
            'assets/icon/doctor booking logo 1.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          GroceryAppConstant.appname,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF15324B),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Simple booking, fast access',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF67809A),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Form(
        key: _key,
        child: isLoadingDesign
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 36),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff1E88E5),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isOtpLogin ? 'Verify your number' : 'Sign in to continue',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF15324B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Use your mobile number, or skip for guest access.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF67809A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  emailTextFormField(),
                  const SizedBox(height: 14),
                  if (isOtpLogin) ...[
                    if (!isOtpSent) ...[
                      _buildPrimaryButton(
                        label: 'Send OTP',
                        onPressed: _sendLoginOtp,
                      ),
                    ] else ...[
                      _buildOtpField(),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isOtpSent = false;
                            });
                          },
                          child: const Text('Resend OTP'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildPrimaryButton(
                        label: 'Verify & Login',
                        onPressed: _loginWithOtp,
                      ),
                    ],
                    const SizedBox(height: 10),
                    _buildGuestButton(),
                  ] else ...[
                    passwordTextFormField(),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPass(),
                            ),
                          );
                        },
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPrimaryButton(
                      label: 'Sign in',
                      onPressed: () {
                        if (nameController.text.trim().length != 10) {
                          _showLongToast(
                              'Please enter a valid 10-digit mobile number');
                        } else if (passwordController.text.trim().length < 5) {
                          _showLongToast(
                              'Password should contain at least 5 characters');
                        } else {
                          setState(() {
                            flag = true;
                          });
                          _getEmployee();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildGuestButton(),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: flag ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xff1E88E5), Color(0xff42A5F5)],
            ),
          ),
          child: Center(
            child: flag
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuestButton() {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: TextButton(
        onPressed: flag ? null : _continueAsGuest,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xff1E88E5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFB7D7F5)),
          ),
        ),
        child: const Text(
          'Continue as guest',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: TextStyle(
                color: Color(0xFF67809A),
                fontSize: 14,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Form6(
                      initialMobile: nameController.text.trim().isNotEmpty
                          ? nameController.text.trim()
                          : null,
                    ),
                  ),
                );
              },
              child: const Text(
                'Sign up',
                style: TextStyle(
                  color: Color(0xff1E88E5),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: nameController,
      icon: Icons.phone_android,
      hint: "10 Digit Mobile Number",
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      maxLength: 10,
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.visiblePassword,
      textEditingController: passwordController,
      icon: Icons.lock,
      obscureText: true,
      hint: "Password",
    );
  }

  Widget _buildOtpField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: otpController,
      icon: Icons.security,
      hint: "Enter OTP",
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
      maxLength: 6,
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
