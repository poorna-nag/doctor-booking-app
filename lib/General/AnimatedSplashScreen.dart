import 'package:ecoshine24/Auth/signin.dart';
import 'package:ecoshine24/grocery/General/Home.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppConstant.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  static const Duration _splashDuration = Duration(seconds: 3);
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _requestLocationPermission();
    await _loadSession();
    await Future.delayed(_splashDuration);

    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    final nextPage = FoodAppConstant.isLogin ? GroceryApp() : SignInPage();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => nextPage),
      (route) => false,
    );
  }

  Future<void> _loadSession() async {
    final pref = await SharedPreferences.getInstance();
    FoodAppConstant.pinid = pref.getString("pin") ?? "";
    FoodAppConstant.cityid = pref.getString("cityid") ?? "";
    FoodAppConstant.isLogin = pref.getBool("isLogin") ?? false;

    await pref.setString("lat", FoodAppConstant.latitude.toString());
    await pref.setString("lng", FoodAppConstant.longitude.toString());
  }

  Future<void> _requestLocationPermission() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    } catch (_) {
      // Location is useful for address suggestions, but it shouldn't block startup.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF4FF), Color(0xFFF7FBFF)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 132,
                height: 132,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.10),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/icon/doctor booking logo 1.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Doctor Booking',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF15324B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Simple, fast appointment booking',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF67809A),
                ),
              ),
              const SizedBox(height: 28),
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
