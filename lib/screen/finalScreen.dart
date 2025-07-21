import 'package:aladdinmart/grocery/General/Home.dart';
import 'package:flutter/material.dart';
import 'package:aladdinmart/General/AppConstant.dart';

class ShowInVoiceId extends StatefulWidget {
  final String invoice;
  const ShowInVoiceId(this.invoice) : super();

  @override
  _ShowInVoiceIdState createState() => _ShowInVoiceIdState();
}

class _ShowInVoiceIdState extends State<ShowInVoiceId> {
 _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(''),
            content: new Text('Do you want to continue Shopping?'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text(""),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () =>
                    // Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) =>  FoodAppHomeScreen())),
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => GroceryApp()),
                        (route) => false),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Container(
        child: AspectRatio(
          aspectRatio: 100 / 100,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.teal[50],
            ),
            child: Center(
              child: Container(
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 150),
                          child: SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: Image.asset('assets/images/orderdone1.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: ListTile(
                          title: Center(
                            child: Text(
                              "Order Placed",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, bottom: 1),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      height: 30,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
//                                    borderRadius: BorderRadius.(10.0),
                                      ),
                                      child: Center(
                                        child: Text('Order ID',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w700,
                                            )),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    height: 30,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
//                                    borderRadius: BorderRadius.(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.invoice,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => GroceryApp()),
                                          (route) => false);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 180,
                                      decoration: BoxDecoration(
                                          color: FoodAppColors.tela,
                                          border: Border.all(
                                              color: FoodAppColors.tela)),
                                      child: Center(
                                        child: Text(
                                          "Continue Shopping?",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: FoodAppColors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
