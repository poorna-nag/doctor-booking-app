import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/Auth/signin.dart';
import 'package:ecoshine24/grocery/screen/editprofile.dart';
import 'package:ecoshine24/grocery/screen/trackorder.dart';
import 'package:ecoshine24/grocery/screen/MyReview.dart';
import 'package:ecoshine24/grocery/screen/ShowAddress.dart';
import 'package:ecoshine24/grocery/screen/changePassword.dart';
import 'package:ecoshine24/grocery/Web/WebviewTermandCondition.dart';

class ProfileView extends StatefulWidget {
  final Function? changeView;
  const ProfileView({Key? key, this.changeView}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String name = "";
  String? image;
  String email = "";
  String? mobile;
  String user_id = "";
  bool isloginv = false;
  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    isloginv = pref.getBool("isLogin") ?? false;
    name = pref.getString("name") ?? "";
    email = pref.getString("email") ?? "";
    String image = pref.getString("pp") ?? "";
    String userid = pref.getString("user_id") ?? "";
    mobile = pref.getString("mobile");

    setState(() {
      user_id = userid;
      GroceryAppConstant.name = name;
      GroceryAppConstant.email = email;
      GroceryAppConstant.isLogin = isloginv;
      GroceryAppConstant.User_ID = userid;
      GroceryAppConstant.image = image;

      // print(GroceryAppConstant.image.length);
      // print(GroceryAppConstant.name.length);
      // print("GroceryAppConstant.name");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GroceryAppConstant.isLogin = false;

    gatinfo();
  }

  @override
  Widget build(BuildContext context) {
    print("GroceryAppConstant.check");
    print(GroceryAppConstant.check);
    if (GroceryAppConstant.check) {
      gatinfo();
      setState(() {
        GroceryAppConstant.check = false;
      });
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // Curved Header with Gradient
          SliverAppBar(
            expandedHeight: 350,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Color(0xff1E88E5),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff1E88E5),
                      Color(0xff1E88E5),
                      Color(0xff1E88E5),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      // Profile Avatar
                      Stack(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.1),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 15,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 72,
                              child: ClipOval(
                                child: SizedBox(
                                  width: 140,
                                  height: 140,
                                  child: GroceryAppConstant.image.isEmpty
                                      ? Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Color(0xff1E88E5),
                                        )
                                      : GroceryAppConstant.image.length == 1
                                          ? Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Color(0xff1E88E5),
                                            )
                                          : GroceryAppConstant.image ==
                                                  "https://www.bigwelt.com/manage/uploads/customers/nopp.png"
                                              ? Icon(
                                                  Icons.person,
                                                  size: 50,
                                                  color: Color(0xff1E88E5),
                                                )
                                              : Image.network(
                                                  GroceryAppConstant.image,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Icon(
                                                    Icons.person,
                                                    size: 50,
                                                    color: Color(0xff1E88E5),
                                                  ),
                                                ),
                                ),
                              ),
                            ),
                          ),
                          if (GroceryAppConstant.isLogin)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // User Name
                      Text(
                        GroceryAppConstant.name.length <= 1
                            ? "Guest User"
                            : GroceryAppConstant.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      // Email or Sign In Button
                      GroceryAppConstant.isLogin
                          ? Text(
                              GroceryAppConstant.email,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInPage(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: Color(0xff1E88E5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Main content as a sliver
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Quick Action Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildModernActionCard(
                          icon: Icons.calendar_today,
                          title: "BOOKINGS",
                          color: Color(0xff1E88E5), // Medical blue
                          onTap: () {
                            if (GroceryAppConstant.isLogin) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyOrdertrack(""),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInPage(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildModernActionCard(
                          icon: Icons.star_rounded,
                          title: "REVIEWS",
                          color: Color(0xff42A5F5), // Medical blue (lighter)
                          onTap: () {
                            if (GroceryAppConstant.isLogin) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyReview(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInPage(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildModernActionCard(
                          icon: Icons.share_rounded,
                          title: "SHARE",
                          color: Color(0xff64B5F6), // Medical blue (lightest)
                          onTap: () {
                            Platform.isAndroid
                                ? _shareAndroidApp()
                                : _shareIosApp();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 21),

                  // Account Overview Section
                  _buildModernSectionCard(
                    title: "Account Overview",
                    children: [
                      _buildModernListTile(
                        icon: Icons.calendar_month,
                        title: "My Bookings",
                        color: Color(0xff1E88E5), // Medical blue
                        onTap: () {
                          if (GroceryAppConstant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyOrdertrack(""),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          }
                        },
                      ),
                      _buildModernListTile(
                        icon: Icons.location_on_outlined,
                        title: "My Medical Address",
                        color: Color(0xff1E88E5), // Medical blue
                        onTap: () {
                          if (GroceryAppConstant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowAddress("1"),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          }
                        },
                      ),
                      _buildModernListTile(
                        icon: Icons.lock_outlined,
                        title: "Update Password",
                        color: Color(0xff1E88E5), // Medical blue
                        onTap: () {
                          if (GroceryAppConstant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePassword(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          }
                        },
                      ),
                      _buildModernListTile(
                        icon: Icons.edit_outlined,
                        title: "Update Profile",
                        color: Color(0xff1E88E5), // Medical blue
                        onTap: () {
                          if (GroceryAppConstant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(user_id),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          }
                        },
                        showDivider: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // More Section
                  _buildModernSectionCard(
                    title: "More",
                    children: [
                      _buildModernListTile(
                        icon: Icons.phone,
                        title: "Contact Us",
                        color: Color(0xff1E88E5), // Medical blue
                        onTap: () {
                          if (GroceryAppConstant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewClass(
                                  "Contact Us",
                                  "${GroceryAppConstant.base_url}contact",
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          }
                        },
                      ),
                      _buildModernListTile(
                        icon: Icons.privacy_tip_outlined,
                        title: "Privacy Policy",
                        color: Color(0xff1E88E5), // Medical blue
                        onTap: () {
                          if (GroceryAppConstant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewClass(
                                  "Privacy Policy",
                                  "${GroceryAppConstant.base_url}pp",
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          }
                        },
                      ),
                      _buildModernListTile(
                        icon: Icons.info_outline,
                        title: "About Us",
                        color: Color(0xff1E88E5), // Medical blue
                        onTap: () {
                          if (GroceryAppConstant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewClass(
                                  "About Us",
                                  "${GroceryAppConstant.base_url}about",
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          }
                        },
                      ),
                      _buildModernListTile(
                        icon: Icons.description_outlined,
                        title: "Terms & Conditions",
                        color: Color(0xff1E88E5), // Medical blue
                        onTap: () {
                          if (GroceryAppConstant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewClass(
                                  "Terms & Conditions",
                                  "${GroceryAppConstant.base_url}tc",
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          }
                        },
                      ),
                      _buildModernListTile(
                        icon: GroceryAppConstant.isLogin
                            ? Icons.logout_outlined
                            : Icons.login_outlined,
                        title: GroceryAppConstant.isLogin ? "Logout" : "Login",
                        color: GroceryAppConstant.isLogin
                            ? Color(0xFFD32F2F)
                            : Color(0xff1E88E5), // Medical blue for login
                        onTap: () {
                          if (GroceryAppConstant.isLogin) {
                            _callLogoutData();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          }
                        },
                        showDivider: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Made in India Footer
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff1E88E5), // Medical blue
                          Color(0xff1E88E5), // Medical blue (lighter)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff1E88E5).withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      "🇮🇳 Made with ❤ in India 🇮🇳",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // (Removed unused legacy helper methods to clean up file)

  // Remove old helper methods
  Widget _buildModernActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build modern section cards
  Widget _buildModernSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Color(0xff1E88E5).withOpacity(0.1), // Medical blue
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff1E88E5).withOpacity(0.05), // Medical blue
                  Color(0xff42A5F5).withOpacity(0.03), // Medical blue (lighter)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff1E88E5),
                        Color(0xff42A5F5)
                      ], // Medical blue gradient
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xff1E88E5), // Medical blue
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  // Helper method to build modern list tiles
  Widget _buildModernListTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.15),
                          color.withOpacity(0.05)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
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
                  const SizedBox(width: 16),
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
                      color: Color(0xff1E88E5).withOpacity(0.1), // Medical blue
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xff1E88E5), // Medical blue
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Container(
            margin: const EdgeInsets.only(left: 76),
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
      ],
    );
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
        ? Share.share(
            "Hi, Looking for referral bonuses? Download ${GroceryAppConstant.appname} app from this link: https://play.google.com/store/apps/details?id=${GroceryAppConstant.packageName}.\n Don't forget to use my referral code: $mobile")
        : Share.share(
            "Hi, Looking for referral bonuses? Download ${GroceryAppConstant.appname} app from this link: https://play.google.com/store/apps/details?id=${GroceryAppConstant.packageName}");
  }

  _shareIosApp() {
    GroceryAppConstant.isLogin
        ? Share.share(
            "Hi, Looking for referral bonuses? Download ${GroceryAppConstant.appname} app from this link: ${GroceryAppConstant.iosAppLink}.\n Don't forget to use my referral code: ${mobile}")
        : Share.share(
            "Hi, Looking for referral bonuses? Download ${GroceryAppConstant.appname} app from this link:${GroceryAppConstant.iosAppLink}");
  }
}
