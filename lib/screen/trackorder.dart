import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class MyOrdertrack extends StatefulWidget {
  String idvalue;
  MyOrdertrack(this.idvalue);

  @override
  State<MyOrdertrack> createState() => _MyOrdertrackState();
}

class _MyOrdertrackState extends State<MyOrdertrack> {
  // final Completer<WebViewController> _controller =
  InAppWebViewController? webViewController;

  PullToRefreshController? pullToRefreshController;

  late ContextMenu contextMenu;
    final GlobalKey webViewKey = GlobalKey();
  double progress = 0;

  final urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor:Colors.teal[50],

        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "My Booking",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body:Column(children: [
        Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(url: WebUri('https://shiprocket.co/tracking/'+widget.idvalue)),
                      // initialUrlRequest:
                      // URLRequest(url: WebUri(Uri.base.toString().replaceFirst("/#/", "/") + 'page.html')),
                      // initialFile: "assets/index.html",

                      // contextMenu: contextMenu,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) async {
                        webViewController = controller;
                        print(await controller.getUrl());
                      },
                      onLoadStart: (controller, url) async {
                        setState(() {
                          this.widget.idvalue = url.toString();
                          urlController.text = widget.idvalue;
                        });
                      },

                      onLoadStop: (controller, url) async {
                        setState(() {
                          this.widget.idvalue = url.toString();
                          urlController.text = this.widget.idvalue;
                        });
                      },

                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController?.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                          urlController.text = this.widget.idvalue;
                        });
                      },
                      onUpdateVisitedHistory: (controller, url, isReload) {
                        setState(() {
                          this.widget.idvalue = url.toString();
                          urlController.text = this.widget.idvalue;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                    ),
                  ],
                ),
              ),
      ],));
  }
}


// Builder(
//     builder: (BuildContext context) {
//     return WebView(
//     initialUrl: 'https://shiprocket.co/tracking/'+idvalue,
//     javascriptMode: JavascriptMode.unrestricted,
//     onWebViewCreated: (WebViewController webViewController) {
//     _controller.complete(webViewController);
//     },
//     );
//     },

// //      WebView(
// //        initialUrl: 'https://shiprocket.co/tracking/'+idvalue,
// //        javascriptMode: JavascriptMode.unrestricted,
// //
// //
// //      ),

//     ),

// class NavigationControls extends StatelessWidget {

//   const NavigationControls(this._webViewControllerFuture);

//   final Future<WebViewController> _webViewControllerFuture;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewController>(
//       future: _webViewControllerFuture,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
//         final bool webViewReady =
//             snapshot.connectionState == ConnectionState.done;
//         final WebViewController controller = snapshot.data;
//         return Row(
//           children: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               onPressed: !webViewReady
//                   ? null
//                   : () async {
//                 if (await controller.canGoBack()) {
//                   controller.goBack();
//                 } else {
//                   Scaffold.of(context).showSnackBar(
//                     const SnackBar(content: Text("No back history item")),
//                   );
//                   return;
//                 }
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward_ios),
//               onPressed: !webViewReady
//                   ? null
//                   : () async {
//                 if (await controller.canGoForward()) {
//                   controller.goForward();
//                 } else {
//                   Scaffold.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text("No forward history item")),
//                   );
//                   return;
//                 }
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.replay),
//               onPressed: !webViewReady
//                   ? null
//                   : () {
//                 controller.reload();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }