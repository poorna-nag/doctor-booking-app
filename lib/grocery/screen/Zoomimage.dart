import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:photo_view/photo_view.dart';

class ZoomImage extends StatefulWidget {
  final List<String> plist;
  const ZoomImage(this.plist) : super();

  @override
  _ZoomImageState createState() => _ZoomImageState();
}

class _ZoomImageState extends State<ZoomImage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _current = 0;

  PhotoViewScaleStateController? scaleStateController;
  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
  }

  @override
  void dispose() {
    scaleStateController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GroceryAppColors.white,
        elevation: 0.0,
        leading: InkWell(
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
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: GroceryAppColors.tela1,
      body: Stack(children: <Widget>[
        Container(
          color: GroceryAppColors.white,
          child: Stack(
            children: <Widget>[
              PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _current = page;
                    });
                  },
                  itemCount: widget.plist.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Stack(
                      children: <Widget>[
                        PhotoView(
                          maxScale: 70.0,
                          minScale: 0.0,
                          backgroundDecoration:
                              BoxDecoration(color: GroceryAppColors.white),
                          imageProvider: NetworkImage(
                            GroceryAppConstant.Product_Imageurl2 +
                                widget.plist[i],
                          ),
                          scaleStateController: scaleStateController,
                        ),
                      ],
                    );
                  }),
              Positioned(
                bottom: 10.0,
                left: 0.0,
                right: 0.0,
                child: DotsIndicator(
                  dotsCount: widget.plist.length,
                  position: _current,
                  decorator: DotsDecorator(
                    color: Colors.black,
                    activeColor: Colors.pink,
                    spacing: EdgeInsets.symmetric(horizontal: 5.0),
                  ),
                ),
              ),
            ],
          ),
        ),

//            Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: map<Widget>(ProductDetailsState.imgList1, (index, url) {
//                return Container(
//                  width: 25.0,
//                  height: 0.0,
//
//                  child: Divider(
//                    height: 20,
//                    color: _current == index ? Colors.orange : Colors.grey,
//
//                    thickness: 2.0,
////                                  endIndent: 30.0,
//                  ),
//
//                  margin: EdgeInsets.symmetric(horizontal: 4.0,vertical: 7.0),
////                                decoration: BoxDecoration(
////                                  shape: BoxShape.rectangle,
////                                  color: _current == index ? Colors.orange : Colors.grey,
////                                ),
//                );
//              }),
//            ),
      ]),
    );
  }
}
//NetworkImage(Constant.Product_Imageurl2+ProductDetailsState.imgList1[i])
