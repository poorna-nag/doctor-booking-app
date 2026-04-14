import 'dart:io';

import 'package:ecoshine24/model/ShopDModel.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:ecoshine24/Auth/signin.dart';
import 'package:ecoshine24/grocery/BottomNavigation/profiledraw.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/General/Home.dart';
import 'package:ecoshine24/grocery/Web/WebviewTermandCondition.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/screen/ShowAddress.dart';
import 'package:ecoshine24/grocery/screen/myorder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool islogin = false;
  String? name, email, image, cityname, mobile;
  int? wcount;

  ShopDModel? shopDetails;
  SharedPreferences? pref;
  void gatinfo() async {
    pref = await SharedPreferences.getInstance();
    islogin = pref!.getBool("isLogin")!;
    int wcount1 = pref!.getInt("wcount")!;
    name = pref!.getString("name");
    email = pref!.getString("email");
    image = pref!.getString("pp");
    cityname = pref!.getString("city");
    mobile = pref!.getString("mobile");

    // print(islogin);
    setState(() {
      GroceryAppConstant.name = name ?? "";
      GroceryAppConstant.email = email ?? "";
      GroceryAppConstant.isLogin = islogin;
      GroceryAppConstant.image = image ?? "";
      print(GroceryAppConstant.image);
      GroceryAppConstant.citname = cityname ?? "";

      // print( Constant.image.length);
      wcount = wcount1;
    });
  }

  bool check = false;
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text(
              'Select Area',
              style: TextStyle(
                color: Color(0xff1E88E5),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(
              width: double.maxFinite,
              height: 400,
              child: FutureBuilder(
                  future: getPcity(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data == null
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data?.length == null
                                  ? 0
                                  : snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: snapshot.data![index] != 0
                                      ? 130.0
                                      : 230.0,
                                  color: Colors.white,
                                  margin: EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        check = true;
                                        pref!.setString('city',
                                            snapshot.data![index].places ?? "");
                                        pref!.setString('cityid',
                                            snapshot.data![index].loc_id ?? "");
                                        GroceryAppConstant.cityid =
                                            snapshot.data![index].loc_id ?? "";
                                        GroceryAppConstant.citname =
                                            snapshot.data![index].places ?? "";

                                        Navigator.pop(context);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GroceryApp()),
                                        );
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Card(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.all(10),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(
                                                snapshot.data![index].places ??
                                                    "",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: GroceryAppColors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Divider(
                                        //
                                        //   color: AppColors.black,
                                        // ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
            actions: <Widget>[
              new TextButton(
                child: Text(
                  'CANCEL',
                  style:
                      TextStyle(color: check ? Color(0xff1E88E5) : Colors.grey),
                ),
                onPressed: () {
                  check
                      ? Navigator.of(context).pop()
                      : showLongToast("Please Select area");
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    gatinfo();
    getShopD().then((value) {
      setState(() {
        shopDetails = value;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff1E88E5), // Medical blue
                  Color(0xff42A5F5), // Lighter medical blue
                  Color(0xff64B5F6), // Lightest medical blue
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Container(
                height: 68,
                child: Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 11, right: 12),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroceryApp()),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "HealthCare Plus",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: IconButton(
                          onPressed: () {
                            if (GroceryAppConstant.isLogin) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TrackOrder()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()),
                              );
                            }
                          },
                          icon: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.medical_services_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /* USER PROFILE DRAWER Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 40,left: 20),
                  color: AppColors.tela1,
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  child:CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.white,
                    child: ClipOval(
                      child: new SizedBox(
                        width: 100.0,
                        height: 100.0,
                        child:Constant.image==null? Image.asset('assets/images/logo.png',):Constant.image.length==1?Image.asset('assets/images/logo.png',):Constant.image=="https://www.bigwelt.com/manage/uploads/customers/nopp.png"? Image.asset('assets/images/logo.png',):Image.network(
                          Constant.image,
                          fit: BoxFit.fill,),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child:Text(islogin?Constant.name:" ",style: TextStyle(color: Colors.black),) ,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20,bottom: 20),
                  child:Text(islogin?Constant.email:" ",style: TextStyle(color: Colors.black),),
                ),
            /*    InkWell(
                  onTap: (){
                    _displayDialog(context);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20,bottom: 20),
                    child:Text(Constant.citname!=null?Constant.citname:" ",
                      overflow:TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Colors.black),),
                  ),
                ),*/
              ],
            ),*/
          ),

          /* UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/drawer-header.jpg'),
                )),
            currentAccountPicture:  CircleAvatar(
              radius:30,
              backgroundColor: Colors.black,
              backgroundImage:Constant.image==null? AssetImage('assets/images/logo.jpg',):Constant.image.length==1?AssetImage('assets/images/logo.jpg',):Constant.image=="https://www.bigwelt.com/manage/uploads/customers/nopp.png"? AssetImage('assets/images/logo.jpg',):NetworkImage(
                  Constant.image),
            ),
            accountName: Text(islogin?Constant.name:" ",style: TextStyle(color: Colors.black),),
            accountEmail: Text(islogin?Constant.email:" ",style: TextStyle(color: Colors.black),),
          ),*/
          Container(
            decoration: BoxDecoration(
              color: Color(0xffF8FBFF), // Medical light background
            ),
            child: ListView(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                _buildModernListTile(
                  icon: Icons.home_outlined,
                  title: 'Home',
                  color: Color(0xff1E88E5), // Medical blue
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GroceryApp()),
                    );
                  },
                ),
                _buildModernExpansionTile(
                  title: 'My Account',
                  icon: Icons.person_outline,
                  color: Color(0xff42A5F5), // Medical blue lighter
                  children: [
                    _buildModernSubListTile(
                      icon: Icons.person_outline,
                      title: "My Profile",
                      color: Color(0xff1E88E5), // Medical blue
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileViewdraw()),
                        );
                      },
                    ),
                    _buildModernSubListTile(
                      icon: Icons.calendar_today_outlined,
                      title: "My Appointments",
                      color: Color(0xff42A5F5), // Medical blue lighter
                      onTap: () {
                        if (GroceryAppConstant.isLogin) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrackOrder()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()),
                          );
                        }
                      },
                    ),
                    _buildModernSubListTile(
                      icon: Icons.location_on_outlined,
                      title: "My Addresses",
                      color: Color(0xff64B5F6), // Medical blue lightest
                      onTap: () {
                        if (GroceryAppConstant.isLogin) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowAddress("1")),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()),
                          );
                        }
                      },
                    ),
                  ],
                ),
                _buildModernListTile(
                  icon: Icons.phone_outlined,
                  title: 'Contact Us',
                  color: Color(0xff1E88E5), // Medical blue
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass("Contact Us",
                                "${GroceryAppConstant.base_url}contact")));
                  },
                ),
                _buildModernListTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  color: Color(0xff42A5F5), // Medical blue lighter
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass("Privacy Policy",
                                "${GroceryAppConstant.base_url}pp")));
                  },
                ),
                _buildModernListTile(
                  icon: Icons.local_shipping_outlined,
                  title: 'Service Policy',
                  color: Color(0xff64B5F6), // Medical blue lightest
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass("Service Policy",
                                "https://ecoshine24.w4u.in/cr")));
                  },
                ),
                _buildModernListTile(
                  icon: Icons.info_outline,
                  title: 'About Us',
                  color: Color(0xff1E88E5), // Medical blue
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass("About Us",
                                "${GroceryAppConstant.base_url}about")));
                  },
                ),
                _buildModernListTile(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  color: Color(0xff42A5F5), // Medical blue lighter
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Terms & Conditions",
                                "${GroceryAppConstant.base_url}tc")));
                  },
                ),
                _buildModernListTile(
                  icon: Icons.share_outlined,
                  title: 'Share',
                  color: Color(0xff64B5F6), // Medical blue lightest
                  onTap: () {
                    _shairApp();
                  },
                ),
                if (!GroceryAppConstant.isLogin)
                  _buildModernListTile(
                    icon: Icons.login_outlined,
                    title: 'Login',
                    color: Color(0xff1E88E5), // Medical blue
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    },
                  ),

                // Medical Logo Section
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff1E88E5).withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_hospital,
                          size: 40,
                          color: Color(0xff1E88E5),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "HealthCare Plus",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1E88E5),
                          ),
                        ),
                        Text(
                          "Your Health, Our Priority",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 15),
                shopDetails != null ? socialMedia(context) : SizedBox.shrink(),
              ],
            ),
          )
        ],
      ),
    );
  }

  _shairApp() {
    Share.share("Hi, Looking for best deals online? Download " +
        GroceryAppConstant.appname +
        " app form click on this link  https://play.google.com/store/apps/details?id=${GroceryAppConstant.packageName}");
  }

  Widget rateUs() {
    return InkWell(
        onTap: () {
          String os = Platform.operatingSystem; //in your code
          if (os == 'android') {
            final InAppReview inAppReview = InAppReview.instance;
            inAppReview.openStoreListing(
              appStoreId: "com.chickenista",
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Rate Us",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

  Future<void> _callLogoutData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    GroceryAppConstant.isLogin = false;
    GroceryAppConstant.email = " ";
    GroceryAppConstant.name = " ";
    GroceryAppConstant.image = " ";
    pref.setString("pp", " ");
    pref.setString("email", " ");
    pref.setString("name", " ");
    pref.setBool("isLogin", false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  _shareAndroidApp() {
    GroceryAppConstant.isLogin
        ? Share.share("Hi, Looking for referral bonuses? Download " +
            GroceryAppConstant.appname +
            " app from this link: https://play.google.com/store/apps/details?id=${GroceryAppConstant.packageName}.\n Don't forget to use my referral code: ${mobile}")
        : Share.share("Hi, Looking for referral bonuses? Download " +
            GroceryAppConstant.appname +
            " app from this link: https://play.google.com/store/apps/details?id=${GroceryAppConstant.packageName}");
  }

  _shareIosApp() {
    GroceryAppConstant.isLogin
        ? Share.share("Hi, Looking for referral bonuses? Download " +
            GroceryAppConstant.appname +
            " app from this link: ${GroceryAppConstant.iosAppLink}.\n Don't forget to use my referral code: ${mobile}")
        : Share.share("Hi, Looking for referral bonuses? Download " +
            GroceryAppConstant.appname +
            " app from this link:${GroceryAppConstant.iosAppLink}");
  }

  Widget socialMedia(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              shopDetails!.mobileNo != null || shopDetails!.mobileNo != ''
                  ? naviagteToFacebook('tel:+91${shopDetails!.mobileNo}')
                  : showLongToast('No Mobile Number');
            },
            child: socialMediaIcons('assets/images/phone.png'),
          ),
          InkWell(
            onTap: () {
              shopDetails!.i != null || shopDetails!.i != ''
                  ? naviagteToInstagram(shopDetails!.i)
                  : showLongToast('No Link Available');
            },
            child: socialMediaIcons('assets/images/insta.png'),
          ),
          // InkWell(
          //   onTap: () {
          //     shopDetails!.t != null || shopDetails!.t != ''
          //         ? naviagteToteligram(shopDetails!.t)
          //         : showLongToast('No Link Available');
          //   },
          //   child: socialMediaIcons('assets/images/teligram.png'),
          // ),
          InkWell(
            onTap: () {
              shopDetails!.w != null || shopDetails!.w != ''
                  ? naviagteTotwitter(shopDetails!.w!.startsWith('+')
                      ? 'https://wa.me/${shopDetails!.w}/?text=Hy '
                      : shopDetails!.w!.startsWith('91')
                          ? 'https://wa.me/+${shopDetails!.w}/?text=Hy '
                          : 'https://wa.me/+91${shopDetails!.w}/?text=Hy ')
                  : showLongToast('No number Available');
            },
            child: socialMediaIcons('assets/images/whatsapp.png'),
          ),
          InkWell(
            onTap: () {
              shopDetails!.f != null || shopDetails!.f != ''
                  ? naviagteToYoutube(shopDetails!.f)
                  : showLongToast('No Link Available');
            },
            child: socialMediaIcons('assets/images/facebook.png'),
          ),
        ],
      ),
    );
  }

  Widget socialMediaIcons(String image) {
    return Container(
      height: 30,
      width: 30,
      decoration:
          BoxDecoration(image: DecorationImage(image: AssetImage(image))),
    );
  }

  Future<void> naviagteToFacebook(link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> naviagteToInstagram(link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> naviagteTotwitter(link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> naviagteToteligram(link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> naviagteToYoutube(link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  // Helper method to build modern list tiles
  Widget _buildModernListTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.15),
                        color.withOpacity(0.05)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: color,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build modern expansion tiles
  Widget _buildModernExpansionTile({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconColor: color,
          collapsedIconColor: color,
          children: children,
        ),
      ),
    );
  }

  // Helper method to build modern sub list tiles
  Widget _buildModernSubListTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 56, right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 16,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: color.withOpacity(0.7),
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
