import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:aladdinmart/utils/styles.dart';

class CartWidget extends StatelessWidget {
  final Color? color;
  final double? size;
  CartWidget({
    @required this.color,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Icon(
        Icons.shopping_cart,
        size: size,
        color: color,
      ),
    ]);
  }
}
