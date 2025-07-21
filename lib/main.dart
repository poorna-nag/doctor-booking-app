import 'package:aladdinmart/Utils.dart';
import 'package:flutter/material.dart';
import 'package:aladdinmart/General/AnimatedSplashScreen.dart';
import 'General/AppConstant.dart';
import 'package:provider/provider.dart';
import 'controller/phonepay_controller.dart';

Future main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PhonepePaymentController())
      ],
      child: MaterialApp(
        title: FoodAppConstant.appname,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: AnimatedSplashScreen(),
        // home: GroceryApp(),
      ),
    ),
  );
  Utils.firstTimeOpen = true;
}
