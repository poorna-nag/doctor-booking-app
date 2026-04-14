import 'dart:convert';
import 'package:ecoshine24/grocery/BottomNavigation/allcategory.dart';
import 'package:cached_network_image/cached_network_image.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ecoshine24/constent/app_constent.dart';
import 'package:ecoshine24/grocery/Auth/signin.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/model/CategaryModal.dart';
import 'package:ecoshine24/grocery/model/Gallerymodel.dart';
import 'package:ecoshine24/grocery/model/productmodel.dart';
import 'package:ecoshine24/grocery/model/slidermodal.dart';
import 'package:ecoshine24/grocery/screen/detailpage.dart';
import 'package:ecoshine24/grocery/screen/productlist.dart';
import 'package:ecoshine24/grocery/screen/secondtabview.dart';
import 'package:ecoshine24/grocery/screen/SubCategry.dart';
import 'package:ecoshine24/grocery/widgets/category_selection_modal.dart';
import 'package:ecoshine24/grocery/widgets/custom_product_image.dart';
import 'package:ecoshine24/grocery/BottomNavigation/wishlist.dart';
import 'package:ecoshine24/grocery/screen/ShowAddress.dart';
import 'package:ecoshine24/grocery/screen/SearchScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<PromotionBanner> createAlbum(String shop_id) async {
  var body = {"shop_id": GroceryAppConstant.Shop_id};
  final response = await http.post(
      Uri.parse('https://www.bigwelt.com/api/app-promo-banner.php'),
      body: body);
  print("response------>" + response.body);

  print("jsonDecode(response.body)---> ${jsonDecode(response.body)}");
  if (response.statusCode == 200) {
    return PromotionBanner.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class PromotionBanner {
  String? shopId;
  String? images;
  bool? status;
  String? msg;
  String? path;

  PromotionBanner({this.shopId, this.images, this.status, this.msg, this.path});

  PromotionBanner.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    images = json['images'];
    status = json['status'];
    msg = json['msg'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['images'] = this.images;
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['path'] = this.path;
    return data;
  }
}

class GroceryAppHomeScreen extends StatefulWidget {
  final String? categoryId;

  const GroceryAppHomeScreen({Key? key, this.categoryId}) : super(key: key);

  @override
  GroceryAppHomeScreenState createState() => GroceryAppHomeScreenState();
}

class GroceryAppHomeScreenState extends State<GroceryAppHomeScreen>
    with WidgetsBindingObserver {
  static int cartvalue = 0;

  bool progressbar = true;

  // Custom cache manager for product images
  static const String _productCacheKey = 'productImageCache';
  late CacheManager _productCacheManager;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came back to foreground, force refresh images

      _forceRefreshImages();
    }
  }

  // Force rebuild counter
  int _rebuildCounter = 0;

  String selectedCategoryName = "Selected Category";
  String selectedCategoryImage = "";
  String? currentCategoryId; // Add this to track current category

  static List<String> imgList5 = [
    'https://www.liveabout.com/thmb/y4jjlx2A6PVw_QYG4un_xJSFGBQ=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/asos-plus-size-maxi-dress-56e73ba73df78c5ba05773ab.jpg',
    'https://www.thebalanceeveryday.com/thmb/lMeVfLyCZWVPdU5eyjFLyK4AYQs=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/metrostyle-catalog-df95d1ece06c4197b1da85e316a05f90.jpg',
    'https://rukminim1.flixcart.com/image/400/450/k3xcdjk0pkrrdj/sari/h/d/x/free-multicolor-combosr-28001-ishin-combosr-28001-original-imafa5257bxdzm5j.jpeg?q=90',
    'https://i.pinimg.com/474x/62/4e/ce/624ece8daf9650f1a382995b340dc1e9.jpg'
  ];

  int _current = 0;
  var _start = 0;
  static List<Categary> list = [];
  static List<Categary> list1 = [];
  static List<Categary> list2 = [];
  static List<Slider1> sliderlist = [];

  List<Products> topProducts = [];
  List<Products> topProducts1 = [];
  List<Products> dilofdayProducts = [];
  List<Slider1> bannerSlider = [];
  List<Gallery> galiryImage = [];
  final List<String> imgL = [];
  List<Products> products1 = [];
  List<Products> products3 = [];
  List<Products> bestProducts = [];
  double? sgst1, cgst1, dicountValue, admindiscountprice;
  PromotionBanner promotionBanner = PromotionBanner();
  String imageUrl = '';
  int cc = 0;

  double? mrp, totalmrp = 000;
  int _count = 1;

  String lastversion = "0";
  int? valcgeck;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  /* Future<void> checkForUpdate(BuildContext contex) async {
    packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    lastversion=version.substring(version.lastIndexOf(".")+1);

    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        valcgeck=int.parse(lastversion);
        _updateInfo = info;
        if(_updateInfo?.updateAvailable){
          Showpop();
        }
        _updateInfo?.updateAvailable == true;
        print(_updateInfo);
        print(version);
        print(_updateInfo.availableVersionCode-valcgeck);
        print(lastversion);
        print("_updateInfo.......");

//        showDilogue(contex);
        print(_updateInfo);
      });
    }).catchError((e) => _showError(e));
  }*/

  getPackageInfo() async {
    // Update checks are disabled because the old `new_version` package blocks
    // newer Android dependency versions required by the current toolchain.
    return;
  }

  final addController = TextEditingController();

  Position? position;

  getAddress(double lat, double long) async {
    var addresses = await placemarkFromCoordinates(lat, long);
    var first = addresses.first;
    setState(() {
      var address = first.subLocality.toString() +
          " " +
          first.subAdministrativeArea.toString() +
          " " +
          first.subThoroughfare.toString() +
          " " +
          first.thoroughfare.toString();

      addController.text = address.replaceAll("null", "");
    });
  }

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      GroceryAppConstant.latitude = position!.latitude;
      GroceryAppConstant.longitude = position!.longitude;
      print(
          ' lat ${GroceryAppConstant.latitude},${GroceryAppConstant.longitude}');
      getAddress(GroceryAppConstant.latitude, GroceryAppConstant.longitude);
    });
  }

  @override
  Future<void> _loadSelectedCategoryInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedCategoryName = prefs.getString("selectedCategoryName");
      String? savedCategoryImage = prefs.getString("selectedCategoryImage");
      String? savedCategoryId = prefs.getString("selectedCategoryId");

      if (savedCategoryName != null && savedCategoryName.isNotEmpty) {
        if (mounted) {
          setState(() {
            selectedCategoryName = savedCategoryName;
            selectedCategoryImage = savedCategoryImage ?? "";
          });
        }
      }

      if (savedCategoryId != null && savedCategoryId.isNotEmpty) {
        try {
          if (list.isNotEmpty) {
            try {
              var category =
                  list.firstWhere((cat) => cat.pcatId == savedCategoryId);

              if (mounted) {
                setState(() {
                  selectedCategoryImage = category.img ?? "";
                  print('Setting category image: ${category.img}'); // Debug log
                  if (category.pCats != null && category.pCats!.isNotEmpty) {
                    selectedCategoryName = category.pCats!;
                  }
                });

                _saveCategoryToPreferences(
                    selectedCategoryName, selectedCategoryImage);
              }
            } catch (e) {
              print("Category not found in main list, trying API: $e");
              try {
                var categories = await getData(savedCategoryId);
                if (categories != null && categories.isNotEmpty) {
                  var category = categories.first;

                  if (mounted) {
                    setState(() {
                      selectedCategoryImage = category.img ?? "";
                      if (category.pCats != null &&
                          category.pCats!.isNotEmpty) {
                        selectedCategoryName = category.pCats!;
                      }
                      print(
                          'Setting category image from API: ${category.img}'); // Debug log
                    });

                    _saveCategoryToPreferences(
                        selectedCategoryName, selectedCategoryImage);
                  }
                }
              } catch (apiError) {
                print("API call failed: $apiError");
                if (mounted) {
                  setState(() {
                    selectedCategoryName = "Category";
                    selectedCategoryImage = "";
                  });
                }
              }
            }
          } else {
            // If list is empty, try to fetch from API
            // First try to get the specific category by ID
            try {
              var specificCategory =
                  await getSpecificCategoryById(savedCategoryId);
              if (specificCategory != null) {
                if (mounted) {
                  setState(() {
                    selectedCategoryImage = specificCategory.img ?? "";
                    if (specificCategory.pCats != null &&
                        specificCategory.pCats!.isNotEmpty) {
                      selectedCategoryName = specificCategory.pCats!;
                    }
                  });

                  _saveCategoryToPreferences(
                      selectedCategoryName, selectedCategoryImage);
                }
              } else {
                // Fallback: try the original getData method
                var categories = await getData(savedCategoryId);
                if (categories != null && categories.isNotEmpty) {
                  var category = categories.first;

                  if (mounted) {
                    setState(() {
                      selectedCategoryImage = category.img ?? "";
                      if (category.pCats != null &&
                          category.pCats!.isNotEmpty) {
                        selectedCategoryName = category.pCats!;
                      }
                    });

                    _saveCategoryToPreferences(
                        selectedCategoryName, selectedCategoryImage);
                  }
                }
              }
            } catch (apiError) {
              print("API call failed for empty list: $apiError");
              if (mounted) {
                setState(() {
                  selectedCategoryName = "Category";
                  selectedCategoryImage = "";
                });
              }
            }
          }
        } catch (e) {
          print("Error loading category details: $e");
        }
      } else {
        // Set default fallback if no category is selected
        if (mounted) {
          setState(() {
            selectedCategoryName = "All Services";
            selectedCategoryImage = "";
          });
        }
      }
    } catch (e) {
      print("Error in _loadSelectedCategoryInfo: $e");
    }
  }

  // Save category data to SharedPreferences
  Future<void> _saveCategoryToPreferences(
      String categoryName, String categoryImage) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("selectedCategoryName", categoryName);
      await prefs.setString("selectedCategoryImage", categoryImage);
    } catch (e) {
      print("Error saving category to preferences: $e");
    }
  }

  // Initialize fallback data when APIs are unavailable
  void _initializeFallbackData() {
    if (mounted) {
      setState(() {
        // Set default category name if not loaded
        if (selectedCategoryName.isEmpty) {
          selectedCategoryName = "Category";
        }

        // Initialize empty lists to prevent null errors
        if (list.isEmpty) {
          list = [];
        }
        if (sliderlist.isEmpty) {
          sliderlist = [];
        }
        if (topProducts1.isEmpty) {
          topProducts1 = [];
        }
        if (topProducts.isEmpty) {
          topProducts = [];
        }
        if (dilofdayProducts.isEmpty) {
          dilofdayProducts = [];
        }
        if (products1.isEmpty) {
          products1 = [];
        }
        if (bestProducts.isEmpty) {
          bestProducts = [];
        }
        if (bannerSlider.isEmpty) {
          bannerSlider = [];
        }

        // Set default image URL
        if (imageUrl.isEmpty) {
          imageUrl = "";
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    currentCategoryId = widget.categoryId; // Initialize current category

    // Initialize custom cache manager with shorter cache duration
    _productCacheManager = CacheManager(
      Config(
        _productCacheKey,
        stalePeriod: Duration(minutes: 5), // Cache for 5 minutes only
        maxNrOfCacheObjects: 100, // Reduce cache size
      ),
    );

    _getCurrentLocation();
    _loadSavedCategoryOnInit(); // Load saved category and initialize

    if (GroceryAppConstant.Checkupdate) {
      getPackageInfo();
      GroceryAppConstant.Checkupdate = false;
    }

    // Initialize with fallback values in case APIs fail
    _initializeFallbackData();

    // Add listener for app lifecycle changes
    WidgetsBinding.instance?.addObserver(this as WidgetsBindingObserver);

    // Load categories (keeping for modal functionality)
    getData("0").then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            list = usersFromServe;
          });
        }
      }
    }).catchError((error) {
      print("Error loading categories: $error");
      // Categories will remain empty, but app won't crash
    });

    DatabaseHelper.getSlider().then((usersFromServe1) {
      if (this.mounted) {
        if (usersFromServe1 != null) {
          setState(() {
            sliderlist = usersFromServe1;
          });
        }
      }
    }).catchError((error) {
      print("Error loading slider: $error");
      // Slider will remain empty, but app won't crash
    });

    // Load products based on selected category
    String categoryIdToUse = currentCategoryId ?? "0";
    DatabaseHelper.getTopProduct("day", categoryIdToUse).then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            topProducts1 = usersFromServe;
          });
        }
      }
    }).catchError((error) {
      print("Error loading day products: $error");
    });

    DatabaseHelper.getTopProduct("top", categoryIdToUse).then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            topProducts = usersFromServe;
//          ScreenState.topProducts.add(topProducts[0]);
          });
        }
      }
    }).catchError((error) {
      print("Error loading top products: $error");
    });

    DatabaseHelper.getTopProduct1("", categoryIdToUse).then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            dilofdayProducts = usersFromServe;
          });
        }
      }
    }).catchError((error) {
      print("Error loading dilofday products: $error");
    });

    DatabaseHelper.getfeature("yes", "10").then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            products1 = usersFromServe;
//          ScreenState.topProducts.add(topProducts[0]);
          });
        }
      }
    }).catchError((error) {
      print("Error loading featured products: $error");
    });

    DatabaseHelper.getTopProduct("best", categoryIdToUse)
        .then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            bestProducts = usersFromServe;
          });
        }
      }
    }).catchError((error) {
      print("Error loading best products: $error");
    });

    getBanner().then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            bannerSlider = usersFromServe;
          });
        }
      }
    }).catchError((error) {
      print("Error loading banner: $error");
    });
    DatabaseHelper.getPromotionBanner(GroceryAppConstant.Shop_id).then((value) {
      if (this.mounted) {
        if (value != null) {
          // print("valueee--> ${value.path}");
          promotionBanner = value;
          imageUrl = value.path ?? "";
          setState(() {});

          print("my url--------->");
          print(GroceryAppConstant.mainurl +
              promotionBanner.path.toString() +
              promotionBanner.images.toString());
          var url = GroceryAppConstant.mainurl +
              promotionBanner.path.toString() +
              promotionBanner.images.toString();
        } else {
          print("Promotion banner data is null - API might be unavailable");
          // Set default values when API fails
          imageUrl = "";
        }
      }
    }).catchError((error) {
      print("Error loading promotion banner: $error");
      if (this.mounted) {
        imageUrl = "";
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(GroceryAppHomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh products when category changes
    if (oldWidget.categoryId != widget.categoryId) {
      currentCategoryId = widget.categoryId;

      // Clear all product lists immediately to prevent showing old data
      setState(() {
        topProducts = [];
        topProducts1 = [];
        dilofdayProducts = [];
        bestProducts = [];
      });

      // Reset rebuild counter and refresh products
      _rebuildCounter = 0;
      _refreshProductsForCategory();
    }
  }

  // Duplicate dispose removed; see unified dispose below

  // Load saved category during initialization
  Future<void> _loadSavedCategoryOnInit() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedCategoryId = prefs.getString("selectedCategoryId");

      // If we have a saved category, use it. Otherwise use widget.categoryId or default to "0"
      if (savedCategoryId != null && savedCategoryId.isNotEmpty) {
        currentCategoryId = savedCategoryId;
      } else if (widget.categoryId != null && widget.categoryId!.isNotEmpty) {
        currentCategoryId = widget.categoryId;
      } else {
        currentCategoryId = "0"; // Default category
      }

      // Load category info
      await _loadSelectedCategoryInfo();
    } catch (e) {
      print("Error loading saved category on init: $e");
      currentCategoryId = widget.categoryId ?? "0";
      await _loadSelectedCategoryInfo();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh products when returning to this screen
    if (mounted) {
      _rebuildCounter++;

      // First load the saved category info to ensure we have the right category
      _loadSavedCategoryAndRefresh();
    }
  }

  // Load saved category and refresh products
  Future<void> _loadSavedCategoryAndRefresh() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedCategoryId = prefs.getString("selectedCategoryId");

      if (savedCategoryId != null && savedCategoryId.isNotEmpty) {
        // Update current category to the saved one
        setState(() {
          currentCategoryId = savedCategoryId;
        });
      }

      // Load category info and refresh products
      await _loadSelectedCategoryInfo();
      // Refresh products but keep any currently shown items to avoid flashing empty UI
      _refreshProductsForCategory();
    } catch (e) {
      print("Error loading saved category: $e");
      // Fallback to normal refresh
      _refreshProductsForCategory();
    }
  }

  // Clear image cache for better image reload
  Future<void> _clearImageCache() async {
    try {
      await DefaultCacheManager().emptyCache();
      await _productCacheManager.emptyCache();

      // Also clear the custom product image cache
      await CustomProductImage.clearCache();

      // Force clear all cached images
      imageCache.clear();
      imageCache.clearLiveImages();

      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {}
  }

  // Force refresh all product images
  void _forceRefreshImages() {
    if (!mounted) return;
    setState(() {
      _rebuildCounter++;
    });
    // Keeping caches intact to avoid race conditions during category changes
    // CachedNetworkImage will still refetch on key/url change
  }

  Future<void> _refreshProductsForCategory() async {
    String categoryIdToUse = currentCategoryId ?? "0";

    if (!mounted) return;

    // Fetch new data
    try {
      final results = await Future.wait([
        DatabaseHelper.getTopProduct("day", categoryIdToUse),
        DatabaseHelper.getTopProduct("top", categoryIdToUse),
        DatabaseHelper.getTopProduct1("", categoryIdToUse),
        DatabaseHelper.getTopProduct("best", categoryIdToUse),
      ]);

      // Small delay to ensure cache is cleared
      await Future.delayed(Duration(milliseconds: 50));

      if (mounted) {
        setState(() {
          topProducts1 = results[0] as List<Products>;
          topProducts = results[1] as List<Products>;
          dilofdayProducts = results[2] as List<Products>;
          bestProducts = results[3] as List<Products>;
          // Bump rebuildCounter so CustomProductImage gets a new key
          _rebuildCounter++;
        });
        // No cache clear; keys and URLs will drive refresh
      }
    } catch (e) {
      // Handle error silently
    }
  }

  // Method to reload all products with current category
  Future<void> _loadProducts() async {
    _refreshProductsForCategory();
  }

  void getcartCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? cCount = pref.getInt("cc");
    setState(() {
      if (cCount != null) {
        //log("cart get count------------------->>$cCount");
        if (cCount == 0 || cCount < 0) {
          cc = 0;
          AppConstent.cc = 0;
          //log(" AppConstent.cc------------------->>${AppConstent.cc}");
        } else {
          setState(() {
            cc = cCount;
            AppConstent.cc = cCount;
          });
        }
        //log("cart count------------------->>$cc");
      }
    });
  }

  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    GroceryAppConstant.isLogin = false;
    int? Count = pref.getInt("itemCount");
    bool? ligin = pref.getBool("isLogin");
    setState(() {
      if (ligin != null) {
        GroceryAppConstant.isLogin = ligin;
      }
      if (Count == null) {
        GroceryAppConstant.groceryAppCartItemCount = 0;
      } else {
        GroceryAppConstant.groceryAppCartItemCount = Count;
      }
      // print(
      //     GroceryAppConstant.groceryAppCartItemCount.toString() + "itemCount");
    });
  }

  @override
  void dispose() {
    // Unified dispose implementation
    try {
      WidgetsBinding.instance?.removeObserver(this as WidgetsBindingObserver);
    } catch (_) {}

    addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 10) / 3;
    final double itemWidth = size.width / 2;

    return Scaffold(
      backgroundColor:
          Color(0xffF8FBFF), // Light medical blue background - matches signin
      body: SafeArea(
        child: Column(
          children: [
            // Medical Theme App Bar with Blue Gradient
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff1E88E5), // Medical blue from signin page
                    Color(0xff42A5F5), // Lighter medical blue
                    Color(0xff64B5F6), // Even lighter medical blue
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff1E88E5)
                        .withOpacity(0.3), // Medical blue shadow
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Location Text Only
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          addController.text.isEmpty
                              ? "Loading location..."
                              : addController.text,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Search Bar
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserFilterDemo(),
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: GroceryAppColors
                                .boxColor1, // Orange from eco-shine theme
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Search for medical services...",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.tune,
                            color: Color(0xff1E88E5), // Medical blue
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content Area
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: [
                                SizedBox(height: 5),

                                slider1Widget(),

                                //  Categories Section Start
                                list.length > 0
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'MEDICAL SERVICES',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        58, 173, 230, 1),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                                // Add View All Button
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AllCategory(
                                                                "All Medical Services",
                                                                '0'),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: Color(
                                                          0xff1E88E5), // Medical blue color
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color(
                                                                  0xff1E88E5)
                                                              .withOpacity(0.3),
                                                          blurRadius: 4,
                                                          offset: Offset(0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'View All',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.white,
                                                          size: 12,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                              padding: EdgeInsets.only(top: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.03),
                                                    blurRadius: 6,
                                                    offset: Offset(0, -1),
                                                  ),
                                                ],
                                              ),
                                              child: GridView.count(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                crossAxisCount: 4,
                                                childAspectRatio: 0.9,
                                                crossAxisSpacing: 12,
                                                mainAxisSpacing: 16,
                                                children: List.generate(
                                                  list.length > 8
                                                      ? 8
                                                      : list.length,
                                                  (index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        print(
                                                            "Category tapped: ID=${list[index].pcatId}, Name=${list[index].pCats}");
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ProductList(
                                                              list[index]
                                                                      .pcatId ??
                                                                  "",
                                                              list[index]
                                                                      .pCats ??
                                                                  "Product List",
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.06),
                                                              blurRadius: 8,
                                                              offset:
                                                                  Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // Modern Category Icon Container
                                                            Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .topLeft,
                                                                  end: Alignment
                                                                      .bottomRight,
                                                                  colors: [
                                                                    Color(
                                                                            0xff1E88E5) // Medical blue
                                                                        .withOpacity(
                                                                            0.15),
                                                                    Color(
                                                                            0xff1E88E5) // Lighter medical blue
                                                                        .withOpacity(
                                                                            0.1),
                                                                  ],
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                border:
                                                                    Border.all(
                                                                  color: Color(
                                                                          0xff1E88E5) // Medical blue
                                                                      .withOpacity(
                                                                          0.3),
                                                                  width: 1.5,
                                                                ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color(
                                                                            0xff1E88E5)
                                                                        .withOpacity(
                                                                            0.1),
                                                                    blurRadius:
                                                                        4,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            2),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child: list[index]
                                                                        .img!
                                                                        .isEmpty
                                                                    ? Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          gradient:
                                                                              LinearGradient(
                                                                            colors: [
                                                                              Color(0xff1E88E5).withOpacity(0.3), // Medical blue
                                                                              Color(0xff42A5F5).withOpacity(0.2), // Lighter medical blue
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .medical_services_outlined, // Medical icon
                                                                          color:
                                                                              Color(0xff1E88E5), // Medical blue
                                                                          size:
                                                                              22,
                                                                        ),
                                                                      )
                                                                    : CachedNetworkImage(
                                                                        imageUrl:
                                                                            GroceryAppConstant.logo_Image_Pcat +
                                                                                list[index].img!,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            gradient:
                                                                                LinearGradient(
                                                                              colors: [
                                                                                Color(0xff1E88E5).withOpacity(0.2), // Medical blue
                                                                                Color(0xff42A5F5).withOpacity(0.15), // Lighter medical blue
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                SizedBox(
                                                                              width: 20,
                                                                              height: 20,
                                                                              child: CircularProgressIndicator(
                                                                                color: Color(0xff1E88E5), // Medical blue
                                                                                strokeWidth: 2.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            gradient:
                                                                                LinearGradient(
                                                                              colors: [
                                                                                Color(0xff1E88E5).withOpacity(0.3), // Medical blue
                                                                                Color(0xff42A5F5).withOpacity(0.2), // Lighter medical blue
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.medical_services_outlined, // Medical icon
                                                                            color:
                                                                                Color(0xff1E88E5), // Medical blue
                                                                            size:
                                                                                22,
                                                                          ),
                                                                        ),
                                                                      ),
                                                              ),
                                                            ),

                                                            SizedBox(height: 3),

                                                            // Modern Category Text
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          2),
                                                              child: Text(
                                                                list[index]
                                                                        .pCats ??
                                                                    "",
                                                                maxLines: 1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 10,
                                                                  color: Color(
                                                                      0xff1E88E5), // Medical blue
                                                                  height: 1.1,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),

                                //  Categories Section End

                                //  Trending Services start
                                topProducts.length > 0
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  'TRENDING SERVICES',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 54, 161, 214),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.55,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 12),
                                            Container(
                                                height: 260.0,
                                                child: topProducts.isNotEmpty
                                                    ? ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            topProducts.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Container(
                                                            width: 160,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 16),
                                                            child: Card(
                                                              elevation: 8,
                                                              shadowColor: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          23,
                                                                          98,
                                                                          28)
                                                                  .withOpacity(
                                                                      0.2),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .topCenter,
                                                                    end: Alignment
                                                                        .bottomCenter,
                                                                    colors: [
                                                                      Colors
                                                                          .white,
                                                                      Color(
                                                                          0xFFF8F9FA),
                                                                    ],
                                                                  ),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <Widget>[
                                                                    // Image Section
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => ProductDetails(topProducts[index])),
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            120,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(20),
                                                                            topRight:
                                                                                Radius.circular(20),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(20),
                                                                            topRight:
                                                                                Radius.circular(20),
                                                                          ),
                                                                          child:
                                                                              CustomProductImage(
                                                                            uniqueKey:
                                                                                'top_product_${topProducts[index].productIs ?? topProducts[index].p_id ?? index}_${currentCategoryId ?? "0"}_$_rebuildCounter',
                                                                            imageUrl:
                                                                                (() {
                                                                              final String? imgUrlField = topProducts[index].img_url;
                                                                              final String? imgField = topProducts[index].img;
                                                                              String? finalUrl;
                                                                              if (imgUrlField != null && imgUrlField.isNotEmpty) {
                                                                                finalUrl = imgUrlField;
                                                                              } else if (imgField != null && imgField.isNotEmpty && imgField != 'no-img.png' && imgField != 'no-cover.png') {
                                                                                if (imgField.startsWith('http://') || imgField.startsWith('https://')) {
                                                                                  finalUrl = imgField;
                                                                                } else {
                                                                                  final String imageName = imgField.split('/').last;
                                                                                  finalUrl = GroceryAppConstant.Product_Imageurl + imageName;
                                                                                }
                                                                              } else {
                                                                                finalUrl = null;
                                                                              }
                                                                              return finalUrl;
                                                                            })(),
                                                                            fallbackUrl:
                                                                                "https://www.bigwelt.com/manage/uploads/gallery/no-img.png",
                                                                            height:
                                                                                120,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // Content Section
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(12),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            // Service Name
                                                                            Text(
                                                                              (() {
                                                                                final name = topProducts[index].productName ?? '';
                                                                                return name.length > 35 ? name.substring(0, 35) + '...' : name;
                                                                              })(),
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Color.fromARGB(255, 47, 45, 145),
                                                                                height: 1.3,
                                                                              ),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            SizedBox(height: 8),
                                                                            // Price Section
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  '₹${calDiscount(topProducts[index].buyPrice!, topProducts[index].discount!)}',
                                                                                  style: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Color.fromARGB(255, 48, 31, 145),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 6),
                                                                                Text(
                                                                                  '₹${topProducts[index].buyPrice}',
                                                                                  style: TextStyle(
                                                                                    fontSize: 12,
                                                                                    color: Colors.grey[600],
                                                                                    decoration: TextDecoration.lineThrough,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 12),
                                                                            // Book Button
                                                                            Container(
                                                                              width: double.infinity,
                                                                              height: 36,
                                                                              child: ElevatedButton(
                                                                                onPressed: () async {
                                                                                  if (GroceryAppConstant.isLogin) {
                                                                                    SharedPreferences pref = await SharedPreferences.getInstance();
                                                                                    String mrp_price = calDiscount(topProducts[index].buyPrice!, topProducts[index].discount!);
                                                                                    totalmrp = double.parse(mrp_price);
                                                                                    double dicountValue = double.parse(topProducts[index].buyPrice!) - totalmrp!;
                                                                                    String gst_sgst = calGst(mrp_price, topProducts[index].sgst!);
                                                                                    String gst_cgst = calGst(mrp_price, topProducts[index].cgst!);
                                                                                    String adiscount = calDiscount(topProducts[index].buyPrice!, topProducts[index].msrp!.isNotEmpty ? topProducts[index].msrp! : "0");
                                                                                    admindiscountprice = (double.parse(topProducts[index].buyPrice!) - double.parse(adiscount));
                                                                                    String color = "";
                                                                                    String size = "";
                                                                                    _addToproducts(topProducts[index].productIs!, topProducts[index].productName!, topProducts[index].img!, double.parse(mrp_price).round(), 1, color, size, topProducts[index].productDescription!, gst_sgst, gst_cgst, topProducts[index].discount!, dicountValue.toString(), topProducts[index].APMC!, admindiscountprice.toString(), topProducts[index].buyPrice!, topProducts[index].shipping!, topProducts[index].quantityInStock!);
                                                                                    AppConstent.cc++;
                                                                                    pref.setInt("cc", AppConstent.cc);
                                                                                  } else {
                                                                                    Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(builder: (context) => SignInPage()),
                                                                                    );
                                                                                  }
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Color.fromARGB(255, 40, 95, 177),
                                                                                  foregroundColor: Colors.white,
                                                                                  elevation: 0,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(12),
                                                                                  ),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Icon(Icons.add_shopping_cart, size: 16),
                                                                                    SizedBox(width: 6),
                                                                                    Text(
                                                                                      'Book',
                                                                                      style: TextStyle(
                                                                                        fontSize: 14,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        })
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  30,
                                                                  91,
                                                                  145),
                                                        ),
                                                      ))
                                          ],
                                        ),
                                      )
                                    : Container(),

                                //  Trending Services ends
                                //  Banner Slider starts
                                bannerSlider.length > 0
                                    ? Container(
                                        // margin: EdgeInsets.symmetric(
                                        //   horizontal: 20,
                                        // ),
                                        height: 150.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 15,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: bannerSlider.length > 0
                                            ? CarouselSlider.builder(
                                                itemCount: bannerSlider.length,
                                                options: CarouselOptions(
                                                  aspectRatio: 2.4,
                                                  viewportFraction: 1.0,
                                                  autoPlay: true,
                                                  autoPlayInterval:
                                                      Duration(seconds: 4),
                                                  enlargeCenterPage: true,
                                                ),
                                                itemBuilder:
                                                    (ctx, index, realIdx) {
                                                  return Container(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (bannerSlider[index]
                                                            .title!
                                                            .isNotEmpty) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Screen2(
                                                                        sliderlist[index].title ??
                                                                            "",
                                                                        "")),
                                                          );
                                                        } else if (bannerSlider[
                                                                index]
                                                            .description!
                                                            .isNotEmpty) {
                                                          // Navigation to banner details
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Color(
                                                                      0xFF1B5E20)
                                                                  .withOpacity(
                                                                      0.2),
                                                              blurRadius: 10,
                                                              offset:
                                                                  Offset(0, 4),
                                                            ),
                                                          ],
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child:
                                                              CachedNetworkImage(
                                                            key: Key(
                                                                'banner_${bannerSlider[index].img}'),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 180,
                                                            fit: BoxFit.cover,
                                                            imageUrl: bannerSlider[index]
                                                                            .img !=
                                                                        null &&
                                                                    bannerSlider[
                                                                            index]
                                                                        .img
                                                                        .toString()
                                                                        .isNotEmpty
                                                                ? GroceryAppConstant
                                                                        .Base_Imageurl +
                                                                    bannerSlider[
                                                                            index]
                                                                        .img
                                                                        .toString()
                                                                : "https://www.bigwelt.com/manage/uploads/gallery/no-img.png",
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xFFF8F9FA),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Color(
                                                                          0xFF1B5E20)),
                                                                ),
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xFFF8F9FA),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .broken_image_outlined,
                                                                color: Colors
                                                                    .grey[400],
                                                                size: 48,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor:
                                                      Color(0xFF1B5E20),
                                                ),
                                              ))
                                    : Container(),
                                //  Banner Slider ends

                                // // gettopproducts("best""0")best deals starts
                                // bestProducts != null
                                //     ? bestProducts.length > 0
                                //         ? Container(
                                //             color: Colors.white,
                                //             padding: EdgeInsets.only(bottom: 10),
                                //             child: Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment.spaceBetween,
                                //               children: <Widget>[
                                //                 Padding(
                                //                   padding: EdgeInsets.only(
                                //                       top: 8.0,
                                //                       left: 8.0,
                                //                       right: 8.0),
                                //                   child: Text(
                                //                     "BEST DEALS",
                                //                     style: TextStyle(
                                //                         color: GroceryAppColors
                                //                             .product_title_name,
                                //                         fontSize: 14,
                                //                         fontFamily: 'Roboto',
                                //                         fontWeight:
                                //                             FontWeight.bold),
                                //                   ),
                                //                 ),
                                //                 Padding(
                                //                   padding: const EdgeInsets.only(
                                //                       right: 8.0,
                                //                       top: 8.0,
                                //                       left: 8.0),
                                //                   child: ElevatedButton(
                                //                       style:
                                //                           ElevatedButton.styleFrom(
                                //                         backgroundColor:
                                //                             GroceryAppColors.tela,
                                //                         textStyle: TextStyle(
                                //                           color: Colors.white,
                                //                         ),
                                //                       ),
                                //                       child: Text('View All',
                                //                           style: TextStyle(
                                //                               color:
                                //                                   GroceryAppColors
                                //                                       .white)),
                                //                       onPressed: () {
                                //                         Navigator.push(
                                //                           context,
                                //                           MaterialPageRoute(
                                //                             builder: (context) =>
                                //                                 ProductList("best",
                                //                                     "Best Deals"),
                                //                           ),
                                //                         );
                                //                       }),
                                //                 )
                                //               ],
                                //             ),
                                //           )
                                //         : Container()
                                //     : Container(),

                                // bestProducts != null
                                //     ? bestProducts.length > 0
                                //         ? Container(
                                //             child: ListView.builder(
                                //               shrinkWrap: true,
                                //               primary: false,
                                //               scrollDirection: Axis.vertical,
                                //               itemCount: bestProducts.length,
                                //               itemBuilder: (BuildContext context,
                                //                   int index) {
                                //                 return Stack(
                                //                   children: [
                                //                     Container(
                                //                       margin: EdgeInsets.only(
                                //                           left: 10,
                                //                           right: 10,
                                //                           top: 6,
                                //                           bottom: 6),
                                //                       child: Card(
                                //                         elevation: 10,
                                //                         shape:
                                //                             RoundedRectangleBorder(
                                //                           borderRadius:
                                //                               BorderRadius.circular(
                                //                                   10),
                                //                         ),
                                //                         child: InkWell(
                                //                           onTap: () {
                                //                             Navigator.push(
                                //                               context,
                                //                               MaterialPageRoute(
                                //                                   builder: (context) =>
                                //                                       ProductDetails(
                                //                                           bestProducts[
                                //                                               index])),
                                //                             );
                                //                           },
                                //                           child: Container(
                                //                             child: Row(
                                //                               children: <Widget>[
                                //                                 Expanded(
                                //                                   child: Container(
                                //                                     padding:
                                //                                         const EdgeInsets
                                //                                                 .all(
                                //                                             8.0),
                                //                                     child: Column(
                                //                                       mainAxisSize:
                                //                                           MainAxisSize
                                //                                               .max,
                                //                                       crossAxisAlignment:
                                //                                           CrossAxisAlignment
                                //                                               .start,
                                //                                       children: <
                                //                                           Widget>[
                                //                                         Container(
                                //                                           child:
                                //                                               Text(
                                //                                             bestProducts[index].productName ==
                                //                                                     null
                                //                                                 ? 'name'
                                //                                                 : bestProducts[index].productName.toString(),
                                //                                             overflow:
                                //                                                 TextOverflow.fade,
                                //                                             style: TextStyle(
                                //                                                     fontSize: 15,
                                //                                                     fontWeight: FontWeight.w400,
                                //                                                     color: Colors.black)
                                //                                                 .copyWith(fontSize: 14),
                                //                                           ),
                                //                                         ),
                                //                                         SizedBox(
                                //                                             height:
                                //                                                 6),
                                //                                         Row(
                                //                                           children: <
                                //                                               Widget>[
                                //                                             Padding(
                                //                                               padding: const EdgeInsets.only(
                                //                                                   top: 2.0,
                                //                                                   bottom: 1),
                                //                                               child: Text(
                                //                                                   '\u{20B9} ${calDiscount(bestProducts[index].buyPrice ?? "", bestProducts[index].discount ?? "")}  ${bestProducts[index].unit_type != null ? bestProducts[index].unit_type : ""}',
                                //                                                   style: TextStyle(
                                //                                                     color: GroceryAppColors.sellp,
                                //                                                     fontWeight: FontWeight.w700,
                                //                                                   )),
                                //                                             ),
                                //                                             SizedBox(
                                //                                               width:
                                //                                                   20,
                                //                                             ),
                                //                                             Expanded(
                                //                                               child:
                                //                                                   Text(
                                //                                                 '\u{20B9} ${bestProducts[index].buyPrice}',
                                //                                                 overflow:
                                //                                                     TextOverflow.ellipsis,
                                //                                                 maxLines:
                                //                                                     2,
                                //                                                 style: TextStyle(
                                //                                                     fontWeight: FontWeight.w700,
                                //                                                     fontStyle: FontStyle.italic,
                                //                                                     color: GroceryAppColors.mrp,
                                //                                                     decoration: TextDecoration.lineThrough),
                                //                                               ),
                                //                                             )
                                //                                           ],
                                //                                         ),
                                //                                       ],
                                //                                     ),
                                //                                   ),
                                //                                 ),
                                //                                 Container(
                                //                                   margin: EdgeInsets
                                //                                       .only(
                                //                                           right: 8,
                                //                                           left: 8,
                                //                                           top: 8,
                                //                                           bottom:
                                //                                               8),
                                //                                   width: 110,
                                //                                   height: 110,
                                //                                   decoration:
                                //                                       BoxDecoration(
                                //                                           border: Border.all(
                                //                                               color: GroceryAppColors
                                //                                                   .tela,
                                //                                               width:
                                //                                                   0.2),
                                //                                           borderRadius:
                                //                                               BorderRadius
                                //                                                   .all(
                                //                                             Radius.circular(
                                //                                                 55),
                                //                                           ),
                                //                                           color: Colors
                                //                                               .blue
                                //                                               .shade200,
                                //                                           image: DecorationImage(
                                //                                               fit: BoxFit.cover,
                                //                                               image: NetworkImage(
                                //                                                 bestProducts[index].img != null
                                //                                                     ? GroceryAppConstant.Product_Imageurl + bestProducts[index].img.toString()
                                //                                                     : "https://www.bigwelt.com/manage/uploads/gallery/no-img.png",
                                //                                               ))),
                                //                                 ),
                                //                               ],
                                //                             ),
                                //                           ),
                                //                         ),
                                //                       ),
                                //                     ),
                                //                     //double.parse(products1[index].discount)>0?  showSticker(index,products1):Row(),
                                //                   ],
                                //                 );
                                //               },
                                //             ),
                                //           )
                                //         : Row()
                                //     : Row(),
                                // // gettopproducts("best""0")best deals ends

                                //  gettopproduct("day","0") deals of the day  starts
                                topProducts1 != null
                                    ? topProducts1.length > 0
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 6,
                                                top: 4),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                //color: Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     color: Colors.grey[300],
                                                //     blurRadius: 2,
                                                //     spreadRadius: 1,
                                                //   )
                                                // ],
                                              ),
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        'NEW ARRIVALS',
                                                        style: TextStyle(
                                                            color: GroceryAppColors
                                                                .product_title_name,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'Roboto',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      // Padding(
                                                      //   padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
                                                      //   child: RaisedButton(
                                                      //       color: GroceryAppColors.tela,
                                                      //       child: Text('View All', style: TextStyle(color: GroceryAppColors.white)),
                                                      //       onPressed: () {
                                                      //         Navigator.push(
                                                      //           context,
                                                      //           MaterialPageRoute(builder: (context) => ProductList("day", "Deals of the day")),
                                                      //         );
                                                      //       }),
                                                      // )
                                                    ],
                                                  ),
                                                  // Divider(
                                                  //   color: GroceryAppColors
                                                  //       .lightGray, //color of divider
                                                  //   height:
                                                  //       10, //height spacing of divider
                                                  //   thickness:
                                                  //       0.5, //thickness of divier line
                                                  //   indent:
                                                  //       14, //spacing at the start of divider
                                                  //   endIndent:
                                                  //       14, //spacing at the end of divider
                                                  // ),
                                                  Container(
                                                    child:
                                                        topProducts1.isNotEmpty
                                                            ? Container(
                                                                // color: GroceryAppColors.black,
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  left: 8.0,
                                                                ),
                                                                height: 200.0,
                                                                child: ListView
                                                                    .builder(
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        itemCount:
                                                                            topProducts1
                                                                                .length,
                                                                        itemBuilder:
                                                                            (BuildContext context,
                                                                                int index) {
                                                                          return Stack(
                                                                            children: [
                                                                              Container(
                                                                                width: topProducts1.isNotEmpty ? 130.0 : 165.0,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(14),
                                                                                ),
                                                                                margin: EdgeInsets.only(right: 10),
                                                                                child: Card(
                                                                                  elevation: 3,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(14),
                                                                                  ),
                                                                                  child: Container(
                                                                                    child: Column(
                                                                                      children: <Widget>[
                                                                                        InkWell(
                                                                                          onTap: () {
                                                                                            Navigator.push(
                                                                                              context,
                                                                                              MaterialPageRoute(builder: (context) => ProductDetails(topProducts1[index])),
                                                                                            );
                                                                                          },
                                                                                          child: Container(
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                                                                                              child: CustomProductImage(
                                                                                                uniqueKey: 'top_product1_${topProducts1[index].productIs ?? topProducts1[index].p_id ?? index}_${currentCategoryId ?? "0"}_$_rebuildCounter',
                                                                                                imageUrl: (() {
                                                                                                  // Prefer img_url, fallback to img
                                                                                                  final String? imgUrlField = topProducts1[index].img_url;
                                                                                                  final String? imgField = topProducts1[index].img;
                                                                                                  String? finalUrl;
                                                                                                  if (imgUrlField != null && imgUrlField.isNotEmpty) {
                                                                                                    finalUrl = imgUrlField;
                                                                                                  } else if (imgField != null && imgField.isNotEmpty && imgField != 'no-img.png' && imgField != 'no-cover.png') {
                                                                                                    if (imgField.startsWith('http://') || imgField.startsWith('https://')) {
                                                                                                      finalUrl = imgField;
                                                                                                    } else {
                                                                                                      final String imageName = imgField.split('/').last;
                                                                                                      finalUrl = GroceryAppConstant.Product_Imageurl + imageName;
                                                                                                    }
                                                                                                  } else {
                                                                                                    finalUrl = null;
                                                                                                  }
                                                                                                  try {} catch (_) {}
                                                                                                  return finalUrl;
                                                                                                })(),
                                                                                                fallbackUrl: "https://www.bigwelt.com/manage/uploads/gallery/no-img.png",
                                                                                                height: 100.0,
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Container(
                                                                                            margin: EdgeInsets.only(left: 6, right: 6, top: 6),
                                                                                            padding: EdgeInsets.only(left: 4, right: 6),
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: <Widget>[
                                                                                                SizedBox(
                                                                                                  height: 40,
                                                                                                  child: Text(
                                                                                                    (() {
                                                                                                      final name = topProducts1[index].productName ?? '';
                                                                                                      return name.length > 30 ? name.substring(0, 30) + '...' : name;
                                                                                                    })(),
                                                                                                    overflow: TextOverflow.ellipsis,
                                                                                                    maxLines: 2,
                                                                                                    style: TextStyle(
                                                                                                      fontSize: 12,
                                                                                                      color: GroceryAppColors.black,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      '\u{20B9} ${topProducts1[index].buyPrice}',
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      maxLines: 1,
                                                                                                      style: TextStyle(fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 11, color: GroceryAppColors.black, decoration: TextDecoration.lineThrough),
                                                                                                    ),
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                                                                                                      child: Text('\u{20B9} ${calDiscount(topProducts1[index].buyPrice!, topProducts1[index].discount!)} ${topProducts1[index].unit_type != null ? topProducts1[index].unit_type : ""}', style: TextStyle(color: const Color.fromARGB(255, 72, 36, 172), fontWeight: FontWeight.w700, fontSize: 12)),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              double.parse(topProducts1[index].discount!) > 0 ? showSticker1(index, topProducts1) : Row()
                                                                            ],
                                                                          );
                                                                        }),
                                                              )
                                                            : Container(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container()
                                    : Container(),

                                //  gettopproduct("day","0")  deals of the day ends

                                // Products Grid Section
                                dilofdayProducts.length > 0
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 2,
                                                  top: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'Services',
                                                    style: TextStyle(
                                                      color: GroceryAppColors
                                                          .product_title_name,
                                                      fontSize: 15,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Divider(
                                            //   color: GroceryAppColors
                                            //       .lightGray, //color of divider
                                            //   height:
                                            //       10, //height spacing of divider
                                            //   thickness:
                                            //       0.5, //thickness of divier line
                                            //   indent:
                                            //       14, //spacing at the start of divider
                                            //   endIndent:
                                            //       14, //spacing at the end of divider
                                            // ),
                                            GridView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(), // Disable scrolling since it's in a scroll view
                                                shrinkWrap: true,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      2, // Two cards per row
                                                  crossAxisSpacing: 12,
                                                  mainAxisSpacing: 12,
                                                  childAspectRatio:
                                                      0.75, // Adjusted to provide more height and prevent overflow
                                                ),
                                                itemCount: dilofdayProducts
                                                    .length, // Show all available products
                                                itemBuilder: (context, index) {
                                                  // Calculate discount percentage - Simplified logic
                                                  double discountPercentage = 0;
                                                  double mrpPrice = 0;
                                                  double discountedPrice = 0;

                                                  // Get the base price
                                                  double buyPrice = double.tryParse(
                                                          dilofdayProducts[
                                                                      index]
                                                                  .buyPrice
                                                                  ?.toString() ??
                                                              "0") ??
                                                      0;
                                                  double msrpPrice =
                                                      double.tryParse(
                                                              dilofdayProducts[
                                                                          index]
                                                                      .msrp
                                                                      ?.toString() ??
                                                                  "0") ??
                                                          0;
                                                  double discountAmount =
                                                      double.tryParse(
                                                              dilofdayProducts[
                                                                          index]
                                                                      .discount
                                                                      ?.toString() ??
                                                                  "0") ??
                                                          0;

                                                  if (buyPrice > 0) {
                                                    // Scenario 1: MSRP exists and is higher than buyPrice (MSRP is MRP, buyPrice is discounted)
                                                    if (msrpPrice > 0 &&
                                                        msrpPrice > buyPrice) {
                                                      mrpPrice = msrpPrice;
                                                      discountedPrice =
                                                          buyPrice;
                                                      discountPercentage =
                                                          ((mrpPrice -
                                                                      discountedPrice) /
                                                                  mrpPrice) *
                                                              100;
                                                    }
                                                    // Scenario 2: Discount field contains percentage (like 10.00 = 10%)
                                                    else if (discountAmount >
                                                            0 &&
                                                        discountAmount <= 100) {
                                                      mrpPrice = buyPrice;
                                                      discountPercentage =
                                                          discountAmount; // Direct percentage value
                                                      discountedPrice = buyPrice -
                                                          (buyPrice *
                                                              (discountAmount /
                                                                  100));
                                                    }
                                                    // Scenario 3: Large discount value - treat as amount to subtract
                                                    else if (discountAmount >
                                                            100 &&
                                                        discountAmount <
                                                            buyPrice) {
                                                      mrpPrice = buyPrice;
                                                      discountedPrice =
                                                          buyPrice -
                                                              discountAmount;
                                                      discountPercentage =
                                                          (discountAmount /
                                                                  buyPrice) *
                                                              100;
                                                    }
                                                    // Scenario 4: No discount, use buyPrice as final price
                                                    else {
                                                      mrpPrice = buyPrice;
                                                      discountedPrice =
                                                          buyPrice;
                                                      discountPercentage = 0;
                                                    }
                                                  }

                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.08),
                                                          blurRadius: 12,
                                                          offset: Offset(0, 4),
                                                          spreadRadius: 0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductDetails(
                                                                    dilofdayProducts[
                                                                        index]),
                                                          ),
                                                        );
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Product Image with discount tag
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              child: Stack(
                                                                children: [
                                                                  Positioned
                                                                      .fill(
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(16),
                                                                        topRight:
                                                                            Radius.circular(16),
                                                                      ),
                                                                      child:
                                                                          CustomProductImage(
                                                                        uniqueKey:
                                                                            'dilofday_product_${dilofdayProducts[index].productIs ?? dilofdayProducts[index].p_id ?? index}_${currentCategoryId ?? "0"}_$_rebuildCounter',
                                                                        imageUrl:
                                                                            (() {
                                                                          final String?
                                                                              imgUrlField =
                                                                              dilofdayProducts[index].img_url;
                                                                          final String?
                                                                              imgField =
                                                                              dilofdayProducts[index].img;
                                                                          if (imgUrlField != null &&
                                                                              imgUrlField.isNotEmpty) {
                                                                            return imgUrlField;
                                                                          }
                                                                          if (imgField == null ||
                                                                              imgField.isEmpty) {
                                                                            return null;
                                                                          }
                                                                          final String
                                                                              imageName =
                                                                              imgField.split('/').last;
                                                                          final String finalUrl = GroceryAppConstant.base_url +
                                                                              'manage/uploads/gallery/' +
                                                                              imageName;
                                                                          return finalUrl;
                                                                        })(),
                                                                        fallbackUrl:
                                                                            "https://www.bigwelt.com/manage/uploads/gallery/no-img.png",
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if (discountPercentage >
                                                                      0)
                                                                    Positioned(
                                                                      top: 6,
                                                                      left: 6,
                                                                      child:
                                                                          Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                6,
                                                                            vertical:
                                                                                3),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              46,
                                                                              125,
                                                                              50),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: const Color.fromARGB(255, 46, 125, 50).withOpacity(0.3),
                                                                              blurRadius: 3,
                                                                              offset: Offset(0, 1),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "${discountPercentage.toStringAsFixed(0)}% off",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                9,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          // Product Details
                                                          Expanded(
                                                            flex: 2,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          8,
                                                                          6,
                                                                          8,
                                                                          6),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  // Top section: Product Name + Price
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      // Product Name
                                                                      SizedBox(
                                                                        height:
                                                                            34, // ~2 lines at 14px with 1.2 height
                                                                        child:
                                                                            Text(
                                                                          (() {
                                                                            final name =
                                                                                dilofdayProducts[index].productName ?? "Service";
                                                                            return name.length > 30
                                                                                ? name.substring(0, 30) + '...'
                                                                                : name;
                                                                          })(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                GroceryAppColors.black,
                                                                            height:
                                                                                1.2,
                                                                          ),
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              2),
                                                                      // Price Section - Both prices in same row
                                                                      Row(
                                                                        children: [
                                                                          // Final Price (After discount)
                                                                          Text(
                                                                            "₹${discountedPrice.toStringAsFixed(0)}",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: const Color.fromARGB(255, 52, 73, 157),
                                                                            ),
                                                                          ),
                                                                          // Original Price (MRP) - show only if there's a discount
                                                                          if (discountPercentage >
                                                                              0) ...[
                                                                            SizedBox(width: 8),
                                                                            Text(
                                                                              "₹${mrpPrice.toStringAsFixed(0)}",
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: GroceryAppColors.darkGray,
                                                                                decoration: TextDecoration.lineThrough,
                                                                                decorationColor: GroceryAppColors.darkGray,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                          // Unit type
                                                                          if (dilofdayProducts[index].unit_type != null &&
                                                                              dilofdayProducts[index].unit_type!.isNotEmpty)
                                                                            Text(
                                                                              " /${dilofdayProducts[index].unit_type}",
                                                                              style: TextStyle(
                                                                                fontSize: 11,
                                                                                color: GroceryAppColors.darkGray,
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  // Book Button - Smaller and Right Aligned
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            90,
                                                                        height:
                                                                            28,
                                                                        child:
                                                                            ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            // Add to cart functionality
                                                                            final product =
                                                                                dilofdayProducts[index];
                                                                            // Ensure we never push a zero price into cart
                                                                            double
                                                                                unitPrice =
                                                                                discountedPrice;
                                                                            if (unitPrice <=
                                                                                0) {
                                                                              if (buyPrice > 0) {
                                                                                unitPrice = buyPrice;
                                                                              } else if (msrpPrice > 0) {
                                                                                unitPrice = msrpPrice;
                                                                              }
                                                                            }
                                                                            _addToproducts(
                                                                              product.p_id ?? product.productIs ?? "0",
                                                                              product.productName ?? "Service",
                                                                              product.img ?? "",
                                                                              unitPrice.round(),
                                                                              1, // Default quantity
                                                                              product.productColor ?? "", // color value
                                                                              "", // size
                                                                              product.productDescription ?? "",
                                                                              product.sgst ?? "0",
                                                                              product.cgst ?? "0",
                                                                              product.discount ?? "0",
                                                                              "0", // disVal
                                                                              "0", // adminper
                                                                              "0", // adminperValue
                                                                              product.costPrice ?? "0",
                                                                              product.shipping ?? "0",
                                                                              product.quantityInStock ?? "1", // total quantity
                                                                            );
                                                                          },
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor: const Color.fromARGB(
                                                                                255,
                                                                                28,
                                                                                163,
                                                                                95),
                                                                            foregroundColor:
                                                                                Colors.white,
                                                                            elevation:
                                                                                2,
                                                                            shadowColor:
                                                                                const Color.fromARGB(255, 69, 74, 193).withOpacity(0.3),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Icon(Icons.add_shopping_cart, size: 12),
                                                                              SizedBox(width: 3),
                                                                              Text(
                                                                                "Book",
                                                                                style: TextStyle(
                                                                                  fontSize: 11,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ],
                                        ),
                                      )
                                    : Container(),

                                //  promotional banner starts
                                imageUrl.isNotEmpty
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                48,
                                        height: 220.0,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 15,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl.isEmpty
                                                ? "https://www.bigwelt.com/manage/uploads/gallery/no-img.png"
                                                : "${GroceryAppConstant.mainurl + promotionBanner.path.toString() + promotionBanner.images.toString()}",
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                48,
                                            height: 220.0,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                              color: Color(0xFFF8F9FA),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color(0xFF1B5E20)),
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              color: Color(0xFFF8F9FA),
                                              child: Icon(
                                                Icons.broken_image_outlined,
                                                color: Colors.grey[400],
                                                size: 48,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                //  promotional banner ends

                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Builds 1000 ListTiles
                      childCount: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget slider1Widget() {
    return sliderlist.length > 0
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: CarouselSlider.builder(
              itemCount: sliderlist.length,
              options: CarouselOptions(
                aspectRatio: 2.7,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 4),
                enlargeCenterPage: true,
              ),
              itemBuilder: (ctx, index, realIdx) {
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      if (sliderlist[index].title!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Screen2(
                                  sliderlist[index].title.toString(), "")),
                        );
                      } else if (sliderlist[index].description!.isNotEmpty) {
                        // Navigation to slider details
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF1B5E20).withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          key: Key('slider_${sliderlist[index].img}'),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          fit: BoxFit.cover,
                          imageUrl: sliderlist[index].img != null &&
                                  sliderlist[index].img.toString().isNotEmpty
                              ? GroceryAppConstant.Base_Imageurl +
                                  sliderlist[index].img.toString()
                              : "https://www.bigwelt.com/manage/uploads/gallery/no-img.png",
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF1B5E20)),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey[400],
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ))
        : Container();
  }

  Widget categoryWidget() {
    return list.isNotEmpty
        ? list.length > 0
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 14.0, right: 14.0, bottom: 0.0, top: 14),
                child: Container(
                  decoration: BoxDecoration(
                    //  color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0, bottom: 10),
                            child: Text(
                              "Services",
                              style: TextStyle(
                                  color: Color(0xff1E88E5), // Medical blue
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          list.length > 4
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      right: 14.0,
                                      top: 8.0,
                                      left: 8.0,
                                      bottom: 10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllCategory("Category", '0')),
                                      );
                                    },
                                    child: Text('See all',
                                        style: TextStyle(
                                          color: GroceryAppColors.tela,
                                          fontSize: 14,
                                        )),
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                      GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisExtent: 120,
                          ),
                          shrinkWrap: true,
                          primary: false,
                          //   scrollDirection: Axis.horizontal,
                          itemCount: list.length > 10 ? 10 : list.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                var i = list[index].pcatId;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Sbcategory(
                                      list[index].pCats.toString(),
                                      list[index].pcatId.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                elevation: 0,
                                shadowColor: Color.fromARGB(225, 255, 255, 255),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(color: GroceryAppColors.tela, width: 4),
                                      //   borderRadius: BorderRadius.circular(35),
                                      // ),
                                      width: 60,
                                      height: 60,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: Padding(
                                            padding: EdgeInsets.all(0.0),
                                            child:
                                                getGroceryCategoryImageWidget(
                                              list[index].img,
                                              fit: BoxFit.fill,
                                              width: 60,
                                              height: 60,
                                            ),
                                          )),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          list[index].pCats!,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: GroceryAppColors.black,
                                          ),
                                        ),
                                        SizedBox(height: 3)
                                      ],
                                    ),
                                    //SizedBox(width: 2),
                                  ],
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                ),
              )
            : Row()
        : Row();
  }

  String calDiscount(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(GroceryAppConstant.val);
    print(returnStr);
    return returnStr;
  }

  final DbProductManager dbmanager = DbProductManager();

  ProductsCart? products2;

  void _navigateToCheckout() {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShowAddress("0")),
      );
    }
  }

  void _addToproducts(
      String pID,
      String p_name,
      String image,
      int price,
      int quantity,
      String c_val,
      String p_size,
      String p_disc,
      String sgst,
      String cgst,
      String discount,
      String dis_val,
      String adminper,
      String adminper_val,
      String cost_price,
      String shippingcharge,
      String totalQun) {
    // Client requirement: Only one item with quantity 1 allowed in cart
    // Clear all existing items from cart first
    dbmanager.deleteallProducts().then((_) {
      // Create new product with quantity 1 (ignoring passed quantity parameter)
      ProductsCart st = ProductsCart(
        id: 0, // Add missing required parameter
        pid: pID,
        pname: p_name,
        pimage: image,
        pprice: price.toString(),
        pQuantity: 1, // Always quantity 1 as per requirement
        pcolor: c_val,
        psize: p_size,
        pdiscription: p_disc,
        sgst: sgst,
        cgst: cgst,
        discount: discount,
        discountValue: dis_val,
        adminper: adminper,
        adminpricevalue: adminper_val,
        costPrice: cost_price,
        shipping: shippingcharge,
        totalQuantity: totalQun,
        varient: "", // Add missing required parameter
        mv: null, // Add missing required parameter (nullable int)
        moq: "", // Add missing required parameter
        time1: "", // Add missing required parameter
        date1: "", // Add missing required parameter
      );

      // Add the new product as the only item in cart
      dbmanager.insertStudent(st).then((id) {
        if (this.mounted) {
          setState(() {
            // Reset cart count to 1 since we only have one item
            GroceryAppConstant.groceryAppCartItemCount = 1;
            GroceryAppConstant.carditemCount = 1;
          });

          // Update cart UI
          cartItemcount(1);

          showLongToast("$p_name added to cart");
          print('Cart cleared and new item added: $p_name (ID: $id)');

          // Navigate to address selection after successful cart addition
          _navigateToCheckout();
        }
      }).catchError((error) {
        print('Error adding product to cart: $error');
        showLongToast("Failed to add item to cart");
      });
    }).catchError((error) {
      print('Error clearing cart: $error');
      showLongToast("Failed to clear cart");
    });
  }

  String calGst(String byprice, String sgst) {
    String returnStr;
    double discount = 0.0;
    if (sgst.length > 1) {
      returnStr = discount.toString();
      double byprice1 = double.parse(byprice);
      print(sgst);

      double discount1 = double.parse(sgst);

      discount = ((byprice1 * discount1) / (100.0 + discount1));

      returnStr = discount.toStringAsFixed(2);
      print(returnStr);
      return returnStr;
    } else {
      return '0';
    }
  }

  showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future cartItemcount(int val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setInt("itemCount", val);
    print(val.toString() + "shair....");
  }

  Widget _buildSelectedCategoryIndicator() {
    String categoryIdToUse = currentCategoryId ?? "0";

    if (categoryIdToUse == "0") {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.category,
              color: GroceryAppColors.tela,
              size: 20,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Showing all services • Tap to select specific service",
                style: TextStyle(
                  color: GroceryAppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  await showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => CategorySelectionModal(
                      onCategorySelected: (categoryId) async {
                        // Wait a moment for modal to close properly
                        await Future.delayed(Duration(milliseconds: 200));

                        if (mounted) {
                          // Refresh the current screen instead of replacing
                          setState(() {
                            currentCategoryId = categoryId;
                          });

                          // Reload category info and products
                          await _loadSelectedCategoryInfo();
                          await _loadProducts();
                        }
                      },
                    ),
                  );
                } catch (e) {
                  print("Error in category selection: $e");
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 149, 124, 115),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "Select",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Build the selected category display
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Category image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: GroceryAppColors.tela.withOpacity(0.1),
              border: Border.all(
                color: GroceryAppColors.tela.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildCategoryImage(),
            ),
          ),
          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current Selection",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  selectedCategoryName.isNotEmpty
                      ? selectedCategoryName
                      : "Selected Category",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GroceryAppColors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () async {
              try {
                await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => CategorySelectionModal(
                    onCategorySelected: (categoryId) async {
                      // Wait a moment for modal to close properly
                      await Future.delayed(Duration(milliseconds: 200));

                      if (mounted) {
                        // Update state instead of navigation
                        setState(() {
                          currentCategoryId = categoryId;
                        });

                        // Reload category info and products
                        await _loadSelectedCategoryInfo();
                        await _loadProducts();
                      }
                    },
                  ),
                );
              } catch (e) {
                print("Error in category selection: $e");
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 254, 120, 72),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Change",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Separate method to build category image with proper URL handling
  Widget _buildCategoryImage() {
    // Build the full image URL
    String fullImageUrl = "";

    if (selectedCategoryImage.isNotEmpty) {
      if (selectedCategoryImage.startsWith('http')) {
        // If it's already a full URL, use it directly
        fullImageUrl = selectedCategoryImage;
      } else {
        // If it's just a filename, prepend the correct category base URL
        final imageName = selectedCategoryImage.split('/').last;
        fullImageUrl = GroceryAppConstant.logo_Image_Pcat + imageName;
      }
    }

    if (fullImageUrl.isEmpty) {
      // Show default category icon when no image
      return Container(
        color: GroceryAppColors.tela.withOpacity(0.1),
        child: Icon(
          Icons.category_outlined,
          color: GroceryAppColors.tela,
          size: 30,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: fullImageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) {
        return Container(
          color: Colors.grey[200],
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(GroceryAppColors.tela),
              ),
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          color: GroceryAppColors.tela.withOpacity(0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image_outlined,
                color: GroceryAppColors.tela,
                size: 20,
              ),
              SizedBox(height: 2),
              Text(
                'No Image',
                style: TextStyle(
                  color: GroceryAppColors.tela,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to get specific category by ID (searches both root and sub categories)
  Future<Categary?> getSpecificCategoryById(String categoryId) async {
    try {
      // First try to get from root categories (parent=0)
      String rootLink =
          "${GroceryAppConstant.base_url}manage/api/p_category/all/?X-Api-Key=${GroceryAppConstant.API_KEY}&start=0&limit=100&field=shop_id&filter=${GroceryAppConstant.Shop_id}&parent=0&loc_id=&type=1";

      final rootResponse = await http.get(Uri.parse(rootLink));

      if (rootResponse.statusCode == 200) {
        var rootData = json.decode(rootResponse.body);

        // Check if we can find it in root categories
        if (rootData["status"] == true && rootData["data"] != null) {
          List<dynamic> rootArray = rootData["data"];
          List<Categary> rootCategories = Categary.getListFromJson(rootArray);

          for (var category in rootCategories) {
            if (category.pcatId == categoryId) {
              return category;
            }
          }
        }
      }

      // If not found in root categories, try getting all categories without parent filter
      String allLink =
          "${GroceryAppConstant.base_url}manage/api/p_category/all/?X-Api-Key=${GroceryAppConstant.API_KEY}&start=0&limit=500&field=shop_id&filter=${GroceryAppConstant.Shop_id}&loc_id=&type=1";

      final allResponse = await http.get(Uri.parse(allLink));

      if (allResponse.statusCode == 200) {
        var allData = json.decode(allResponse.body);

        if (allData["status"] == true && allData["data"] != null) {
          List<dynamic> allArray = allData["data"];
          List<Categary> allCategories = Categary.getListFromJson(allArray);

          for (var category in allCategories) {
            if (category.pcatId == categoryId) {
              return category;
            }
          }
        }
      }
    } catch (e) {}

    return null;
  }

  // Method to handle category selection and navigation
  void _loadSubCategories(String categoryId) async {
    try {
      // Save the selected category
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("selectedCategoryId", categoryId);

      // Find the category name and image
      String categoryName = "Selected Category";
      String? categoryImage;

      try {
        var category = list.firstWhere((cat) => cat.pcatId == categoryId);
        categoryName = category.pCats ?? "Selected Category";
        categoryImage = category.img;
      } catch (e) {
        print("Category not found in list: $e");
      }

      // Save category info
      await prefs.setString("selectedCategoryName", categoryName);
      if (categoryImage != null && categoryImage.isNotEmpty) {
        await prefs.setString("selectedCategoryImage", categoryImage);
      }

      // Update UI
      if (mounted) {
        setState(() {
          currentCategoryId = categoryId;
          selectedCategoryName = categoryName;
          selectedCategoryImage = categoryImage ?? "";
        });

        // Refresh products for the new category
        await _refreshProductsForCategory();

        // Show a toast message
        showLongToast("Switched to $categoryName");
      }
    } catch (e) {
      print("Error loading subcategories: $e");
      showLongToast("Failed to switch category");
    }
  }
}
