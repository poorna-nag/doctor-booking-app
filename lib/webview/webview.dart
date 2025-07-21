// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:royalmart/General/AppConstant.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:async';

// class WebViewClass extends StatefulWidget {
//   final String title;
//   final String url;

//   WebViewClass(this.title, this.url);
//   @override
//   _WebViewClassState createState() => _WebViewClassState();
// }

// class _WebViewClassState extends State<WebViewClass> {
//   Completer<WebViewController> _controller = Completer<WebViewController>();
//   bool isLoading = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: FoodAppColors.tela,
//         leading: Padding(
//           padding: EdgeInsets.only(left: 0.0),
//           child: InkWell(
//             onTap: () {
//               if (Navigator.canPop(context)) {
//                 Navigator.pop(context);
//               } else {
//                 SystemNavigator.pop();
//               }
//             },
//             child: Icon(
//               Icons.arrow_back,
//               size: 30,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         title: Text(
//           widget.title,
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Stack(
//         children: [
//           WebViewWidget(
//             javascriptMode: JavascriptMode.unrestricted,
//             initialUrl: widget.url,
//             onWebViewCreated: (WebViewController webViewController) {
//               _controller.complete(webViewController);
//             },
//             onPageFinished: (finish) {
//               setState(() {
//                 isLoading = false;
//               });
//             },
//           ),
//           isLoading
//               ? Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : Stack(),
//         ],
//       ),
//     );
//   }
// }

// /*
// class WebViewState extends State<WebViewClass>{

//   String title,url;
//   bool isLoading=true;
//   final _key = UniqueKey();

//   WebViewState(String title,String url){
//     this.title=title;
//     this.url=url;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: new AppBar(
//           title: Text(this.title,style: TextStyle(fontWeight: FontWeight.w700)),centerTitle: true
//       ),
//       body: Stack(
//         children: <Widget>[
//           WebView(
//             key: _key,
//             initialUrl: this.url,
//             javascriptMode: JavascriptMode.unrestricted,
//             onPageFinished: (finish) {
//               setState(() {
//                 isLoading = false;
//               });
//             },
//           ),
//           isLoading ? Center( child: CircularProgressIndicator(),)
//               : Stack(),
//         ],
//       ),
//     );
//   }

// }*/

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewClass extends StatefulWidget {
  final String url;
  final String? title;
  const WebViewClass({Key? key, required this.url, this.title})
      : super(key: key);
  @override
  _WebViewClassState createState() => new _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  late SharedPreferences pref;
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  PullToRefreshController? pullToRefreshController;

  late ContextMenu contextMenu;
  String url = '';
  double progress = 0;
  final urlController = TextEditingController();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    String url = widget.url;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FoodAppColors.tela,
        leading: Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: InkWell(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        title: Center(
            child: Text(
          widget.title.toString(),
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
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
                        this.url = url.toString();
                        urlController.text = widget.url;
                      });
                    },
          
                    onLoadStop: (controller, url) async {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                        isLoading=false;
                      });
                    },
          
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = this.url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, isReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),
                ),
              ],
            ),
          ),  isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Stack(),
          
        ],
      ),
      
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await webViewController?.canGoBack() ?? false) {
      webViewController?.goBack();
      return Future.value(false);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Warning"),
              content: const Text("Are you sure you want to exit!"),
              actions: [
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No")),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      exit(0);
                    },
                    child: const Text("Yes"))
              ],
            );
          });

      return Future.value(false);
    }
  }
}
