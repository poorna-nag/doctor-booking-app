import 'dart:async';

import 'package:aladdinmart/grocery/General/AppConstant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tracking extends StatefulWidget {
  final String? id;
  final double? lat;
  final double? long;
  const Tracking(
      {super.key, required this.lat, required this.long, required this.id});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  late GoogleMapController controller;
  bool _added = false;
  BitmapDescriptor? icon;

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getIcons();
  }

  StreamSubscription<Position>? _positionStream;
  double? latitude;
  double? longitude;
  late GoogleMapController _controller;

  getCurrentLocation() async {
    setState(() {
      latitude = widget.lat;
      longitude = widget.long;
      print(latitude.toString() + "late");
      print(longitude.toString() + "long");
    });
  }

////////////////////icon image///////////////////////////////////////////////////////////
  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.2),
        "assets/images/car_android.png");
    setState(() {
      this.icon = icon;
    });
  }

///////////////////////////polylines///////////////////////////////////////
  getDirections(double endLocationlatitude, double endLocationlongitude) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GroceryAppConstant.Google_Api_Key,
      // User lat long
      PointLatLng(widget.lat!, widget.long!),
      // Delevary lat long
      PointLatLng(endLocationlatitude, endLocationlongitude),
      travelMode: TravelMode.driving,
      optimizeWaypoints: true,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    setState(() {
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 3,
      );
      polylines[id] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("AssignedOrder")
                .where('name', isEqualTo: widget.id)
                .snapshots(),
            builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
           
              if (snapshot.connectionState == ConnectionState.waiting) {
                Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (_added) {
                myapp(snapshot);
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("Delivery Not Yet Started."));
              }
              snapshot.data!.docs.forEach((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                double lat = data['lat'];
                double lng = data['long'];
                getDirections(lat, lng);
              });
              return GoogleMap(
                  mapType: MapType.terrain,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                        snapshot.data!.docs.singleWhere(
                            (element) => widget.id == element.id)['lat'],
                        snapshot.data!.docs.singleWhere(
                            (element) => widget.id == element.id)['long'],
                      ),
                      zoom: 15),
                  markers: {
                    Marker(
                      markerId: MarkerId("marker_1"),
                      position: LatLng(
                        latitude!,
                        longitude!,
                      ),
                      infoWindow: InfoWindow(title: 'user'),
                    ),
                    Marker(
                      icon: icon!,
                      markerId: MarkerId("marker_1"),
                      position: LatLng(
                        snapshot.data!.docs.singleWhere(
                            (element) => widget.id == element.id)['lat'],
                        snapshot.data!.docs.singleWhere(
                            (element) => widget.id == element.id)['long'],
                      ),
                      infoWindow: InfoWindow(title: 'driver'),
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) async {
                    setState(() {
                      _controller = controller;
                      _added = false;
                    });
                  },
                  polylines: Set<Polyline>.of(polylines.values));
            }));
  }

  Future<void> myapp(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs
                  .singleWhere((element) => widget.id == element.id)['lat'],
              snapshot.data!.docs
                  .singleWhere((element) => widget.id == element.id)['long'],
            ),
            zoom: 14.7)));
  }
}
