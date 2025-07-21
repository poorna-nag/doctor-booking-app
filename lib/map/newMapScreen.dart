// import 'dart:async';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_geofire/flutter_geofire.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:aladdinmart/map/availabledrivers.dart';
// import 'package:aladdinmart/map/GerofireAssitance.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:aladdinmart/map/getDirectionss.dart';
// import 'package:aladdinmart/map/requestAssitance.dart';

// class NewMainScreen extends StatefulWidget {
//   final String order_id;
//   final String lat;
//   final String long;
//   final String mv_lat;
//   final String mv_long;
//   NewMainScreen(this.order_id, this.lat, this.long, this.mv_lat, this.mv_long);
//   @override
//   MainState createState() {
//     // TODO: implement createState
//     return MainState();
//   }
// }

// class MainState extends State<NewMainScreen>
//     with
//         AutomaticKeepAliveClientMixin<NewMainScreen>,
//         TickerProviderStateMixin {
//   bool opendrawer = true;

//   var scaffkey = new GlobalKey<ScaffoldState>();
//   var bottompadding = 0.0;
//   Completer<GoogleMapController> _completer = Completer();
//   GoogleMapController? newGoogleMapcontroller;
//   Position? currentPosition;
//   List<LatLng> platlngcordinates = [];
//   Set<Polyline> polylineset = {};
//   Set<Marker> markerset = {};
//   Set<Circle> circleset = {};
//   bool nearbyAvailabledriver = false;
//   BitmapDescriptor? nearbyIcon;
//   DatabaseReference? requestRideRefernce;
//   static final CameraPosition position = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//   double searchContainerHeight = 300.0;
//   double ridercontainerHeight = 0;
//   double riderRequestingcontainerHeight = 0;
//   double _latitude = 0;
//   double _longitude = 0;
//   double _latitude1 = 0;
//   double _longitude1 = 0;

//   @override
//   void initState() {
//     _latitude = double.parse(widget.mv_lat);
//     _longitude = double.parse(widget.mv_long);
//     print("widget.mv_lat  ${widget.mv_lat}");
//     print("(widget.mv_lat  ${widget.mv_long}");
//     // TODO: implement initState
//     super.initState();
//     setState(() {
//       _latitude = double.parse(widget.mv_lat);
//       _longitude = double.parse(widget.mv_long);
//       placesDirection(context);
//       addMaker();
//     });

//     // getCurrenuser();
//   }

//   void getCurrenuser() {
//     FirebaseDatabase.instance
//         .reference()
//         .child("AssignedOrder")
//         .child("${widget.order_id ?? ""}")
//         .once()
//         .then((DataSnapshot snapshot) {
//       setState(() {
//         var ky = snapshot.key;
//         var username = snapshot.value;
//         print("username:" + snapshot.value["name"]);
//         var lat = snapshot.value["lat"];
//         var lng = snapshot.value["long"];

//         _latitude = lat;
//         _longitude = lng;
//         placesDirection(context);
//         addMaker();
//         //currentUserInfo.name=snapshot.value["name"];
//         // new  Users(name: snapshot.value["name"],
//         //     email: snapshot.value["email"],
//         //     phone: snapshot.value["phone"]);
//       });
//     } as FutureOr Function(DatabaseEvent value));
//   }

//   void getCurrenuser1() {
//     FirebaseDatabase.instance
//         .reference()
//         .child("AssignedOrder")
//         .child("${widget.order_id}")
//         .once()
//         .then((DataSnapshot snapshot) {
//       setState(() {
//         var ky = snapshot.key;
//         var username = snapshot.value;
//         print("username1:" + snapshot.value["name"]);
//         var lat = snapshot.value["lat"];
//         var lng = snapshot.value["long"];

//         _latitude1 = lat;
//         _longitude1 = lng;
//         addMaker();
//         // placesDirection(context);
//         // addMaker();
//         //currentUserInfo.name=snapshot.value["name"];
//         // new  Users(name: snapshot.value["name"],
//         //     email: snapshot.value["email"],
//         //     phone: snapshot.value["phone"]);
//       });
//     } as FutureOr Function(DatabaseEvent value));
//   }

//   void hanldeRidercontainer() async {
//     await placesDirection(context);
//     setState(() {
//       opendrawer = false;
//       searchContainerHeight = 0.0;
//       ridercontainerHeight = 240;
//       bottompadding = 230;
//     });
//   }

//   void riderRequest() {
//     setState(() {
//       opendrawer = true;
//       searchContainerHeight = 0.0;
//       ridercontainerHeight = 0.0;
//       riderRequestingcontainerHeight = 250.0;
//       bottompadding = 230;
//     });
//   }

//   void cancelride() {
//     requestRideRefernce?.remove();
//   }

//   void resetride() {
//     setState(() {
//       opendrawer = true;
//       polylineset.clear();
//       markerset.clear();
//       circleset.clear();
//       platlngcordinates.clear();
//       searchContainerHeight = 300.0;
//       ridercontainerHeight = 0.0;
//       riderRequestingcontainerHeight = 0.0;
//       bottompadding = 230;
//     });
//     locationUpdate();
//   }

//   locationUpdate() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     currentPosition = position;
//     CameraPosition cameraPosition = new CameraPosition(
//       target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
//       zoom: 19.0,
//     );
//     newGoogleMapcontroller
//         ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//     // String address = await AssitanceMethods.searchGeocoding(currentPosition, context);
//     // print("your address:" + address);
//     initGeofierlistner();
//   }

//   @override
//   Widget build(BuildContext context) {
//     creatMarker();
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       key: scaffkey,
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         // overflow: Overflow.visible,
//         fit: StackFit.loose,
//         alignment: Alignment.topCenter,
//         children: [
//           Container(
//             width: width,
//             height: height,
//             child: GoogleMap(
//               initialCameraPosition: position,
//               mapType: MapType.normal,
//               myLocationButtonEnabled: true,
//               zoomGesturesEnabled: true,
//               padding: EdgeInsets.only(bottom: bottompadding),
//               myLocationEnabled: true,
//               zoomControlsEnabled: true,
//               onMapCreated: (GoogleMapController _controller) {
//                 _completer.complete(_controller);
//                 newGoogleMapcontroller = _controller;
//                 setState(() {
//                   bottompadding = 30.0;
//                 });
//                 locationUpdate();
//               },
//               polylines: polylineset,
//               markers: markerset,
//               circles: circleset,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Future<void> placesDirection(BuildContext context) async {
//     // var initpos = Provider
//     //     .of<AppData>(context, listen: false)
//     //     .pickloation;
//     // var finalpos = Provider
//     //     .of<AppData>(context, listen: false)
//     //     .dropoffLocation;

//     var picklatlng = LatLng(_latitude, _longitude);
//     var dropplatlng = LatLng(
//         double.parse(widget.lat ?? "0"), double.parse(widget.long ?? "0"));
//     // showDialog(context: context,
//     //     builder: (BuildContext context) =>
//     //         ProgressDialog(message: "Please wait...",));
//     var details = await getPlacesDirections(picklatlng, dropplatlng);
//     // setState(() {
//     //   _getplaceDirection = details;
//     // });
//     // Navigator.pop(context);
//     print("placeEndpoints:" + details!.ecodedpoints.toString());
//     platlngcordinates.clear();
//     PolylinePoints polylinePoints = PolylinePoints();
//     List<PointLatLng> decodepointltlng =
//         polylinePoints.decodePolyline(details.ecodedpoints);
//     if (decodepointltlng.isNotEmpty) {
//       decodepointltlng.forEach((PointLatLng pointLatLng) {
//         print("pointLatLng.latitude  ${pointLatLng.latitude}");
//         platlngcordinates
//             .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
//       });
//     }
//     polylineset.clear();
//     setState(() {
//       Polyline polyline = Polyline(
//         polylineId: PolylineId("polyid"),
//         color: Colors.pink,
//         width: 5,
//         endCap: Cap.roundCap,
//         geodesic: true,
//         points: platlngcordinates,
//       );
//       polylineset.add(polyline);
//     });
//     LatLngBounds latLngBounds;
//     if (picklatlng.latitude > dropplatlng.latitude &&
//         picklatlng.longitude > dropplatlng.longitude) {
//       latLngBounds =
//           LatLngBounds(southwest: dropplatlng, northeast: picklatlng);
//     } else if (picklatlng.longitude > dropplatlng.longitude) {
//       latLngBounds = LatLngBounds(
//           southwest: LatLng(picklatlng.latitude, dropplatlng.longitude),
//           northeast: LatLng(dropplatlng.latitude, picklatlng.longitude));
//     } else if (picklatlng.latitude > dropplatlng.latitude) {
//       latLngBounds = LatLngBounds(
//           southwest: LatLng(dropplatlng.latitude, picklatlng.longitude),
//           northeast: LatLng(picklatlng.latitude, dropplatlng.longitude));
//     } else {
//       latLngBounds =
//           LatLngBounds(southwest: picklatlng, northeast: dropplatlng);
//     }
//     newGoogleMapcontroller!
//         .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
//     Marker pickmarker = Marker(
//         markerId: MarkerId("markid"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
//         position: picklatlng,
//         infoWindow: InfoWindow(
//             title: " initpos.placesName", snippet: "PickupLocation"));

//     Marker dropoffmarker = Marker(
//         markerId: MarkerId("dropoffid"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         position: dropplatlng,
//         infoWindow: InfoWindow(
//             title: " finalpos.placesName", snippet: "DropOffLocation"));
//     Circle pickcircle = Circle(
//         circleId: CircleId("pickcid"),
//         fillColor: Colors.blue,
//         center: picklatlng,
//         radius: 20.0,
//         strokeWidth: 3);
//     Circle dropoffcircle = Circle(
//         circleId: CircleId("dropoffid"),
//         fillColor: Colors.yellow,
//         center: dropplatlng,
//         radius: 20.0,
//         strokeWidth: 3);
//     markerset.add(pickmarker);
//     markerset.add(dropoffmarker);
//     circleset.add(pickcircle);
//     circleset.add(dropoffcircle);
//   }

//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;

//   void initGeofierlistner() {
//     Geofire.initialize("AssignedOrder");
//     Geofire.queryAtLocation(
//             currentPosition!.latitude, currentPosition!.longitude, 10)
//         .listen((map) {
//       print("map123 ${map}");
//       if (map != null) {
//         var callBack = map['callBack'];
//         //latitude will be retrieved from map['latitude']
//         //longitude will be retrieved from map['longitude']

//         switch (callBack) {
//           case Geofire.onKeyEntered:
//             //keysRetrieved.add(map["key"]);

//             NearbyAvailableDrivers nearbyAvailableDrivers =
//                 new NearbyAvailableDrivers();
//             nearbyAvailableDrivers.key = map["key"];
//             nearbyAvailableDrivers.latitude = map["lat"];
//             nearbyAvailableDrivers.longititude = map["long"];
//             GeoFireAssitance.listofnearbyavailabledrivers
//                 .add(nearbyAvailableDrivers);
//             if (nearbyAvailabledriver == true) {
//               addMaker();
//             }
//             break;

//           case Geofire.onKeyExited:
//             //  keysRetrieved.remove(map["key"]);
//             GeoFireAssitance.removeNearbydriver(map["key"]);
//             addMaker();
//             break;

//           case Geofire.onKeyMoved:
//             NearbyAvailableDrivers nearbyAvailableDrivers =
//                 new NearbyAvailableDrivers();
//             nearbyAvailableDrivers.key = map["key"];
//             nearbyAvailableDrivers.latitude = map["lat"];
//             nearbyAvailableDrivers.longititude = map["long"];
//             GeoFireAssitance.updateNearbydriver(nearbyAvailableDrivers);
//             //  GeoFireAssitance.listofnearbyavailabledrivers.add(nearbyAvailableDrivers);
//             // Update your key's location
//             addMaker();
//             break;

//           case Geofire.onGeoQueryReady:
//             // All Intial Data is loaded
//             print(map['result']);
//             addMaker();
//             break;
//         }
//       }

//       setState(() {});
//     });
//   }

//   updatelatlog() {
//     LatLng driverposition = LatLng(_latitude1, _longitude1);
//     print("Marker123");
//     Set<Marker> tmaker = Set<Marker>();
//     Marker marker = Marker(
//         markerId: MarkerId("driver${"driverskey"}"),
//         position: driverposition,
//         //rotation: AssitanceMethods.creatnumer(360),
//         icon: nearbyIcon);
//     tmaker.add(marker);
//     if (this.mounted)
//       setState(() {
//         CameraPosition camerposition =
//             new CameraPosition(target: driverposition, zoom: 17);
//         newGoogleMapcontroller!
//             .animateCamera(CameraUpdate.newCameraPosition(camerposition));
//         markerset.removeWhere(
//             (maker) => maker.markerId.value == "driver${"driverskey"}");
//         print("maker mahshshhdd");

//         markerset = tmaker;
//         print("Marker133 ${markerset}");
//       });
//   }

//   void addMaker() {
//     print('_latitude1 ${_latitude1.toString()}');
//     print('_latitude1 ${_longitude1.toString()}');

//     LatLng driverposition = LatLng(_latitude1, _longitude1);
//     print("Marker123");
//     Set<Marker> tmaker = Set<Marker>();
//     Marker marker = Marker(
//         markerId: MarkerId("driver${"driverskey"}"),
//         position: driverposition,
//         //rotation: AssitanceMethods.creatnumer(360),
//         icon: nearbyIcon);
//     tmaker.add(marker);
//     if (this.mounted)
//       setState(() {
//         // CameraPosition camerposition=new CameraPosition(target:driverposition ,zoom: 17);
//         // newGoogleMapcontroller.animateCamera(CameraUpdate.newCameraPosition(camerposition));
//         markerset.removeWhere(
//             (maker) => maker.markerId.value == "driver${"driverskey"}");
//         print("maker mahshshhdd");

//         markerset = tmaker;
//         print("Marker133 ${markerset}");
//       });
//   }

//   void creatMarker() {
//     if (nearbyIcon == null) {
//       print("Marker");
//       ImageConfiguration configuration =
//           createLocalImageConfiguration(context, size: Size(2, 2));
//       BitmapDescriptor.fromAssetImage(
//               configuration, "assets/images/car_android.png")
//           .then((value) {
//         nearbyIcon = value;
//       });
//     }
//   }

//   String mapkey = "AIzaSyDi2Q098E82Zl8PrReTL2eY9vh5xhsNFHQ";

//   Future<GetplaceDirection?> getPlacesDirections(
//       LatLng initialpos, LatLng destinpos) async {
//     String url =
//         "https://maps.googleapis.com/maps/api/directions/json?origin=${initialpos.latitude},${initialpos.longitude}&destination=${destinpos.latitude},${destinpos.longitude}&key=${mapkey}";
//     var res = await RequestAssitance.getRequest(url);
//     if (res == "failed") {
//       return null;
//     }
//     GetplaceDirection getplaceDirection = new GetplaceDirection();
//     getplaceDirection.ecodedpoints =
//         res["routes"][0]["overview_polyline"]["points"];

//     getplaceDirection.durationvalue =
//         res["routes"][0]["legs"][0]["duration"]["value"];
//     getplaceDirection.durationText =
//         res["routes"][0]["legs"][0]["duration"]["text"];

//     getplaceDirection.distancevalue =
//         res["routes"][0]["legs"][0]["distance"]["value"];
//     getplaceDirection.distanceText =
//         res["routes"][0]["legs"][0]["distance"]["text"];
//     print("getplacedetails:" + getplaceDirection.ecodedpoints.toString());
//     return getplaceDirection;
//   }
// }
