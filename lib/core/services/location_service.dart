import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationService extends GetxService {
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final Rx<String> currentAddress = Rx<String>('Mengambil lokasi...');
  final Rx<bool> isLocationLoading = Rx<bool>(false);
  final Rx<bool> hasLocationPermission = Rx<bool>(false);

  static LocationService get to => Get.find();

  Future<LocationService> init() async {
    await checkLocationPermission();
    return this;
  }

  Future<bool> checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      hasLocationPermission.value =
          permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always;

      return hasLocationPermission.value;
    } catch (e) {
      // Gunakan Get.log untuk production
      Get.log('Error checking location permission: $e');
      return false;
    }
  }

  Future<Position?> getCurrentPosition() async {
    try {
      isLocationLoading.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      bool hasPermission = await checkLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permissions are denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      currentPosition.value = position;
      await getAddressFromLatLng(position.latitude, position.longitude);

      return position;
    } catch (e) {
      Get.log('Error getting location: $e');
      currentAddress.value = 'Gagal mendapatkan lokasi';
      return null;
    } finally {
      isLocationLoading.value = false;
    }
  }

  Future<void> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        currentAddress.value =
            '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}';
      } else {
        currentAddress.value = 'Alamat tidak ditemukan';
      }
    } catch (e) {
      Get.log('Error getting address: $e');
      currentAddress.value = 'Gagal mendapatkan alamat';
    }
  }

  Stream<Position> getLocationStream() {
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10, // Update setiap 10 meter
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}
