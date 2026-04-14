import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecoshine24/grocery/Auth/widgets/responsive_ui.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final IconData? icon;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  double? _width;
  double? _pixelRatio;
  bool? large;
  bool? medium;

  CustomTextField({
    this.hint,
    this.textEditingController,
    this.keyboardType,
    this.icon,
    this.obscureText = false,
    this.enabled,
    this.inputFormatters,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    medium = ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: large! ? 12 : (medium! ? 10 : 8),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        obscureText: obscureText ?? false,
        enabled: enabled ?? true,
        cursorColor: GroceryAppColors.boxColor1,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: GroceryAppColors.boxColor1, size: 20),
          hintText: hint,
          counterText: '',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
