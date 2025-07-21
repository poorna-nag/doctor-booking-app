import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aladdinmart/Auth/widgets/textformfield.dart';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:aladdinmart/grocery/dbhelper/database_helper.dart';
// import 'package:aladdinmart/grocery/General/AppConstant.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodAppColors.white,
      appBar: AppBar(
        backgroundColor: FoodAppColors.tela,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width / 1.8,
            ),
            enterNewPasswordTextField(),
            SizedBox(
              height: 10,
            ),
            confirmPasswordTextField(),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                print("len----->${passwordController.text.length}");
                if (passwordController.text.length > 4 &&
                    passwordController.text == confirmPasswordController.text) {
                  setState(() {
                    isLoading = true;
                  });
                  updateAny('customers', 'password',
                          confirmPasswordController.text)
                      .then((value) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                } else {
                  showLongToast('Check your password fields again...');
                }
              },
              color: FoodAppColors.tela,
              textColor: FoodAppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Change",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget enterNewPasswordTextField() {
    return CustomTextField(
      hint: 'Enter new password',
      textEditingController: passwordController,
      keyboardType: TextInputType.text,
      icon: Icons.lock,
      obscureText: true,
    );
  }

  Widget confirmPasswordTextField() {
    return CustomTextField(
      hint: 'Confirm password',
      textEditingController: confirmPasswordController,
      keyboardType: TextInputType.text,
      icon: Icons.lock,
      obscureText: true,
    );
  }
}
