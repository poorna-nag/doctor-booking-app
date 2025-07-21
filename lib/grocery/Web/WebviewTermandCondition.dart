import 'dart:ui';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'dart:async';

class WebViewClass extends StatefulWidget {
  final String title;
  String url;

  WebViewClass(this.title, this.url);
  @override
  _WebViewClassState createState() => _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  PullToRefreshController? pullToRefreshController;

  late ContextMenu contextMenu;
  double progress = 0;

  final urlController = TextEditingController();
  //Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GroceryAppColors.tela,
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
          widget.title,
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
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
                          this.widget.url = url.toString();
                          urlController.text = widget.url;
                        });
                      },

                      onLoadStop: (controller, url) async {
                        setState(() {
                          this.widget.url = url.toString();
                          urlController.text = this.widget.url;
                           isLoading=false;
                        });
                      },

                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController?.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                          urlController.text = this.widget.url;
                        });
                      },
                      onUpdateVisitedHistory: (controller, url, isReload) {
                        setState(() {
                          this.widget.url = url.toString();
                          urlController.text = this.widget.url;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                    ),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Stack(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/*
class WebViewState extends State<WebViewScreen>{

  String title,url;
  bool isLoading=true;
  final _key = UniqueKey();

  WebViewState(String title,String url){
    this.title=title;
    this.url=url;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: Text(this.title,style: TextStyle(fontWeight: FontWeight.w700)),centerTitle: true
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: this.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? Center( child: CircularProgressIndicator(),)
              : Stack(),
        ],
      ),
    );
  }

}*/
