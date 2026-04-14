import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecoshine24/constent/app_constent.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/dbhelper/CarrtDbhelper.dart';
import 'package:ecoshine24/grocery/screen/ShowAddress.dart';
import 'package:ecoshine24/grocery/General/Home.dart';

import 'package:shared_preferences/shared_preferences.dart';

class WishList extends StatefulWidget {
  final bool? check;

  const WishList({Key? key, this.check}) : super(key: key);
  @override
  WishlistState createState() => WishlistState();
}

class WishlistState extends State<WishList> with TickerProviderStateMixin {
  final DbProductManager dbmanager = new DbProductManager();
  static List<ProductsCart>? prodctlist;
  static List<ProductsCart>? prodctlist1;
  double totalamount = 0;

  bool islogin = false;
  bool isLoading = true;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    islogin = pref.getBool("isLogin") ?? false;
    setState(() {
      GroceryAppConstant.isLogin = islogin;
    });
  }

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    gatinfo();
    _loadCartData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _loadCartData() async {
    setState(() {
      isLoading = true;
      totalamount = 0;
    });

    dbmanager.getProductList().then((usersFromServe) {
      if (this.mounted) {
        setState(() {
          prodctlist1 = usersFromServe;
          isLoading = false;

          for (var i = 0; i < prodctlist1!.length; i++) {
            totalamount =
                totalamount + double.parse(prodctlist1![i].pprice ?? "0");
          }
          GroceryAppConstant.totalAmount = totalamount;
          GroceryAppConstant.itemcount = prodctlist1!.length;
        });

        // Start animations after data loads
        _fadeController.forward();
        _slideController.forward();
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoading = false;
          prodctlist1 = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8FBFF), // Medical light background
      appBar: _buildModernAppBar(),
      body: isLoading
          ? _buildLoadingState()
          : prodctlist1 == null || prodctlist1!.isEmpty
              ? _buildEmptyState()
              : _buildCartContent(),
      floatingActionButton:
          (prodctlist1?.isNotEmpty ?? false) ? _buildFloatingCheckout() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff1E88E5), // Medical blue primary
              Color(0xff42A5F5), // Medical blue secondary
              Color(0xff64B5F6), // Medical blue light
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xff1E88E5).withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: Container(
        margin: EdgeInsets.only(left: 8),
        child: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => GroceryApp()),
              (route) => false,
            );
          },
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 22,
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Appointments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              if (!isLoading && prodctlist1 != null)
                Text(
                  '${prodctlist1!.length} ${prodctlist1!.length == 1 ? 'service' : 'services'} booked',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: [
        if (prodctlist1?.isNotEmpty ?? false)
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.delete_sweep, color: Colors.white, size: 22),
              ),
              onPressed: _showClearCartDialog,
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xff1E88E5).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1E88E5)),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Loading your appointments...',
            style: TextStyle(
              color: Color(0xff2C3E50),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please wait',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff1E88E5).withOpacity(0.1),
                      Color(0xff42A5F5).withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xff1E88E5).withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff1E88E5).withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.event_busy_rounded,
                  size: 80,
                  color: Color(0xff1E88E5),
                ),
              ),
              SizedBox(height: 32),
              Text(
                'No Appointments Yet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2C3E50),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'You haven\'t booked any medical\nservices yet. Start exploring!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
              SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff1E88E5),
                      Color(0xff42A5F5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff1E88E5).withOpacity(0.4),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => GroceryApp()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.medical_services, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Browse Services',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
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
  }

  Widget _buildCartContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            // Medical header info card
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Color(0xffF8FBFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xff1E88E5).withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff1E88E5).withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xff1E88E5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_today_rounded,
                      color: Color(0xff1E88E5),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scheduled Services',
                          style: TextStyle(
                            color: Color(0xff1E88E5),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Review your booked appointments',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff1E88E5),
                          Color(0xff42A5F5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${prodctlist1!.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 8, bottom: 100),
                itemCount: prodctlist1!.length,
                itemBuilder: (context, index) =>
                    _buildModernCartItem(prodctlist1![index], index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCartItem(ProductsCart item, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Dismissible(
        key: Key('${item.id}_${index}'),
        direction: DismissDirection.endToStart,
        background: _buildSwipeBackground(),
        confirmDismiss: (direction) async {
          return await _showDeleteConfirmation(item.pname ?? 'this service');
        },
        onDismissed: (direction) => _removeItem(item, index),
        child: Card(
          elevation: 2,
          shadowColor: Color(0xff1E88E5).withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Color(0xffF8FBFF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xff1E88E5).withOpacity(0.15),
                width: 1,
              ),
            ),
            padding: EdgeInsets.all(14),
            child: Row(
              children: [
                _buildProductImage(item),
                SizedBox(width: 14),
                Expanded(child: _buildProductDetails(item)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductsCart item) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Color(0xff1E88E5).withOpacity(0.1),
            Color(0xff42A5F5).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Color(0xff1E88E5).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E88E5).withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: CachedNetworkImage(
          imageUrl: '${GroceryAppConstant.Product_Imageurl}${item.pimage}',
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Color(0xffF8FBFF),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Color(0xff1E88E5)),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Color(0xffF8FBFF),
            child: Icon(Icons.medical_services,
                color: Color(0xff1E88E5).withOpacity(0.5), size: 32),
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(ProductsCart item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xff1E88E5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.local_hospital,
                color: Color(0xff1E88E5),
                size: 14,
              ),
            ),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                item.pname ?? 'Medical Service',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2C3E50),
                  letterSpacing: 0.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        if (item.pcolor?.isNotEmpty ?? false)
          _buildAttributeChip('Type: ${item.pcolor}', Icons.category_outlined),
        if (item.psize?.isNotEmpty ?? false)
          _buildAttributeChip(
              'Duration: ${item.psize}', Icons.access_time_rounded),
        SizedBox(height: 10),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff1E88E5),
                    Color(0xff42A5F5),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '\u{20B9}${item.pprice}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            SizedBox(width: 8),
            // if (item.discountValue != null &&
            //     double.parse(item.discountValue!) > 0)
            //   Container(
            //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         colors: [
            //           Color(0xff4CAF50),
            //           Color(0xff66BB6A),
            //         ],
            //       ),
            //       borderRadius: BorderRadius.circular(8),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Color(0xff4CAF50).withOpacity(0.3),
            //           blurRadius: 4,
            //           offset: Offset(0, 2),
            //         ),
            //       ],
            //     ),
            //     child: Row(
            //       children: [
            //         Icon(
            //           Icons.local_offer,
            //           color: Colors.white,
            //           size: 12,
            //         ),
            //         SizedBox(width: 4),
            //         Text(
            //           'Save ₹${item.discountValue}',
            //           style: TextStyle(
            //             fontSize: 11,
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ],
            //     ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttributeChip(String text, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Color(0xff1E88E5).withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(0xff1E88E5).withOpacity(0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Color(0xff1E88E5)),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xff2C3E50),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Quantity stepper removed as per client requirement

  Widget _buildSwipeBackground() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffEF5350), Color(0xffE53935)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xffE53935).withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.delete_forever, color: Colors.white, size: 26),
          ),
          SizedBox(height: 6),
          Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCheckout() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff1E88E5),
                Color(0xff42A5F5),
                Color(0xff64B5F6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Color(0xff1E88E5).withOpacity(0.5),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: InkWell(
            onTap: _proceedToCheckout,
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total Fee',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '\u{20B9}${totalamount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Book Now',
                          style: TextStyle(
                            color: Color(0xff1E88E5),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(width: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods for cart operations
  Future<bool?> _showDeleteConfirmation(String itemName) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.delete_outline, color: Colors.red, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Remove Item',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to remove $itemName from your cart?',
            style: TextStyle(color: Colors.grey[600]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[400]!, Colors.red[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Remove',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.clear_all, color: Colors.red, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Clear Cart',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to remove all items from your cart?',
            style: TextStyle(color: Colors.grey[600]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[400]!, Colors.red[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _clearAllItems();
                },
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _clearAllItems() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    for (var item in prodctlist1!) {
      dbmanager.deleteProducts(item.id!);
    }

    setState(() {
      prodctlist1!.clear();
      totalamount = 0;
      GroceryAppConstant.totalAmount = 0;
      GroceryAppConstant.itemcount = 0;
      GroceryAppConstant.groceryAppCartItemCount = 0;
      AppConstent.cc = 0;
      pref.setInt("cc", 0);
    });

    _showToast('Cart cleared successfully');
  }

  void _removeItem(ProductsCart item, int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    dbmanager.deleteProducts(item.id!);

    setState(() {
      prodctlist1!.removeAt(index);
      double itemPrice = double.parse(item.pprice ?? "0");
      totalamount -= itemPrice;
      GroceryAppConstant.totalAmount -= itemPrice;
      GroceryAppConstant.itemcount--;
      GroceryAppConstant.groceryAppCartItemCount =
          GroceryAppConstant.groceryAppCartItemCount > 0
              ? GroceryAppConstant.groceryAppCartItemCount - 1
              : 0;
      AppConstent.cc = AppConstent.cc > 0 ? AppConstent.cc - 1 : 0;
      pref.setInt("cc", AppConstent.cc);
    });

    _showToast('${item.pname ?? "Item"} removed from cart');
    groceryCartItemCount(GroceryAppConstant.groceryAppCartItemCount);
  }

  void _proceedToCheckout() {
    if (GroceryAppConstant.itemcount > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShowAddress("0")),
      );
    } else {
      _showToast('Please add some products first!');
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  Future<void> groceryCartItemCount(int count) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("itemCount", count);
  }

  // Quantity handlers removed as per client requirement
}
