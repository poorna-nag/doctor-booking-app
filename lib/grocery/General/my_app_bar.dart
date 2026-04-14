import 'package:flutter/material.dart';
import 'package:ecoshine24/grocery/BottomNavigation/grocery_app_home_screen.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/screen/SearchScreen.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(
        AppBar().preferredSize.height + 10,
      );

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              GroceryAppColors.boxColor1, // Vibrant orange
              Color(0xffFF8A50), // Orange-coral blend
              GroceryAppColors.tela1, // Light orange
            ],
          ),
        ),
      ),
      title: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/images/logo.png',
                height: 24,
                width: 24,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Text(
              GroceryAppConstant.appname,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 8, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserFilterDemo()),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 12, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              showCircle(),
            ],
          ),
        ),
      ],
      /* bottom: PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: Container(

          margin: EdgeInsets.symmetric(horizontal: 10.0),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: InkWell(
//            onTap: () {
//              showSearch(context: context, delegate: DataSerch(SplashScreenState.filteredUsers));
//
//              print('ontap method');
//            },
            child: Material(

              color: AppColors.teladep,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: AppColors.tela,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(

                child:Padding(padding: EdgeInsets.only(top:5.0),
              child:
              TextField(
                  onTap:(){
//                    showSearch(context: context, delegate: DataSerch(SplashScreenState.filteredUsers));


                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserFilterDemo()),
                    );
                  },
    style: TextStyle(
    color: Colors.green[900]),
                decoration: InputDecoration(

                  hintText: 'Search Your Product',
                  hintStyle: TextStyle(color: AppColors.tela),

                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),)),
            ),
          ),
        ),

      ),*/
    );
  }

  Widget showCircle() {
    return Positioned(
      right: 0,
      top: 0,
      child: GroceryAppHomeScreenState.cartvalue > 0
          ? Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GroceryAppColors.boxColor1,
                    GroceryAppColors.tela1
                  ], // Orange gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: GroceryAppColors.boxColor1.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              constraints: BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                '${GroceryAppHomeScreenState.cartvalue}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
