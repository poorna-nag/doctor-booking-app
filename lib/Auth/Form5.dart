/*
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dinesafe/Util/AppConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';

class Form4 extends StatefulWidget {

  @override
  _Form4State createState() => _Form4State();
}

class _Form4State extends State<Form4> {

  var _formKey4=GlobalKey<FormState>();

  final pnameController = TextEditingController();
  final discriptionController = TextEditingController();


  final resignofcause = TextEditingController();
  String _dropDownValue1;
  Future<File> profileImg;

  Position currentLocation;
  LatLng _center ;
   String  title="";

  getUserLocation() async {
    currentLocation = await locateUser();
    print(currentLocation.longitude);
    print(currentLocation.latitude);
    final coordinates = new Coordinates(currentLocation.latitude, currentLocation.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      title=first.addressLine;
      print(first.addressLine);
      print(first.adminArea);
      print(first.coordinates);
      print(first.featureName);
      print(first.countryCode);
      print(first.locality);
      print(first.postalCode);

//      print(currentLocation.latitude.toString()+ currentLocation.longitude.toString()+"my");
      // call hotel list befalf of lat and long
    });

  }
  @override
  void initState() {
    super.initState();
//    getImaformation();
    getUserLocation();

  }



  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;





  _onCameraMove(CameraPosition position) {
    _center = position.target;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
        Marker(
          draggable: true,
          markerId: MarkerId(_center.toString()),
          position: _center,
          onDragEnd:((value) {
            print(value.latitude);
            print(value.longitude);
          }),
          infoWindow: InfoWindow(
            title: 'This is a Title',
            snippet: 'This is a snippet',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          elevation: 0.0,
          backgroundColor: Colors.teal[50],

          title: Text("Forms",style: TextStyle(color: Colors.teal[200]),)
      ),
      body:Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[

                new Container(
                  color: Color(0xffFFFFFF),
                  child: Form(
                    key: _formKey4,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
//                          profile(context),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Person Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child:  TextFormField(
                                      controller:pnameController,
                                      validator: (String value){
                                        if(value.isEmpty){
                                          return " Please enter the Persion name";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),


                                    ),
                                  ),
                                ],
                              )),

                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Shop Address',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(

                                child: new TextFormField(
                                    maxLines: 2,
                                    keyboardType: TextInputType.text, // Use mobile input type for emails.
                                    controller: discriptionController,
                                    validator: (String value){
                                      print("Length${value.length}");
                                      if(value.isEmpty && value.length>10){
                                        return " Please enter the  discription";
                                      }
                                    },


                                    decoration: new InputDecoration(
                                      hintText: 'Discription',
                                      labelText: 'Enter the Discription',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54, width: 3.0),
                                      ),

//                                      icon: new Icon(Icons.queue_play_next),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54, width: 3.0),
                                      ),
                                    )

                                )
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.all(4.0),
                            height: 250,


                            child: Stack(
                              children: <Widget>[
                                currentLocation!=null?

                                Container(
                                  child: GoogleMap(
                                    initialCameraPosition:CameraPosition(target:LatLng(currentLocation.latitude,currentLocation.longitude),zoom:16.0 ) ,
                                    markers: Set<Marker>.of(
                                      <Marker>[
                                        Marker(
                                          draggable: true,
                                          markerId: MarkerId("1"),
                                          position: _center,
                                          icon: BitmapDescriptor.defaultMarker,
                                          infoWindow: const InfoWindow(
//                                            title: '$title',
                                          ),
                                        )
                                      ],
                                    ),
                                    onCameraMove: _onCameraMove,
                                    zoomGesturesEnabled: true,
                                  ),
                                ):Center(child: CircularProgressIndicator(),),
//                                GoogleMap(
//                                  onMapCreated: _onMapCreated,
//                                  initialCameraPosition: CameraPosition(
//                                    target: _center1,
//                                    zoom: 11.0,
//                                  ),
//                                  mapType: _currentMapType,
//                                  markers: _markers,
//                                  onCameraMove: _onCameraMove,
//                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      children: <Widget>[
                                        button(_onMapTypeButtonPressed, Icons.map),
                                        SizedBox(
                                          height: 16.0,
                                        ),
                                        button(_onAddMarkerButtonPressed, Icons.add_location),
                                        SizedBox(
                                          height: 16.0,
                                        ),
//                                        button(_goToPosition1, Icons.location_searching),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),


                            */
/*currentLocation!=null?

                            Container(
                              child: GoogleMap(
                                initialCameraPosition:CameraPosition(target:LatLng(_center.latitude,_center.longitude),zoom:16.0 ) ,

                                zoomGesturesEnabled: true,
                              ),
                            ):Center(child: CircularProgressIndicator(),),*/
/*

                          ),



                          _getActionButtons() ,
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),);
  }


  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }


  Widget _getActionButtons() {
    return  Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
//
//            Navigator.push(context,
//                new MaterialPageRoute(builder: (context) => Form2()));
          },
          color: AppColors.primary,
          padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24))),
          child: Text(
            "Next", style:TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold),

          ),
        ),
      ),

    );


  }

//

}
*/
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:aladdinmart/Auth/signup.dart';
import 'package:aladdinmart/Auth/widgets/CustomeAppbar2.dart';
import 'package:aladdinmart/General/AppConstant.dart';
import 'package:aladdinmart/model/RegisterModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class MyMap1 extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap1> {
  String? shopname,
      shopcat,
      username,
      email,
      mobile,
      shopadd,
      locality,
      city,
      state,
      pincode,
      permanentadd,
      password,
      cont_persionname,
      franchise,
      user_id,
      documenttype,
      documentnumber,
      docimage,
      pan_number,
      panImage,
      firmnumber,
      firmImage,
      gstnumber,
      gstImage;

  // Future<void> getvalue() async {
  //   SharedPreferences pre = await SharedPreferences.getInstance();
  //   String shopname1= pre.getString("shopanme");
  //   String shopcat1= pre.getString("category");
  //   String username1= pre.getString("username");
  //   String email1= pre.getString("email");
  //   String mobile1= pre.getString("mobile");
  //
  //   String password1= pre.getString("password");
  //   String cont_persionname1= pre.getString("contactpersionname");
  //   String userid1= pre.getString("user_id");
  //   String franchise1= pre.getString("franchise");
  //   String shopadd1= pre.getString("shopaddresss");
  //   String locality1= pre.getString("locality");
  //   String city1= pre.getString("city");
  //   String state1= pre.getString("state");
  //   String pincode1= pre.getString("pincode");
  //   String permanentadd1= pre.getString("parmanentaddress");
  //
  //
  //   // String documentnumber1= pre.getString("docnumber");
  //   // String documenttype1= pre.getString("doctype");
  //   // String docimage1= pre.getString("documentImage");
  //   // String pan_number1= pre.getString("pancardno");
  //   // String panImage1= pre.getString("panImage");
  //   // String firmnumber1= pre.getString("firmNo");
  //   // String firmImage1= pre.getString("firmImage");
  //   // String gstnumber1= pre.getString("gstNo");
  //   // String gstImage1= pre.getString("gstImage");
  //   setState(() {
  //     shopname=shopname1;
  //     shopcat=shopcat1;
  //     username=username1;
  //     email=email1;
  //     mobile=mobile1;
  //     password=password1;
  //     cont_persionname=cont_persionname1;
  //     franchise=franchise1;
  //     user_id=userid1;
  //     shopadd=shopadd1;
  //     locality=locality1;
  //     city=city1;
  //     state=state1;
  //     pincode=pincode1;
  //     permanentadd=permanentadd1;
  //     // documentnumber=documentnumber1;
  //     // documenttype=documenttype1;
  //     // docimage=docimage1;
  //     // pan_number=pan_number1;
  //     // panImage=panImage1;
  //     // firmnumber=firmnumber1;
  //     // firmImage=firmImage1;
  //     // gstnumber= gstnumber1;
  //     // gstImage= gstImage1;
  //
  //   });
  // }

  GoogleMapController? _controller;

  SharedPreferences? pref;

  Position? position;
  Widget? _child;
  double? lat, long;
  bool flag = false;
  String? shop_id;

  Future<void> getvalue12() async {
    pref = await SharedPreferences.getInstance();
    String shopname1 = pref!.getString("shopid12").toString();
    setState(() {
      shop_id = shopname1;
    });
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
          draggable: true,
          onDragEnd: ((position) {
            setState(() {
              lat = position.latitude;
              long = position.longitude;

              print(lat);
              print(long);
            });
            getAddress();
          }),
          markerId: MarkerId('home1234'),
          position: LatLng(position!.latitude, position!.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: '${lat}  ${long}'))
    ].toSet();
  }

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
//        timeInSecForIos: 1,
        backgroundColor: Color(0xFFff1717),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void initState() {
    // getLocation();
    _getCurrentLocation();
    getvalue12();
    // getvalue();
    // _getCurrentLocation();
    super.initState();
  }

  // Future<void> getLocation() async {
  //   PermissionStatus permission = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.location);

  //   if (permission == PermissionStatus.denied) {
  //     await PermissionHandler()
  //         .requestPermissions([PermissionGroup.locationAlways]);
  //   } else if (permission == PermissionStatus.granted) {
  //     _getCurrentLocation();
  //     showToast('Access granted');
  //   }

  //
  // GeolocationStatus geolocationStatus =
  // await geolocator.checkGeolocationPermissionStatus();
  //
  // switch (geolocationStatus) {
  //   case GeolocationStatus.denied:
  //     showToast('denied');
  //     break;
  //   case GeolocationStatus.disabled:
  //     showToast('disabled');
  //     break;
  //   case GeolocationStatus.restricted:
  //     showToast('restricted');
  //     break;
  //   case GeolocationStatus.unknown:
  //     showToast('unknown');
  //     break;
  //   case GeolocationStatus.granted:
  //     showToast('Access granted');
  //     _getCurrentLocation();
  // }
  // }

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      lat = position!.latitude;
      long = position!.longitude;
      FoodAppConstant.latitude = lat!;
      FoodAppConstant.longitude = long!;

      getAddress();
      print(lat);
      print(long);
      _child = _mapWidget();
    });
  }

  String? valArea;
  getAddress() async {
    print("rahul lay ${lat}");
    var addresses = await placemarkFromCoordinates(lat!, long!);
    log("address get ------------->>" + addresses[0].toString());
    var first = addresses.first;
    setState(() {
      valArea = first.name;
      valArea = valArea.toString() + ',' + first.subLocality.toString();
      valArea = valArea.toString() + ',' + first.locality.toString();
      valArea = valArea.toString() + ',' + first.administrativeArea.toString();
      valArea = valArea.toString() + ',' + first.country.toString();
      valArea = valArea.toString() + ',' + first.postalCode.toString();

      print(valArea);
      pref!.setString("address", valArea!);
      pref!.setString("lat", lat.toString());
      pref!.setString("lng", long.toString());
      pref!.setString("pin", first.postalCode.toString());
      pref!.setString("city", first.locality.toString());
    });
    // print(
    //     ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return first;
  }

  // void _updatePosition(CameraPosition _position) {
  //   Position newMarkerPosition = Position(
  //       latitude: _position.target.latitude,
  //       longitude: _position.target.longitude);
  //   Marker marker = markers["home"];
  //
  //   setState(() {
  //     markers["home"] = marker.copyWith(
  //         positionParam: LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude));
  //   });
  // }
  Widget _mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: _createMarker(),
      // onCameraMove: ((position) => _updatePosition(position)),
      initialCameraPosition: CameraPosition(
        target: LatLng(position!.latitude, position!.longitude),
        zoom: 16.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
        // _setStyle(controller);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//         appBar: AppBar(
// //          backgroundColor: AppColors.tela,
// //        backgroundColor: Colors.blue,
//           title: Text('Update Location',textAlign: TextAlign.center,style: TextStyle(color: CupertinoColors.white),),
//         ),
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Opacity(opacity: 0.88, child: CustomAppBar2()),
          Container(
            height: 400,
            child: _child,
          ),
          Container(
            margin: EdgeInsets.all(10),
            // height: 400,
            child: Text(valArea != null ? valArea.toString() : ""),
          ),
          flag ? circularIndi() : Row(),
          SizedBox(
            height: 20,
          ),
          _getActionButtons(),
        ],
      ),
    ));
  }

  Widget _getActionButtons() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: FoodAppColors.tela,
            padding: EdgeInsets.only(top: 12, left: 10, right: 10, bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
          ),
          onPressed: () {
            print(lat);
            print(long);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );

            // updatelocation( lat, long );
            // _registerData();
          },
          child: Text(
            "OK",
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future updatelocation(double latitude, double longitide) async {
    setState(() {
      flag = true;
    });
    print(latitude);
    print(longitide);
    String link = FoodAppConstant.base_url +
        "api/cp.php?shop_id=" +
        shop_id.toString() +
        "&lat=" +
        latitude.toString() +
        "&lng=" +
        longitide.toString();
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
      print(jsonDecode(response.body));
      showLongToast(user.message.toString());
      // Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()),);
    }
//    print("List Size: ${list.length}");
  }

/*  Future _registerData() async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    print(shopname);
    print(Constant.API_KEY);
    print(username);
    print(password);
    print(shopcat);
    print(cont_persionname);
    print(city);
    print(pincode);
    print(mobile);
    // print(_dropDownValue1);
    print(locality);
    print(email);
    print(user_id);
    print(franchise);
    print(shop_id);
    var map = new Map<String, dynamic>();
    map['shop']=shopname;
    map['address']=shopadd;
//    map['X-Api-Key']=Constant.API_KEY;
    map['user']=username;
    map['pass']=password;
    map['cat']=shopcat;
    map['name']=cont_persionname;
    map['loc']=locality;
    map['city']=city;
    map['pin']=pincode;
    map['email']=email;
    map['mobile']=mobile;
    map['permanent_address']=permanentadd;
    map['franchise']=franchise;
    map['added_by']=user_id;
    map['shop_id']==shop_id;
    final response = await http.post(Constant.base_url+'api/save-cpreg.php',body:map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody);
      CpRegistration user = CpRegistration.fromJson(jsonDecode(response.body));
      if(user.message.toString()=="Registration is Successful")
      {
        showLongToast(user.message);
        pref.setString("shopid12", user.shop_id);


        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),);



      }
      else {
        showLongToast(user.message);
//        Navigator.push(context,
//            new MaterialPageRoute(builder: (context) => Form3()));


      }

    } else
      throw Exception("Unable to get Employee list");
//    _showLongToast("You have no changes");
  }*/

  Widget circularIndi() {
    return Align(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
