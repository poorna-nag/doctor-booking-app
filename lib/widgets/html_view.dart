
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HtmlViewWidget extends StatelessWidget {
  const HtmlViewWidget({
    super.key,
    required this.discription,
  });
  final String discription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: HtmlWidget(
        discription,
        onErrorBuilder: (context, element, error) =>
            Text('$element error: $error'),
        onLoadingBuilder: (context, element, loadingProgress) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: CircularProgressIndicator(),
        ),

        onTapUrl: (url) {
          // launchUrl(Uri.parse(url));
          return true;
        },

        renderMode: RenderMode.column,

        // set the default styling for text
        textStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}