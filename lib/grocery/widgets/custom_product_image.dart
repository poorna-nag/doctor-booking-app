import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomProductImage extends StatefulWidget {
  final String? imageUrl;
  final String? fallbackUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String uniqueKey;

  const CustomProductImage({
    Key? key,
    required this.imageUrl,
    this.fallbackUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    required this.uniqueKey,
  }) : super(key: key);

  // Custom cache manager (10s stale, 50 objects)
  static final CacheManager _productCacheManager = CacheManager(
    Config(
      'custom_product_cache',
      stalePeriod: Duration(seconds: 10),
      maxNrOfCacheObjects: 50,
    ),
  );

  // Clear the custom image cache
  static Future<void> clearCache() async {
    await _productCacheManager.emptyCache();
  }

  @override
  State<CustomProductImage> createState() => _CustomProductImageState();
}

class _CustomProductImageState extends State<CustomProductImage> {
  bool _isLoading = true;
  bool _hasError = false;
  String? _currentUrl;
  


  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(CustomProductImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl || oldWidget.uniqueKey != widget.uniqueKey) {
      _loadImage();
    }
  }

  void _loadImage() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final url = widget.imageUrl ?? widget.fallbackUrl;
    if (url == null || url.isEmpty) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    _currentUrl = url;
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.imageUrl ?? widget.fallbackUrl;

    if (url == null || url.isEmpty) {
      return _buildErrorWidget();
    }

    // Encode only the path segments to safely handle spaces and parentheses
    String encodedUrl;
    try {
      final Uri parsed = Uri.parse(url);
      final String encodedPath = parsed.pathSegments.map((s) => Uri.encodeComponent(s)).join('/');
      final Uri rebuilt = Uri(
        scheme: parsed.scheme,
        userInfo: parsed.userInfo.isEmpty ? null : parsed.userInfo,
        host: parsed.host,
        port: parsed.hasPort ? parsed.port : null,
        path: encodedPath,
        query: parsed.query.isEmpty ? null : parsed.query,
        fragment: parsed.fragment.isEmpty ? null : parsed.fragment,
      );
      encodedUrl = rebuilt.toString();
    } catch (_) {
      // Fallback to encodeFull if parsing fails for any reason
      encodedUrl = Uri.encodeFull(url);
    }

    // Use encoded URL as cache key to avoid collisions
    final String cacheKey = encodedUrl;

    return CachedNetworkImage(
      key: ValueKey('${widget.uniqueKey}_$cacheKey'),
      imageUrl: encodedUrl,
      cacheKey: cacheKey,
      cacheManager: CustomProductImage._productCacheManager,

      width: widget.width,
      height: widget.height,
      fit: widget.fit,

      useOldImageOnUrlChange: false,
      fadeInDuration: Duration(milliseconds: 150),
      fadeOutDuration: Duration(milliseconds: 100),
      placeholder: (context, url) {
        return _buildLoadingWidget();
      },
      errorWidget: (context, url, error) {
        // Helpful for diagnosing broken URLs
        // ignore: avoid_print
        print('CustomProductImage error for URL: ' + url.toString() + ' -> ' + error.toString());
        return _buildErrorWidget();
      },
      imageBuilder: (context, imageProvider) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(
              image: imageProvider,
              fit: widget.fit,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey[400],
        size: 24,
      ),
    );
  }
}
