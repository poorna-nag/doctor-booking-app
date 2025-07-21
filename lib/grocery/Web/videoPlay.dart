import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/model/BlogModel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final BlogModel products;
  const VideoPlayer(this.products) : super();

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  YoutubePlayerController? _controller;

  // static List<BlogModel> topProducts = List();

  @override
  void didUpdateWidget(VideoPlayer oldWidget) {
    _controller?.dispose();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // print(widget.products.youtube);
    _getCount();
    _controller = YoutubePlayerController(
      initialVideoId: widget.products.youtube.toString(),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        // mute: true,
      ),
    );

    // getfeature(widget.products.bodytext2, "10").then((usersFromServe) {
    //   if (this.mounted) {
    //     setState(() {
    //       topProducts= usersFromServe;
    //
    //     });
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YoutubePlayer(
                controller: _controller!,
                showVideoProgressIndicator: true,
              ),

              Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    widget.products.title.toString(),
                    style: TextStyle(fontSize: 16),
                  )),

              Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: Text(
                    widget.products.heading.toString(),
                    maxLines: 3,
                    style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                  )),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: _PostStats(post: widget.products),
              ),

              // topProducts.length>0? Container(
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     primary: false,
              //     scrollDirection: Axis.vertical,
              //     itemCount:topProducts==null?0:topProducts.length,
              //
              //     itemBuilder: (BuildContext context, int index) {
              //       return Container(
              //         child: Card(
              //           child: Column(
              //             children: [
              //
              //
              //               getScreen(topProducts[index].title  ,topProducts[index].image,topProducts[index].mainCss,topProducts[index]),
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ): Center(child: CircularProgressIndicator(backgroundColor: AppColors.tela,),),
            ],
          ),
        ),
      ),
    );
  }

  getScreen(String text, String url1, String shhortdesc, BlogModel pro) {
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoPlayer(pro)),
                        );
                      },
                      child: Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: url1,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                        ),
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
                pro.menuName.toString(),
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

  Future _getCount() async {
    var map = new Map<String, dynamic>();
    map['blog'] = widget.products.pageId;
    map['shop_id'] = GroceryAppConstant.Shop_id;

    final response = await http.post(Uri.parse(GroceryAppConstant.base_url + 'api/blogCount.php'), body: map);
    if (response.statusCode == 200) {
    } else
      throw Exception("Unable to get Employee list");
  }

  Widget profile(BlogModel pro) {
    return Container(
      margin: EdgeInsets.only(top: 90),
      child: Align(
          alignment: Alignment.topCenter,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoPlayer(pro)),
              );
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
            /*Row(
              children: [
                Container(
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
                ),

                const SizedBox(width: 4.0),
                Container(
                  child: Text(
                    '200',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),*/

            const SizedBox(width: 20.0),
            Text(
              '${post!.addedOn.toString().substring(0, 10)} ',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
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
                    Share.share(GroceryAppConstant.mainurl + post!.url.toString());
                  }),
            ),
            // Text(
            //   '96 Shares',
            //   style: TextStyle(
            //     color: Colors.grey[600],
            //   ),
            // )

            Container(
              margin: EdgeInsets.only(right: 40),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: 10,
                    ),
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
        /*const Divider(),
        Row(
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
            */ /*_PostButton(
              icon: Icon(
                icons.commentOutline,
                color: Colors.grey[600],
                size: 20.0,
              ),
              label: 'Comment',
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommentPage()),);
              },
            ),*/ /*
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
                  Share.share("https://www.youtube.com/watch?v="+post.youtube);
                },
              ),
            )
          ],
        ),*/
      ],
    );
  }
}

class _PostButton extends StatelessWidget {
  final Icon? icon;
  final String? label;
  final Function()? onTap;

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
                Text(label.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
