import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:aladdinmart/dbhelper/database_helper.dart';
import 'package:aladdinmart/grocery/dbhelper/database_helper.dart';
import 'package:aladdinmart/grocery/screen/productlist.dart';
import 'package:aladdinmart/model/ListModel.dart';
import 'package:aladdinmart/screen/MvProduct.dart';
import 'package:aladdinmart/utils/dimensions.dart';
import 'package:aladdinmart/utils/styles.dart';

import 'SubCategry.dart';

class QRCodeScanner extends StatefulWidget {
  final Function? changeView;

  const QRCodeScanner({Key? key, this.changeView}) : super(key: key);

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  String qrCodeResult = "Not Yet Scanned";
  bool isLoading = true;
  List<String> mvId = [];
  List<ListModel> mvList = [];
  List<ListModel> shoplist = [];
  bool flag = false;

  void getMvList() async {
    await getMV().then((value) async {
      setState(() {
        mvList = value!;
        log(mvList.toString());
      });
    });
  }

  void openQRCode() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScannerScreen()),
    );
    
    if (result != null && result != "-1") {
      log(result.toString());
      setState(() {
        mvId = result.split(",");
        isLoading = false;
      });
      log(mvId.length.toString());
      log(mvList.length.toString());
      if (mvId.isNotEmpty &&
          mvId.length >= 2 &&
          mvList.length >= 1 &&
          mvList.isNotEmpty) {
        log("if check");
        for (var i = 0; i < mvList.length - 1; i++) {
          //  log(mvList[i].mvId.toString());
          // log(mvId[1].toString());

          if (mvId[1] != mvList[i].mvId) {
            log(mvId[1].toString() +
                "sdfdfasdfasfasdfasdf" +
                mvList[i].mvId.toString());
            setState(() {
              qrCodeResult = "Vendor doesn't Exist";
              isLoading = false;
              flag = true;
            });
            //showLongToast("Vendor doesn't Exist");
            log("Vendor doesn't Exist");
          } else {
            log("ooooooooooooooook");

            // log(value.toString());
            setState(() {
              qrCodeResult = result;
              isLoading = true;
              flag = false;
            });

            log(mvId[1].toString());

            await getShopList1ByMV(mvId[1]).then((value) {
              setState(() {
                shoplist = value!;
                isLoading = false;
              });
            });
            break;
          }
        }
        if (flag == true) {
          showLongToast("Vendor doesn't Exist");
        }
      } else {
        setState(() {
          qrCodeResult = "Vendor doesn't Exist";
          isLoading = false;
          flag = true;
        });
        showLongToast("Vendor doesn't Exist");
      }
    }

    setState(() {
      isLoading = false;
    }); //barcode scnner
  }

  @override
  void initState() {
    getMvList();
    openQRCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Vendor Details"),
          backgroundColor: FoodAppColors.tela,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : shoplist.isEmpty
                ? Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          "Result",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          qrCodeResult,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.blue, width: 3.0),
                                borderRadius: BorderRadius.circular(20.0)),
                            padding: EdgeInsets.all(15.0),
                            textStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            openQRCode();
                            // try{
                            //   BarcodeScanner.scan()    this method is used to scan the QR code
                            // }catch (e){
                            //   BarcodeScanner.CameraAccessDenied;   we can print that user has denied for the permisions
                            //   BarcodeScanner.UserCanceled;   we can print on the page that user has cancelled
                            // }
                          },
                          child: Text(
                            "Open Scanner",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      controller: ScrollController(),
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      padding:
                          EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                      itemCount: shoplist.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
                          child: InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                                // MaterialPageRoute(
                                //     builder: (context) => MV_products(
                                //         shoplist[index].company ?? "",
                                //         shoplist[index].mvId ?? "",
                                //         "")

                                    // Sbcategory(
                                    //     shoplist[index].company,
                                    //     shoplist[index].mvId,
                                    //     shoplist[index].cat)

                                   // ),
                             // );
                            },
                            child: Container(
                              height: 230,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_SMALL),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[300]!,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  )
                                ],
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(
                                                  Dimensions.RADIUS_SMALL)),
                                          child: shoplist[index].pp != null
                                              ? shoplist[index].pp ==
                                                      "no-pp.png"
                                                  ? Image.asset(
                                                      "assets/images/logo.png",
                                                      height: 180,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl: FoodAppConstant
                                                              .logo_Image_mv +
                                                          shoplist[index].pp.toString(),
                                                      height: 160,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      fit: BoxFit.fill,
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                        color:
                                                            FoodAppColors.tela,
                                                      )),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(Icons.error),
                                                    )
                                              : Image.asset(
                                                  "assets/images/logo.png",
                                                  height: 160,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.fill,
                                                )),
                                    ]),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                shoplist[index].company ?? '',
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                shoplist[index].address ?? '',
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraSmall,
                                                    color: Theme.of(context)
                                                        .disabledColor),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  RatingBar.builder(
                                                    initialRating: (double
                                                            .parse(
                                                                shoplist[index]
                                                                    .reviews1??"") /
                                                        double.parse(shoplist[
                                                                index]
                                                            .reviews_total??"")),
                                                    minRating: 0,
                                                    itemSize: 15,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 1.0),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: double.parse(shoplist[
                                                                      index]
                                                                  .reviews_total??"") >
                                                              0
                                                          ? FoodAppColors.tela
                                                          : Colors.grey,
                                                      size: 5,
                                                    ), onRatingUpdate: (double value) {  },
                                                    /* onRatingUpdate: (rating) {
                                                            // _ratingController=rating;
                                                            print(rating);
                                                          },*/
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "(${shoplist[index].reviews_total})",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              //rating
                                            ]),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        );
                      },
                    ),
                  ));
  }
}

class BarcodeScannerScreen extends StatefulWidget {
  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchEnabled,
              builder: (context, state, child) {
                switch (state as bool) {
                  case true:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  case false:
                    return const Icon(Icons.flash_off);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              Navigator.pop(context, barcode.rawValue);
              return;
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
