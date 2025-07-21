import 'package:flutter/material.dart';
import 'package:aladdinmart/grocery/BottomNavigation/grocery_app_home_screen.dart';
import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:aladdinmart/grocery/screen/SearchScreen.dart';

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
      title: Center(child: Image.asset('assets/images/logo.png')),
      elevation: 0.0,
      backgroundColor: GroceryAppColors.tela,
      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: Icon(
          Icons.menu,
          color: GroceryAppColors.categoryicon,
        ),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserFilterDemo()),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(top: 10, right: 30),
            child: Icon(
              Icons.search,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),
        Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10, right: 30),
              child: Icon(
                Icons.add_shopping_cart,
                color: Colors.black,
                size: 25,
              ),
            ),
            showCircle(),
          ],
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
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(left: 15, bottom: 35),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: GroceryAppColors.homeiconcolor,
          ),
          child: Text('${GroceryAppHomeScreenState.cartvalue}', style: TextStyle(color: Colors.white, fontSize: 10.0)),
        ),
      ),
    );
  }
}
