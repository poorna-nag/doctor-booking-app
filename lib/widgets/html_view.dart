
import 'package:flutter/material.dart';

class HtmlViewWidget extends StatelessWidget {
  const HtmlViewWidget({
    super.key,
    required this.discription,
  });
  final String discription;

  @override
  Widget build(BuildContext context) {
    final plainText = discription
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SelectableText(
        plainText.isEmpty ? discription : plainText,
        style: const TextStyle(
          fontSize: 14,
          height: 1.4,
          color: Colors.black87,
        ),
      ),
    );
  }
}
