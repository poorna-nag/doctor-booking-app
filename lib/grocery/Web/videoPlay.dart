import 'package:flutter/material.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/model/BlogModel.dart';
import 'package:share_plus/share_plus.dart';

class VideoPlayer extends StatefulWidget {
  final BlogModel products;
  const VideoPlayer(this.products) : super();

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  @override
  void initState() {
    _getCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 72,
                color: GroceryAppColors.homeiconcolor,
              ),
              const SizedBox(height: 16),
              Text(
                widget.products.title.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.products.heading.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
              const SizedBox(height: 20),
              const Text(
                'Video playback is disabled in this simplified build.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getCount() async {
    final map = <String, dynamic>{};
    map['blog'] = widget.products.pageId;
    map['shop_id'] = GroceryAppConstant.Shop_id;
  }

  Widget _postStats({BlogModel? post}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildComments(number: "1000", title: "comments"),
        _buildShares(number: "300", title: "shares"),
        _buildPosts(number: post!.Pageid.toString(), title: "Posts"),
      ],
    );
  }

  _buildComments({String? number, String? title}) {
    return Column(
      children: <Widget>[
        Text(
          number!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3.0),
        Text(
          title!,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  _buildShares({String? number, String? title}) {
    return Column(
      children: <Widget>[
        Text(
          number!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3.0),
        Text(
          title!,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  _buildPosts({String? number, String? title}) {
    return Column(
      children: <Widget>[
        Text(
          number!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3.0),
        Text(
          title!,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
