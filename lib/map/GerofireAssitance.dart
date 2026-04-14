import 'package:ecoshine24/map/availabledrivers.dart';

class GeoFireAssitance {
  static List<NearbyAvailableDrivers> listofnearbyavailabledrivers = [];

  static void removeNearbydriver(String key) {
    int index = listofnearbyavailabledrivers
        .indexWhere((element) => element.key == key);
    listofnearbyavailabledrivers.removeAt(index);
  }

  static void updateNearbydriver(NearbyAvailableDrivers drivers) {
    int index = listofnearbyavailabledrivers
        .indexWhere((element) => element.key == drivers.key);
    listofnearbyavailabledrivers[index].latitude = drivers.latitude;
    listofnearbyavailabledrivers[index].longititude = drivers.longititude;
  }
}
