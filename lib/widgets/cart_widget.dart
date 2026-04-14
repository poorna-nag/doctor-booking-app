import 'package:flutter/material.dart';

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
