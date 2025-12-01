import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/services/location_service.dart';
import '../../../core/services/map_service.dart';

class LocationController extends GetxController {
  final LocationService locationService = Get.find();
  final MapService mapService = Get.find();

  final RxBool isTracking = RxBool(false);
  final RxList<LatLng> locationHistory = RxList<LatLng>();

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    final position = await locationService.getCurrentPosition();
    if (position != null) {
      mapService.setCurrentLocation(position.latitude, position.longitude);
      locationHistory.add(LatLng(position.latitude, position.longitude));
    }
  }

  void startLocationTracking() {
    isTracking.value = true;
    locationService.getLocationStream().listen((position) {
      final latLng = LatLng(position.latitude, position.longitude);
      mapService.setCurrentLocation(position.latitude, position.longitude);
      locationHistory.add(latLng);
      if (locationHistory.length > 100) locationHistory.removeAt(0);
    });
  }

  void stopLocationTracking() {
    isTracking.value = false;
  }

  void selectLocationOnMap(LatLng location) {
    mapService.setSelectedLocation(location);
  }

  double? calculateDistanceToSelected(LatLng selectedLocation) {
    final current = mapService.currentLocation.value;
    if (current != null) return mapService.calculateDistance(current, selectedLocation);
    return null;
  }

  Future<void> requestLocationPermission() async {
    await locationService.checkLocationPermission();
  }

  Future<void> openLocationSettings() async {
    await locationService.openLocationSettings();
  }
}