import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapService extends GetxService {
  final Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);
  final Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  final Rx<double> mapZoom = Rx<double>(15.0);

  static MapService get to => Get.find();

  Future<MapService> init() async {
    return this;
  }

  void setSelectedLocation(LatLng location) {
    selectedLocation.value = location;
  }

  void setCurrentLocation(double lat, double lng) {
    currentLocation.value = LatLng(lat, lng);
    if (selectedLocation.value == null) {
      selectedLocation.value = currentLocation.value;
    }
  }

  void updateZoom(double zoom) {
    mapZoom.value = zoom;
  }

  double calculateDistance(LatLng start, LatLng end) {
    const Distance distance = Distance();
    return distance(start, end) / 1000;
  }
}
