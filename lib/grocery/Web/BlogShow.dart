import 'package:ecoshine24/grocery/Web/videoPlay.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/model/BlogModel.dart';
import 'package:ecoshine24/grocery/model/productmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
// import 'package:ecoshine24/grocery/screen/SearcBlogs.dart';
import 'package:share_plus/share_plus.dart';

import 'WebviewTermandCondition.dart';

class BlogScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<BlogScreen> {
  static List<BlogModel> topProducts = [];
  static List<Products> featurePoducts = [];
  static List<Products> breakingPoducts = [];
  bool flag = false;
  @override
  void initState() {
    getfeature("top", "20").then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          topProducts = usersFromServe!;
          topProducts.length > 0 ? flag = false : flag = true;
        });
      }
    });
    // getfeature("featured", "10").then((usersFromServe) {
    //   if (this.mounted) {
    //     setState(() {
    //       featurePoducts= usersFromServe;
    //
    //     });
    //   }
    // });
    //
    // getfeature("breaking", "10").then((usersFromServe) {
    //   if (this.mounted) {
    //     setState(() {
    //       breakingPoducts= usersFromServe;
    //
    //     });
    //   }
    // });

    // TODO: implement initState
    super.initState();
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GroceryAppColors.black,
        title: InkWell(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => SearchBlogs()),);
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 70,
            height: 40,
            padding: EdgeInsets.symmetric(
//              vertical: 10,
//                  horizontal: 10,
                ),
            child: Material(
              color: Colors.white,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                  child: Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: TextField(
                  enabled: false,
                  /*      onChanged: (string) {

                        if(string!=null) {

                          searchval(string).then((usersFromServe) {
                            setState(() {
                              users = usersFromServe;
                              if(users!=null) {
                                suggestionList = users;
                              }
                            });
                          });
                        }

                        _debouncer.run(() {
                          setState(() {
                            suggestionList = users
                                .where((u) => (u.productName
                                .toLowerCase()
                                .contains(string.toLowerCase()) ))
                                .toList();
                          });
                        });
                      },*/
                  style: TextStyle(color: Colors.green[900]),
                  decoration: InputDecoration(
                    hintText: 'Search Your Blogs',
                    hintStyle: TextStyle(color: Colors.teal[200]),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              )),
            ),
          ),
        ),
        // Center(child: Text("Blogs")),
      ),
      // backgroundColor: AppColors.white,
      body: flag
          ? Center(
              child: Text("No blog is avaliable!"),
            )
          : Container(
              child: CustomScrollView(slivers: <Widget>[
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        topProducts.length > 0
                            ? Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  itemCount: topProducts == null
                                      ? 0
                                      : topProducts.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            getScreen(
                                                topProducts[index].title ?? "",
                                                topProducts[index].image ?? "",
                                                topProducts[index].mainCss ??
                                                    "",
                                                topProducts[index]),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: GroceryAppColors.tela,
                                ),
                              ),
                      ]),
                  childCount: 1,
                ))
              ]),
            ),
    );
  }

  getScreen(String text, String url1, String shhortdesc, BlogModel pro) {
    print("url1${url1}");
    // print(shhortdesc);
    // print("shhortdesc");
    return Container(
      color: GroceryAppColors.white,
      margin: EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // SizedBox(height: 10,),

          Stack(
            children: [
              url1 != null
                  ? InkWell(
                      onTap: () {
                        pro.youtube!.length > 1
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoPlayer(pro)),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebViewClass(
                                        pro.title ?? "",
                                        GroceryAppConstant.mainurl +
                                            pro.url.toString())),
                              );
                      },
                      child: Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: url1 != null || !url1.isEmpty
                            ? CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: pro.youtube!.length > 1
                                    ? url1
                                    : GroceryAppConstant.Product_Imageurl6 +
                                        url1,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                              )
                            : Image.asset("assets/images/logo.png"),
                      ),
                    )
                  : const SizedBox.shrink(),
              pro.youtube!.length > 1 ? profile(pro) : Row(),
            ],
          ),

          Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                text,
                style: TextStyle(fontSize: 16),
              )),

          Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Text(
                pro.heading ?? "",
                maxLines: 3,
                style: TextStyle(fontSize: 14, color: Colors.blueGrey),
              )),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: _PostStats(post: pro),
          ),
        ],
      ),
    );
  }

  Widget profile(BlogModel pro) {
    return Container(
      margin: EdgeInsets.only(top: 90),
      child: Align(
          alignment: Alignment.topCenter,
          child: InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayer(pro)),);
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: GroceryAppColors.tela,
              child: ClipOval(
                child: SizedBox(
                    child: Image.asset(
                  "assets/images/play.png",
                  width: 30.0,
                  height: 30.0,
                )),
              ),
            ),
          )),
    );
  }

  Widget profile1(Products pro) {
    return Container(
      margin: EdgeInsets.only(top: 70),
      child: Align(
          alignment: Alignment.topCenter,
          child: InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayer(pro)),);
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: GroceryAppColors.tela,
              child: ClipOval(
                child: SizedBox(
                    child: Image.asset(
                  "assets/images/play.png",
                  width: 30.0,
                  height: 30.0,
                )),
              ),
            ),
          )),
    );
  }
}

class _PostStats extends StatelessWidget {
  final BlogModel? post;

  const _PostStats({
    Key? key,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                /*  Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.thumb_up,
                    size: 10.0,
                    color: Colors.white,
                  ),
                ),*/
                // ${Jiffy(post.addedOn.substring(0,10).trim(), "dd/MM/yyyy").format("yyyy/MM/dd")},
                // const SizedBox(width: 4.0),
                Container(
                  child: Text(
                    '${post!.addedOn!.substring(0, 10)}  ',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),

            // const SizedBox(width: 10.0),
            // Text(
            //   '100 Comments',
            //   style: TextStyle(
            //     color: Colors.grey[600],
            //   ),
            // ),
            const SizedBox(width: 8.0),
            Container(
              // alignment: Alignment.center,
              child: _PostButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.grey[600],
                    size: 20.0,
                  ),
                  label: '',
                  onTap: () {
                    print("share");
                    Share.share(
                        GroceryAppConstant.mainurl + post!.url.toString());
                  }),
            ),

            Container(
              margin: EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  Container(
                    // margin: EdgeInsets.only(left: 10,),
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.remove_red_eye,
                      size: 10.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Container(
                    child: Text(
                      '${post!.counts}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // const Divider(),
        /* Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PostButton(
              icon: Icon(
                // MdiIcons.thumbUpOutline,
                Icons.thumb_up,
                color: Colors.grey[600],
                size: 20.0,
              ),
              label: 'Like',
              onTap: () => print('Like'),
            ),
            _PostButton(
              icon: Icon(
                Icons.chat,
                color: Colors.grey[600],
                size: 20.0,
              ),
              label: 'Comment',
              onTap: () {

                // Navigator.push(context, MaterialPageRoute(builder: (context) => CommentPage()),);
              },
            ),
            SizedBox(width: MediaQuery.of(context).size.width/3-85,),
            Container(
              // alignment: Alignment.center,
              child: _PostButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.grey[600],
                    size: 20.0,
                  ),
                  label: 'Share',
                  onTap: () {
                    print("share");
                    Share.share("https://www.youtube.com/watch?v="+post.youtube);
                  }
              ),
            )
          ],
        ),*/
      ],
    );
  }

  shairApp(String id) {
    Share.share("https://www.youtube.com/watch?v=" + id);
  }
}

class _PostButton extends StatelessWidget {
  final Icon? icon;
  final String? label;
  final void Function()? onTap;

  const _PostButton({
    Key? key,
    @required this.icon,
    @required this.label,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.only(left: 12.0),
            height: 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                icon!,
                const SizedBox(width: 4.0),
                Text(label ?? ""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
