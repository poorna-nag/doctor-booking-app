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
    });
  }

  @override
  void initState() {
    super.initState();
    GroceryAppConstant.isLogin = false;
    gatinfo();
  }

  @override
  Widget build(BuildContext context) {
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
            expandedHeight: 280,
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
                      Color(0xff42A5F5),
                      Color(0xff64B5F6),
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
                            width: 110,
                            height: 110,
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
                              radius: 52,
                              child: ClipOval(
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
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
          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  // Quick Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.shopping_bag_outlined,
                          count: "0",
                          label: "Orders",
                          gradient: LinearGradient(
                            colors: [Color(0xff1E88E5), Color(0xff42A5F5)],
                          ),
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
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.star_outline,
                          count: "0",
                          label: "Reviews",
                          gradient: LinearGradient(
                            colors: [Color(0xffFF9800), Color(0xffFFB74D)],
                          ),
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
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.location_on_outlined,
                          count: "0",
                          label: "Address",
                          gradient: LinearGradient(
                            colors: [Color(0xff4CAF50), Color(0xff66BB6A)],
                          ),
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
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Account Section
                  _buildSectionTitle("Account Settings"),
                  SizedBox(height: 12),
                  _buildMenuCard([
                    _buildMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      title: "My Bookings",
                      subtitle: "View your order history",
                      color: Color(0xff1E88E5),
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
                    _buildMenuItem(
                      icon: Icons.edit_outlined,
                      title: "Edit Profile",
                      subtitle: "Update your information",
                      color: Color(0xff42A5F5),
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
                    ),
                    _buildMenuItem(
                      icon: Icons.location_on_outlined,
                      title: "My Addresses",
                      subtitle: "Manage delivery addresses",
                      color: Color(0xff4CAF50),
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
                    _buildMenuItem(
                      icon: Icons.lock_outline,
                      title: "Change Password",
                      subtitle: "Update your password",
                      color: Color(0xffFF9800),
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
                      showDivider: false,
                    ),
                  ]),
                  SizedBox(height: 20),
                  // Support Section
                  _buildSectionTitle("Support & Info"),
                  SizedBox(height: 12),
                  _buildMenuCard([
                    _buildMenuItem(
                      icon: Icons.headset_mic_outlined,
                      title: "Contact Us",
                      subtitle: "Get in touch with us",
                      color: Color(0xff1E88E5),
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
                    _buildMenuItem(
                      icon: Icons.share_outlined,
                      title: "Share App",
                      subtitle: "Invite friends and family",
                      color: Color(0xff9C27B0),
                      onTap: () {
                        Platform.isAndroid
                            ? _shareAndroidApp()
                            : _shareIosApp();
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: "About Us",
                      subtitle: "Learn more about us",
                      color: Color(0xff4CAF50),
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
                    _buildMenuItem(
                      icon: Icons.privacy_tip_outlined,
                      title: "Privacy Policy",
                      subtitle: "Read our privacy policy",
                      color: Color(0xff607D8B),
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
                    _buildMenuItem(
                      icon: Icons.description_outlined,
                      title: "Terms & Conditions",
                      subtitle: "View terms of service",
                      color: Color(0xff795548),
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
                      showDivider: false,
                    ),
                  ]),
                  SizedBox(height: 20),
                  // Logout Button
                  GestureDetector(
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
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: GroceryAppConstant.isLogin
                            ? Color(0xFFFFEBEE)
                            : Color(0xffE3F2FD),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: GroceryAppConstant.isLogin
                              ? Color(0xFFEF5350).withOpacity(0.3)
                              : Color(0xff1E88E5).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            GroceryAppConstant.isLogin
                                ? Icons.logout
                                : Icons.login,
                            color: GroceryAppConstant.isLogin
                                ? Color(0xFFEF5350)
                                : Color(0xff1E88E5),
                          ),
                          SizedBox(width: 12),
                          Text(
                            GroceryAppConstant.isLogin ? "Logout" : "Login",
                            style: TextStyle(
                              color: GroceryAppConstant.isLogin
                                  ? Color(0xFFEF5350)
                                  : Color(0xff1E88E5),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Footer
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff1E88E5).withOpacity(0.1),
                          Color(0xff42A5F5).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "🇮🇳 Proudly Made in India 🇮🇳",
                          style: TextStyle(
                            color: Color(0xff1E88E5),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Version 1.0.0",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // New Helper Methods for Redesigned UI
  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff1E88E5), Color(0xff42A5F5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.only(left: 78),
            child: Divider(
              height: 1,
              color: Colors.grey[200],
            ),
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
        ? Share.share("Hi, Looking for referral bonuses? Download " +
            GroceryAppConstant.appname +
            " app from this link: https://play.google.com/store/apps/details?id=${GroceryAppConstant.packageName}.\n Don't forget to use my referral code: $mobile")
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
}
