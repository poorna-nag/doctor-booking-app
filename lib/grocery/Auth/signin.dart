import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ecoshine24/grocery/Auth/forgetPassword.dart';
import 'package:ecoshine24/grocery/Auth/widgets/custom_shape.dart';
import 'package:ecoshine24/grocery/Auth/widgets/customappbar.dart';
import 'package:ecoshine24/grocery/Auth/widgets/register.dart';
import 'package:ecoshine24/grocery/Auth/widgets/responsive_ui.dart';
import 'package:ecoshine24/grocery/Auth/widgets/textformfield.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/General/Home.dart';
import 'package:ecoshine24/grocery/model/LoginModal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
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

  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize animations
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

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    Future.delayed(Duration(milliseconds: 300), () {
      _scaleController.forward();
    });

    // Check login design when screen loads
    _checkLoginDesign();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    nameController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.dispose();
  }

  // Check login design from API
  Future<void> _checkLoginDesign() async {
    try {
      // Use GET method since that's what your API expects
      final uri = Uri.parse(GroceryAppConstant.base_url + 'api/cp.php')
          .replace(queryParameters: {
        'shop_id': GroceryAppConstant.Shop_id.toString(),
      });

      final response = await http.get(uri);

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
          } else {
            setState(() {
              loginDesign = 1;
              isOtpLogin = false;
              isLoadingDesign = false;
            });
          }
        } catch (jsonError) {
          // Fallback to password login
          setState(() {
            loginDesign = 1;
            isOtpLogin = false;
            isLoadingDesign = false;
          });
        }
      } else {
        setState(() {
          loginDesign = 1; // Default to password login
          isOtpLogin = false;
          isLoadingDesign = false;
        });
      }
    } catch (e) {
      setState(() {
        loginDesign = 1; // Default to password login
        isOtpLogin = false;
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
        if (jsonBody['success'] == "true") {
          setState(() {
            isOtpSent = true;
            flag = false;
          });
          _showLongToast("OTP sent successfully");
        } else {
          _showLongToast(jsonBody['message'] ?? "Failed to send OTP");
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

  // Login with OTP
  Future<void> _loginWithOtp() async {
    if (otpController.text.isEmpty) {
      _showLongToast("Please enter OTP");
      return;
    }

    setState(() {
      flag = true;
    });

    try {
      var map = new Map<String, dynamic>();
      map['mobile'] = nameController.text;
      map['password'] = otpController.text + '_OTP'; // OTP with _OTP suffix
      map['xkey'] = GroceryAppConstant.API_KEY;

      final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'api/login.php'),
        body: map,
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['success'] == "true") {
          // Handle successful login
          _handleSuccessfulLogin(jsonBody);
        } else {
          _showLongToast(jsonBody['message'] ?? "Login failed");
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

  // Handle successful login (common for both methods)
  void _handleSuccessfulLogin(Map<String, dynamic> userData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      flag = false;
    });

    // Set user data in SharedPreferences
    pref.setString("email", userData['email']?.toString() ?? "");
    pref.setString("name", userData['name']?.toString() ?? "");
    pref.setString("city", userData['city']?.toString() ?? "");
    pref.setString("address", userData['address']?.toString() ?? "");
    pref.setString("sex", userData['sex']?.toString() ?? "");
    pref.setString("mobile", userData['username']?.toString() ?? "");
    pref.setString("pin", userData['pincode']?.toString() ?? "");
    pref.setString("user_id", userData['user_id']?.toString() ?? "");
    pref.setString("pp", userData['pp']?.toString() ?? "");
    pref.setBool("isLogin", true);
    pref.setBool("skipLogin", false);

    // Set global constants
    GroceryAppConstant.isLogin = true;
    GroceryAppConstant.email = userData['email']?.toString() ?? "";
    GroceryAppConstant.name = userData['name']?.toString() ?? "";
    GroceryAppConstant.user_id = userData['user_id']?.toString() ?? "";
    GroceryAppConstant.image = userData['pp']?.toString() ?? "";
    GroceryAppConstant.User_ID = userData['username']?.toString() ?? "";

    _showLongToast("Login successful");

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => GroceryApp()),
      (route) => false,
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
    GroceryAppConstant.check = false;

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => GroceryApp()),
      (route) => false,
    );
  }

  void _showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future _getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var map = new Map<String, dynamic>();
    map['shop_id'] = GroceryAppConstant.Shop_id;
    map['mobile'] = nameController.text;
    map['password'] = passwordController.text;

    final response = await http.post(
        Uri.parse(GroceryAppConstant.base_url + 'api/login.php'),
        body: map);
    if (response.statusCode == 200) {
      print(response.toString());
      final jsonBody = json.decode(response.body);
      loginModal user = loginModal.fromJson(jsonDecode(response.body));
      print(jsonBody.toString());
      if (user.message.toString() == "Login is Successful") {
        setState(() {
          flag = false;
        });
        _showLongToast(user.message.toString());
        pref.setString("email", user.email.toString());
        pref.setString("name", user.name.toString());
        pref.setString("city", user.city.toString());
        pref.setString("address", user.address.toString());
        pref.setString("sex", user.sex.toString());
        pref.setString("mobile", user.username.toString());
        pref.setString("pin", user.pincode.toString());
        pref.setString("user_id", user.user_id.toString());
        pref.setString("pp", user.pp.toString());
        pref.setBool("isLogin", true);
        pref.setBool("skipLogin", false);
        print(user.user_id);
        GroceryAppConstant.isLogin = true;
        GroceryAppConstant.email = user.email.toString();
        GroceryAppConstant.name = user.name.toString();
        GroceryAppConstant.user_id = user.user_id.toString();
        GroceryAppConstant.image = user.pp.toString();
        // pref.setString("pp", user.username);

//        pref.setString("mobile",phoneController.text);

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => GroceryApp()),
          (route) => false,
        );
      } else {
        _showLongToast(user.message.toString());
        setState(() {
          flag = false;
        });
      }
    } else
      throw Exception("Unable to get Employee list");
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

  Widget _buildFooterLinks() {
    return Row(
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
              MaterialPageRoute(builder: (context) => Register()),
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
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height! / 4
                  : (_medium ? _height! / 3.75 : _height! / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff1E88E5), // Medical blue from grocery home
                    Color(0xff42A5F5), // Lighter medical blue
                  ],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height! / 4.5
                  : (_medium ? _height! / 4.25 : _height! / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff1E88E5), // Medical blue from grocery home
                    Color(0xff42A5F5), // Lighter medical blue
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height! / 60
                  : (_medium ? _height! / 45 : _height! / 40)),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    height: 200,
                    width: 200,
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: EdgeInsets.only(left: _width! / 20, top: _height! / 100),
          child: Row(
            children: <Widget>[
              Text(
                "Welcomeeee",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _large ? 60 : (_medium ? 50 : 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget signInTextRow() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Interval(0.2, 1.0, curve: Curves.easeOut),
      )),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _fadeController,
          curve: Interval(0.2, 1.0, curve: Curves.easeIn),
        )),
        child: Container(
          margin: EdgeInsets.only(left: _width! / 15.0),
          child: Row(
            children: <Widget>[
              Text(
                "Sign in to your account",
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: _large ? 20 : (_medium ? 17.5 : 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget form() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 0.4),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Interval(0.4, 1.0, curve: Curves.easeOutBack),
      )),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _fadeController,
          curve: Interval(0.4, 1.0, curve: Curves.easeIn),
        )),
        child: Container(
          margin: EdgeInsets.only(
              left: _width! / 12.0,
              right: _width! / 12.0,
              top: _height! / 15.0),
          child: Form(
            key: _key,
            child: isLoadingDesign
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xff1E88E5), // Medical blue
                    ),
                  )
                : Column(
                    children: <Widget>[
                      emailTextFormField(),
                      SizedBox(height: _height! / 40.0),

                      // Show different fields based on login design
                      if (isOtpLogin) ...[
                        // OTP Login Flow
                        if (!isOtpSent) ...[
                          // Send OTP button
                          _buildSendOtpButton(),
                        ] else ...[
                          // OTP input field
                          _buildOtpField(),
                          SizedBox(height: _height! / 40.0),
                          // Resend OTP option
                          _buildResendOtpOption(),
                          SizedBox(height: _height! / 40.0),
                          // Login with OTP button
                          _buildLoginWithOtpButton(),
                        ],
                      ] else ...[
                        // Password Login Flow
                        passwordTextFormField(),
                        SizedBox(height: _height! / 40.0),
                        // forgetPassTextRow(),
                        // SizedBox(height: _height! / 40.0),
                        // button(),
                      ],
                    ],
                  ),
          ),
        ),
      ),
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

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgetPass()),
              );
              print("Routing");
            },
            child: Text(
              "Recover",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1E88E5)), // Medical blue
            ),
          )
        ],
      ),
    );
  }

  Widget button() {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _scaleController,
        curve: Interval(0.6, 1.0, curve: Curves.bounceOut),
      )),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _fadeController,
          curve: Interval(0.6, 1.0, curve: Curves.easeIn),
        )),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            padding: EdgeInsets.all(0.0),
            textStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            if (nameController.text.length != 10) {
              _showLongToast("Please enter the valied No.");
            } else if (passwordController.text.length < 3) {
              _showLongToast("Password should be 6 latter");
            } else {
              setState(() {
                flag = true;
              });
              _getEmployee();
            }

//          print("Routing to your account");
//          Scaffold
//              .of(context)
//              .showSnackBar(SnackBar(content: Text('Login Successful')));
          },
          child: Container(
            alignment: Alignment.center,
            width: _large
                ? _width! / 4
                : (_medium ? _width! / 3.75 : _width! / 3.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xff1E88E5), // Medical blue from grocery home
                  Color(0xff42A5F5), // Lighter medical blue
                ],
              ),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Text('Sign in',
                style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
          ),
        ),
      ),
    );
  }

  Widget signUpTextRow() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Interval(0.8, 1.0, curve: Curves.elasticOut),
      )),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _fadeController,
          curve: Interval(0.8, 1.0, curve: Curves.easeIn),
        )),
        child: Container(
          margin: EdgeInsets.only(top: _height! / 120.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Don't have an account?",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: _large ? 14 : (_medium ? 12 : 10)),
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.8,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: _scaleController,
                    curve: Interval(0.8, 1.0, curve: Curves.bounceOut),
                  )),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xff1E88E5), // Medical blue
                        fontSize: _large ? 19 : (_medium ? 17 : 15)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget circularIndi() {
    return Align(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // OTP Flow Helper Methods
  Widget _buildSendOtpButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        padding: EdgeInsets.all(0.0),
        textStyle: TextStyle(color: Colors.white),
      ),
      onPressed: flag ? null : _sendLoginOtp,
      child: Container(
        alignment: Alignment.center,
        width:
            _large ? _width! / 4 : (_medium ? _width! / 3.75 : _width! / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xff1E88E5), // Medical blue from grocery home
              Color(0xff42A5F5), // Lighter medical blue
            ],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: flag
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text('Send OTP',
                style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
      ),
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

  Widget _buildResendOtpOption() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOtpSent = false;
        });
      },
      child: Text(
        "Resend OTP",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xff1E88E5), // Medical blue
          fontSize: _large ? 14 : (_medium ? 12 : 10),
        ),
      ),
    );
  }

  Widget _buildLoginWithOtpButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        padding: EdgeInsets.all(0.0),
        textStyle: TextStyle(color: Colors.white),
      ),
      onPressed: flag ? null : _loginWithOtp,
      child: Container(
        alignment: Alignment.center,
        width:
            _large ? _width! / 4 : (_medium ? _width! / 3.75 : _width! / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xff1E88E5), // Medical blue from grocery home
              Color(0xff42A5F5), // Lighter medical blue
            ],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: flag
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text('Login with OTP',
                style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
      ),
    );
  }
}
