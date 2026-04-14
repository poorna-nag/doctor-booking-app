import 'package:flutter/material.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/model/cardmodel.dart';

class CartItemShow extends StatefulWidget {
  @override
  _CartItemShowState createState() => _CartItemShowState();
}

class _CartItemShowState extends State<CartItemShow> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note>? noteList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = [];
//      updateListView();
    }
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Container(
            margin: EdgeInsets.only(left: 20.0),
            child: InkWell(
                onTap: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => ProductDetails()),
//                  );
                },
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                this.noteList![position].image,
                                fit: BoxFit.cover,
                                height: 120,
                                width: 90,
                              )

                              /*    CachedNetworkImage(
                              fit: BoxFit.cover,height: 120,width: 90,
                              imageUrl: this.noteList[position].image,
                              placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator()
                              ),
                              errorWidget: (context, url, error) => new Icon(Icons.error),
                            ),*/
                              ),
                        ),

                        /* RichText(text: TextSpan(
                    children: [
                      TextSpan(text: '$name \n', style: TextStyle(fontSize: 20),),
                      TextSpan(text: 'by: $brand \n', style: TextStyle(fontSize: 16, color: Colors.grey),),

                      TextSpan(text: '\$${price.toString()} \t', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      TextSpan(text: 'ON SALE ' ,style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.red),),


                    ], style: TextStyle(color: Colors.black)
                ),)*/
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 1),
                              child: Text(
                                this.noteList![position].title,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 1),
                              child: Text('\$200',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Text('(\$400)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough)),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                )));
        ;
      },
    );
  }

//
//  void updateListView() {
//
//    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
//    dbFuture.then((database) {
//
//      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
//      noteListFuture.then((noteList) {
//        setState(() {
//          this.noteList = noteList;
//          this.count = noteList.length;
//        });
//      });
//    });
//  }
}
