import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:intl/intl.dart';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:aladdinmart/StyleDecoration/styleDecoration.dart';
import 'package:aladdinmart/dbhelper/database_helper.dart';
import 'package:aladdinmart/model/CustmerModel.dart';
import 'package:http/http.dart' as http;
import 'package:aladdinmart/model/OrderShow.dart';
import 'package:aladdinmart/model/banktransation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_money.dart';

class WalltReport extends StatefulWidget {
  @override
  _WalltReportState createState() => _WalltReportState();
}

class _WalltReportState extends State<WalltReport> {
  List<ShowOrderDetail> orderlist = [];
  static const int PAGE_SIZE = 10;
  int _current = 0;
  List<String>? list;
  var newDate;
  String wallet = "0";
  String? md5Key;
  ValueNotifier dialogLoader = ValueNotifier(false);
  TextEditingController amountController = TextEditingController();
  TextEditingController userNoteController = TextEditingController();
  List<CustmerModel> walletlist = [];
  bool isLoading = true;

  Future<void> getvalue() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String? wal = pre.getString("wallet");
    String? user_id = pre.getString("user_id");
    print("user--------->${user_id}");

    setState(() {
      wallet = wal??"";
      FoodAppConstant.user_id = user_id??"";
    });
  }

  @override
  void initState() {
    super.initState();
    getvalue();
    init();
  }

  init() async {
    await mywallet(FoodAppConstant.user_id).then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          walletlist = usersFromServe!;
          wallet = walletlist[0].wallet??"";
          // isLoading = false;
        });
      }
    });
    setState(() {
      md5Key = generateMd5(FoodAppConstant.Shop_id + FoodAppConstant.user_id);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodAppColors.white,
      appBar: AppBar(
        backgroundColor: FoodAppColors.tela,
        leading: IconButton(
            color: Colors.white,
            icon: Icon(
              Icons.arrow_back,
              color: FoodAppColors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Wallet Points",
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 15.0),
        //     child: Center(
        //         child: MaterialButton(
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => AddMoney(),
        //           ),
        //         );
        //       },
        //       elevation: 3,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       color: FoodAppColors.white,
        //       textColor: FoodAppColors.sellp,
        //       child: Text(
        //         "Add",
        //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        //       ),
        //     )),
        //   ),
        //   Padding(
        //     padding: const EdgeInsets.only(right: 15.0),
        //     child: Center(
        //       child: Text(
        //         "${wallet != null ? wallet : "0"}",
        //         style: TextStyle(color: Colors.white, fontSize: 20),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height * .8,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : wallet.isEmpty
                  ? Center(
                      child: Text("Wallet Empty"),
                    )
                  : Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            color: FoodAppColors.sellp,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Wallet Points: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: FoodAppColors.white,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      "${wallet != null ? wallet : "0"}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: FoodAppColors.white,
                                          fontSize: 17),
                                    ),
                                  ],
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddMoney(),
                                      ),
                                    );
                                  },
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: FoodAppColors.white,
                                  textColor: FoodAppColors.sellp,
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height - 90,
                          child: PagewiseListView(
                              pageSize: PAGE_SIZE,
                              itemBuilder: this._itemBuilder,
                              pageFuture: (pageIndex) => get_walletrecord(
                                  FoodAppConstant.user_id,
                                  pageIndex !* PAGE_SIZE)),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _itemBuilder(context, WalletUser entry, _) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: FoodAppColors.red,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 10,
                        ),
                        child: Text(
                          "Invoice Id",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Text(
                          entry.wInvoiceId??"",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 30,
                    width: 70,
                    child: Card(
                      child: Center(
                        child: Text(
                          double.parse(entry.wIn??"") > 0 ? "Credit" : "Debit",
                          style: TextStyle(
                              color: double.parse(entry.wIn??"") > 0
                                  ? FoodAppColors.sellp
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 15),
                child: Text(entry.wNote??""),
              ),
            ),
            Divider(),
            Container(
              height: 50,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: () {
                            print("amount------>${entry.wOut}");
                            print("amount------>${entry.wIn}");
                          },
                          child: Text(
                            "Amount",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          "\u{20B9}${double.parse(entry.wIn??"") > 0 ? entry.wIn : entry.wOut}",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Date",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          entry.wDate??"",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _displayDialog(BuildContext context, WalletUser entry) async {
    bool flag = false;
    StateSetter _setState;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'Transation Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            entry.wDate == null ? '' : entry.wDate??"",
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)
                                .copyWith(fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          child: Text(
                            entry.wTransactionId == "0"
                                ? ''
                                : entry.wTransactionId??"",
                            overflow: TextOverflow.fade,
                            style: TextStyle(fontSize: 15, color: Colors.grey)
                                .copyWith(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            entry.wIn != "0" ? entry.wIn ??"": entry.wOut??"",
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)
                                .copyWith(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          child: Text(
                            entry.wOut == "0" ? "Cr." : "Dr.",
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: entry.wIn == "0"
                                        ? Colors.orange
                                        : Colors.grey)
                                .copyWith(fontSize: 15),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 6),
                Text("Note: ${entry.wNote}",
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 15, color: FoodAppColors.darkGray)),
                SizedBox(height: 6),
                Text(" Invoice Id:  ${entry.wInvoiceId}",
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 15, color: FoodAppColors.darkGray)),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text(
                  'Cancel',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  String textval1 = "Start date";
  DateTime? selectedDate;
/*
   bool _decideWhichDayToEnable(DateTime day) {
     if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
         day.isBefore(DateTime.now().add(Duration(days: 30))))) {
       return true;
     }
     return false;
   }

   showCalander(ShowOrderDetail entry){

     showDatePicker(
       context: context,
       initialDate: DateTime.now(),
       firstDate: DateTime(2000),
       lastDate: DateTime(2025),
       selectableDayPredicate: _decideWhichDayToEnable,
     ).then((date){
       setState(() {

         selectedDate=date;
         String formattedDate = DateFormat('yyyy-MM-dd ').format(selectedDate!=null?selectedDate:DateTime.now());
         entry.subDate=formattedDate;
         textval1=formattedDate;
         print(formattedDate);
       });
     });
   }*/
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future requestWithdrwal(String amount, String userNote) async {
    print("working-----<");
    String link = "${FoodAppConstant.base_url}api/request_withdrawal.php";
    Map body = {
      "key": md5Key,
      "shop_id": FoodAppConstant.Shop_id,
      "user_id": FoodAppConstant.user_id,
      "amount": amount,
      "user_note": userNote,
    };
    var response = await http.post(Uri.parse(link), body: body);
    var responseData = jsonDecode(response.body);
    print("response---->${responseData}");
    if (response.statusCode == 200) {
      if (responseData['success'] == false) {
        showLongToast(responseData["msg"]);
        setState(() {
          dialogLoader.value = false;
        });
      } else {
        setState(() {
          dialogLoader.value = false;
        });
        showLongToast(responseData["msg"]);
      }
    } else {
      showLongToast(responseData['msg']);
      setState(() {
        dialogLoader.value = false;
      });
    }
  }

  void showBottomDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: _buildDialogContent(),
        );
      },
      transitionBuilder: (_, animation1, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }

  Widget _buildDialogContent() {
    return IntrinsicHeight(
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 1.5,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Material(
          color: FoodAppColors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    child: Card(
                      elevation: 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: dialogLoader,
                builder: (BuildContext context, value, Widget? child) {
                  return Container(
                    child: dialogLoader.value
                        ? CircularProgressIndicator()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                controller: amountController,
                                decoration: InputDecoration(
                                  labelText: 'Enter withdrawal amount',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 3, color: FoodAppColors.sellp),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 3,
                                        color: FoodAppColors.boxColor1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: userNoteController,
                                decoration: InputDecoration(
                                  labelText: 'Enter note',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 50.0, horizontal: 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 3, color: FoodAppColors.sellp),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 3,
                                        color: FoodAppColors.boxColor1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 50,
                                width: 100,
                                child: InkWell(
                                  onTap: () {
                                    print(
                                        "amount----->${amountController.text}");
                                    print(
                                        "amount----->${userNoteController.text}");
                                    if (amountController.text.isNotEmpty) {
                                      dialogLoader.value = true;
                                      requestWithdrwal(amountController.text,
                                          userNoteController.text);
                                    } else {
                                      showLongToast(
                                          "Amount field can't be empty...");
                                    }
                                  },
                                  child: Card(
                                    color: FoodAppColors.sellp,
                                    child: Center(
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: FoodAppColors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
